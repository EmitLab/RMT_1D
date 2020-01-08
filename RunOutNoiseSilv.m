%% Reorganize the Rosaria Code Script
function RunOutNoiseSilv()


clc;
close all;

addpathFILE;



DataSets={'coffee','ECG200_TEST','FaceFour_TEST','Gun_Point_TEST','Lighting2_TEST','synthetic_control_TEST'}
kpsExtraction=0; % this flag  allow to run the features extractions
saveSmoothDataset=0;
ClasssificationON=1;
jsmoothstr= {'R+','E+','Pr+','R-','E-','Pr-'};
jsmooth={1,2,3,4,5,6};
longSmooth=size(jsmooth,2);
Alphabethsize=100;
cKs=[1,2,3];
sigmabasePerc={1,2,3,5}%,10};%percent INTERVAL MINIMUM SIZE =3*sigmabase
longIntsize=size(sigmabasePerc,2);
longDS=size(DataSets,2);

for ktm=5:longDS % iterate on datasets
    nomeDS=DataSets{ktm} % get dataset name
    [namematrix1,data11]=importfile1(['./data/datasetTEST/' nomeDS '.csv']);  % import matrix dataset
    
    DSfull=data11';
    numberOfseries=size(DSfull,2); % Number of series in DS (rows)
    lengthSeries=size(DSfull,1)-1; % Length of the series in DS (columns)
    DatasetWithOutLabel=DSfull(2:end,:);
    labelsOriginal=DSfull(1,:);
    % it counts the total number of the clasdses
    quantityClss=arrayfun( @(x)sum(labelsOriginal==x), unique(labelsOriginal));
    numClassi=length(quantityClss);
    
    %% DIR
    pathINdex=['./data/',nomeDS,'1d/'];
    pathRaw=['./data/',nomeDS,'/Raw/'];
    pathFixed=['./data/' nomeDS '/FIXED/'];
    pathDistances=['./data/' nomeDS '/DistancesDTW/'];
    
    % % it checks the directories
    if ~exist(['./data/',nomeDS])
        mkdir(['./data/',nomeDS]);
        mkdir(['./data/',nomeDS,'1d/']);
    end
    
    if ~exist(pathRaw)
        mkdir(pathRaw);
        mkdir(pathFixed);
        mkdir(pathDistances);
    end
    
    if kpsExtraction==1 % features extractions
        for jids=1:1%longIntsize
            intervalPercentage=(cell2mat((sigmabasePerc(1,jids))));
            
            sigmabase=(lengthSeries/100)*intervalPercentage;
            
            for c=1:length(cKs) % for values 1,2,3 of c extract the features and save them in
                
                cTs=cKs(c);
                thresholdLength= ceil(6*cTs*sigmabase);
                %% Rosaria was
%                 thresholdLength=ceil(cTs*sigmabase);   %INTERVAL MINIMUM SIZE =3*sigmabase %%round((lengthSeries/100)*(intervalPercentage*3));
                %% Rosaria Was
%                  sigma0our=(cTs/12)*sigmabase;
               sigma0our=(cTs/2)*sigmabase;
                pathFeatures=strcat(pathINdex,nomeDS,'percentagewin_',num2str(intervalPercentage),'_c',num2str(cTs),'/');
                for num=1:numberOfseries
                    generateFeaturesSeries(DatasetWithOutLabel,nomeDS,num,thresholdLength,pathFeatures,sigma0our,cTs);
                    num
                end
            end
        end
    end
    
    nRun=1;
    for ids=1:50
        fprintf('RUNN..  %d \n',ids);
        nomefile=['_Random_', num2str(ids)];
        %% Rosaria
         [dataRandom,chosenIndx]=randomSTC(DSfull,ids,nomeDS,pathINdex);
        %% Silvestro
