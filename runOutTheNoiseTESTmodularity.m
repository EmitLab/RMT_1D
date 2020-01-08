function runOutTheNoiseTESTmodularity(kpsExtraction,DataSets)

clc;
close all;

addpathFILE;

jsmoothstr= {'R+','E+','Pr+','R-','E-','Pr-'};
jsmooth={1,2,3,4,5,6};
longSmooth=size(jsmooth,2);

cKs=[2,1,3];

sigmabasePerc={1,5,10};%percent INTERVAL MINIMUM SIZE =3*sigmabase
longIntsize=size(sigmabasePerc,2);

%% ds
% pathIn='./data/allMatrices4PeriodicityBinary/';
longDS=size(DataSets,2);
for ktm=1:1
    
    nomeDS=DataSets;
    %     nomeDS=num2str(cell2mat((DataSets(1,ktm))));
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
    %%%ERASES the files and directories
    % if exist(['./data/',nomeDS,'1d/']) %&& ids==1
    %     rmdir(['./data/',nomeDS,'1d/'], 's');
    %     rmdir(['./data/',nomeDS], 's');
    %     mkdir(['./data/',nomeDS]);
    % else
    %     mkdir(['./data/',nomeDS]);
    % end
    %% it extract kps AND STORES THEM
    
    if kpsExtraction==1
        for jids=1:longIntsize
            intervalPercentage=(cell2mat((sigmabasePerc(1,jids))));
            
            sigmabase=(lengthSeries/100)*intervalPercentage;
            
            for c=1:length(cKs)
                
                cTs=cKs(c);
                thresholdLength= ceil(cTs*sigmabase);  %round((lengthSeries/100)*(intervalPercentage*3)); %INTERVAL MINIMUM SIZE =3*sigmabase
                sigma0our=(cTs/12)*sigmabase;
                pathFeatures=strcat(pathINdex,nomeDS,'percentagewin_',num2str(intervalPercentage),'_c',num2str(cTs),'/');
                for num=1:numberOfseries
                    generateFeaturesSeries(DatasetWithOutLabel,nomeDS,...
                        num,thresholdLength,pathFeatures,sigma0our,cTs);
                    num
                end
            end
        end
    end
    %%
    
    nRun=1;
    % smoothApproach={'shrinkRadius','addPad'};%legate ad ids
    for ids=1:50
        fprintf('RUNN..  %d \n',ids);
        nomefile=['_Random_', num2str(ids)];
            [dataRandom,chosenIndx]=randomSTC(DSfull,ids,nomeDS,pathINdex);
            labelsRandom=DSfull(1,chosenIndx);
%             quantityClss=arrayfun( @(x)sum(labelsRandom==x), unique(labelsRandom ));
            dataNolabelsRandom=dataRandom(2:end,:);
               xMTX2=ClassificationDTWGlobal(dataNolabelsRandom);
               xlwrite(strcat(pathDistances,'DTW_',nomeDS,nomefile,'.xls'),xMTX2,'RAW',[1,1]);
            
        for jids=1:longIntsize

            intervalPercentage=(cell2mat((sigmabasePerc(1,jids))));
            %         pathFeatures=strcat('./data/',nomeDS,'1d/',nomeDS,'percentagewin_',num2str(intervalPercentage),'/');
            
            sigmabase=(lengthSeries/100)*intervalPercentage;%(segWidth/2);
            
            for c=1:length(cKs)
                initialVars = who;
                
                cTs=cKs(c);
                pathFeatures=strcat(pathINdex,nomeDS,'percentagewin_',num2str(intervalPercentage),'_c',num2str(cTs),'/');
                thresholdLength= ceil(cTs*sigmabase);
                %RANDOM
                %         %------------------------random
                %         dataNolabelsRandom=DatasetWithOutLabel;
                % %              
                
                %smoothing datasetsmoothed contains all smoothed ds
                [datasetsmoothed]=executetest(intervalPercentage,dataNolabelsRandom,...
                    longSmooth,nomeDS, pathFeatures,ids,sigmabase,...
                    chosenIndx,thresholdLength,numberOfseries,cTs);
                
                %         it saves the Random dataset dataRandom
                
                csvwrite(strcat(pathRaw,nomeDS,'_Random_', num2str(ids)), dataRandom');
                % %         mmmm
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
                    
                    csvwrite(strcat(pathmatrix2,fignomeSmooth), [labelsRandom;datasetsmoothed2]);
                    % %                     plot(datasetsmoothed2);
                    % %                     title([nomeDS,' ', num2str(intervalPercentage), ' smth',sst,' numRun',num2str(ids),' c',num2str(cTs)]);
                    % %                     save_fig(gcf,[pathmatrix2 fignomeSmooth], 'eps');
                    % %                     pause(2)
                    %%%     DTW distance
                    xMTX2=ClassificationDTWGlobal(datasetsmoothed2);
                    sheet=[num2str(intervalPercentage),sst,'c',num2str(cTs)];
                    xlwrite(strcat(pathDistances,'DTW_',nomeDS,nomefile,'.xls'),xMTX2,sheet,[1,1]);
                    datasetsmoothed2=[];
                end
                clear datasetsmoothed datasetsmoothed2;
                
            end
            % %         %--------------------------------------------------
            %      % compute the dataset based on the global PR
            
            datasetsmoothedPR=DSFixedSmoothGlobal(dataNolabelsRandom,nomeDS,intervalPercentage);
            
            fignomeFIX=[ 'fixed_', num2str(intervalPercentage),'_Random_', num2str(ids)];
            % store the matrix
            csvwrite(strcat(pathFixed,fignomeFIX),[labelsRandom;datasetsmoothedPR]);
            xMTXFix=ClassificationDTWGlobal(datasetsmoothedPR);
            sheet=['FIXED',num2str(intervalPercentage)];
            xlwrite(strcat(pathDistances,'DTW_',nomeDS,nomefile,'.xls'),xMTXFix,sheet,[1,1]);
            %save the figure
            %h=plot(datasetsmoothedPR);
            %title([ 'fixed ', num2str(intervalPercentage)]);
            %save_fig(gcf, [pathFixed,fignomeFIX], 'eps');
            % %                 clear datasetsmoothedPR;
            %                 sizeDS(1)=length..
            clearvars('-except', initialVars{:});
        end
        
    end
end