%         [dataRandom,chosenIndx]=readRandomSTC(DSfull,ids,nomeDS,pathINdex);
        minimumDS=min(dataRandom(:));
        maximumDS=max(dataRandom(:));
        labelsRandom=DSfull(1,chosenIndx);
        %             quantityClss=arrayfun( @(x)sum(labelsRandom==x), unique(labelsRandom ));
        dataNolabelsRandom=dataRandom(2:end,:);
        %%  save the Random dataset dataRandom
                csvwrite(strcat(pathRaw,nomeDS,'_Random_', num2str(ids)), dataRandom');
        %% compute RAW DTW
        if ClasssificationON==1
            xMTX2=ClassificationDTWGlobal(dataNolabelsRandom);
            xlwrite(strcat(pathDistances,'DTW_',nomeDS,nomefile,'.xls'),xMTX2,'RAW',[1,1]);
        end
        for jids=2:2%longIntsize
            
            intervalPercentage=(cell2mat((sigmabasePerc(1,jids))));
            %         pathFeatures=strcat('./data/',nomeDS,'1d/',nomeDS,'percentagewin_',num2str(intervalPercentage),'/');
            
            sigmabase=(lengthSeries/100)*intervalPercentage;%(segWidth/2);
            
            for c=1:length(cKs)
                initialVars = who;
                
                cTs=cKs(c);
                pathFeatures=strcat(pathINdex,nomeDS,'percentagewin_',num2str(intervalPercentage),'_c',num2str(cTs),'/');
                %% Rosaria moltiplied this by 6 in the script adaptivegaussian
                  thresholdLength= ceil(6*cTs*sigmabase);
%                thresholdLength= ceil(cTs*sigmabase);
           %     sigma0our=(cTs/2)*sigmabase;
                %% This function smooth  the dataset, we should work in this for  computing  hybrid smoothing
                [datasetsmoothed]=executetest(intervalPercentage,dataNolabelsRandom,...
                    longSmooth,nomeDS, pathFeatures,ids,sigmabase,...
                    chosenIndx,thresholdLength,numberOfseries,cTs,minimumDS,maximumDS,Alphabethsize);
                
                
                for js=1:longSmooth
                    sst=num2str(cell2mat((jsmoothstr(1,js))));
                    %             pathSmooth=strcat('./data/',nomeDS,'/',nomeDS,'percentagewin_',num2str(intervalPercentage),'_',sst,'_c',num2str(cTs),'/');
                    datasetsmoothed2=datasetsmoothed{1,js};
                    
                    %save
                    % it creates the folder if it doesn't exist already
                    pathmatrix2=['./data/' nomeDS '/percentagewin_' num2str(intervalPercentage) '_' sst '_c' num2str(cTs) '/' ];
                    
                    if ~exist(pathmatrix2, 'dir')
                        mkdir(pathmatrix2);
                    end
                    fignomeSmooth=[nomeDS,'_', num2str(intervalPercentage), '_smth_',sst,'numRun_',num2str(ids),'_c',num2str(cTs)];
                    
                    csvwrite(strcat(pathmatrix2,fignomeSmooth), [labelsRandom;datasetsmoothed2]);%[labelsRandom(1:6);datasetsmoothed2]);
                    if saveSmoothDataset==1
                        plot(datasetsmoothed2);
                        title([nomeDS,' ', num2str(intervalPercentage), ' smth',sst,' numRun',num2str(ids),' c',num2str(cTs)]);
                        save_fig(gcf,[pathmatrix2 fignomeSmooth], 'eps');
                    end
                    if ClasssificationON==1
                        xMTX2=ClassificationDTWGlobal(datasetsmoothed2);
                        sheet=[num2str(intervalPercentage),sst,'c',num2str(cTs)];
                        xlwrite(strcat(pathDistances,'DTW_',nomeDS,nomefile,'.xls'),xMTX2,sheet,[1,1]);
                    end
                    datasetsmoothed2=[];
                    
                end
                clear datasetsmoothed datasetsmoothed2;
                
            end
            %% compute the dataset based on the global PR
            % work onn this function to see what  it does
            [datasetsmoothedPR,localsigma,locarray]=DSFixedSmoothGlobal(dataNolabelsRandom,nomeDS,intervalPercentage);
            fignomeFIX=[ 'fixed_', num2str(intervalPercentage),'_Random_', num2str(ids)];
            % store the matrix
            csvwrite(strcat(pathFixed,fignomeFIX),[labelsRandom;datasetsmoothedPR]);
            newPathProva=strcat('data/',nomeDS,'/smoothpercent_',num2str(intervalPercentage),'_Fixed/');%['./data/', 'runProva_series/',nomeDS,'/' ];
            if ~exist(newPathProva)
                mkdir(newPathProva);
            end
%         xlwrite(strcat(newPathProva,nomeDS,'_',num2str(num),'_info.xls'));
            xlwrite(strcat(newPathProva,nomeDS,'_', num2str(intervalPercentage),'_info.xls'),localsigma(1,:)','sigma');
            xlwrite(strcat(newPathProva,nomeDS,'_', num2str(intervalPercentage),'_info.xls'),locarray(1,:)','segments');
            if ClasssificationON==1
                xMTXFix=ClassificationDTWGlobal(datasetsmoothedPR);
                sheet=['FIXED',num2str(intervalPercentage)];
                xlwrite(strcat(pathDistances,'DTW_',nomeDS,nomefile,'.xls'),xMTXFix,sheet,[1,1]);
            end
            if saveSmoothDataset==1
                h=plot(datasetsmoothedPR);
                title([ 'fixed ', num2str(intervalPercentage)]);
                save_fig(gcf, [pathFixed,fignomeFIX], 'eps');
                %                           clear datasetsmoothedPR;
                %                            sizeDS(1)=length..
            end
            clearvars('-except', initialVars{:});
        end
    end
end