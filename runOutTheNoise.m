function runOutTheNoise(kpsExtraction,DataSets)

clc;
close all;

addpathFILE;

jsmoothstr= {'R+','E+','Pr+','R-','E-','Pr-'};
jsmooth={1,2,3,4,5,6};
longSmooth=size(jsmooth,2);

sigmabasePerc={1,5,10};%percent INTERVAL MINIMUM SIZE =3*sigmabase
longIntsize=size(sigmabasePerc,2);

%% ds
% DataSets={'Gun_Point_TEST'};

nomeDS=DataSets;%num2str(cell2mat((DataSets(1,1))));
[namematrix1,data11]=importfile1(['./data/' nomeDS '.csv']);  % import matrix dataset
DSfull=data11';
numberOfseries=10;%size(DSfull,2); % Number of series in DS (rows)
lengthSeries=size(DSfull,1)-1; % Length of the series in DS (columns)
DatasetWithOutLabel=DSfull(2:end,:);
labelsOriginal=DSfull(1,:);
 % it counts the total number of the clasdses
    quantityClss=arrayfun( @(x)sum(labelsOriginal==x), unique(labelsOriginal));
    numClassi=length(quantityClss);

%% DIR
pathINdex=['./data/',nomeDS,'1d/'];

% % it checks the directories
if ~exist(['./data/',nomeDS])
    mkdir(['./data/',nomeDS]);
    mkdir(['./data/',nomeDS,'1d/']);
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
        pathFeatures=strcat('./data/',nomeDS,'1d/',nomeDS,'percentagewin_',num2str(intervalPercentage),'/');
        thresholdLength=round((lengthSeries/100)*(intervalPercentage*3)); %INTERVAL MINIMUM SIZE =3*sigmabase
        for num=1:numberOfseries
            generateFeaturesSeries(DatasetWithOutLabel,nomeDS,...
                num,thresholdLength,pathFeatures);
            num
        end
    end
end
%%

nRun=50;
for ids=1:50
    % it counts the total number of the clasdses
    quantityClss=arrayfun( @(x)sum(DSfull(1,:)==x), unique(DSfull(1,:) ));
    numClassi=length(quantityClss);
    %%%%%%
    chosenIndx=labelsOriginal;
    
    
    for jids=1:longIntsize
        
        intervalPercentage=(cell2mat((sigmabasePerc(1,jids))));
        pathFeatures=strcat('./data/',nomeDS,'1d/',nomeDS,'percentagewin_',num2str(intervalPercentage),'/');
        thresholdLength=round((lengthSeries/100)*(intervalPercentage*3));
        sigmabase=lengthSeries/100*intervalPercentage;%(segWidth/2);
        
        %RANDOM
        %------------------------random
        [dataRandom,chosenIndx]=randomSTC(DSfull,ids,nomeDS,pathINdex);
        labelsRandom=DSfull(1,chosenIndx);
        quantityClss=arrayfun( @(x)sum(labelsRandom==x), unique(labelsRandom ));
        dataNolabelsRandom=dataRandom(2:end);
%         dataNolabelsRandom=DatasetWithOutLabel;
        
        %smoothing datasetsmoothed contains all smoothed ds
        [datasetsmoothed]=executetest(intervalPercentage,dataNolabelsRandom,...
            longSmooth,nomeDS, pathFeatures,ids,sigmabase,...
            chosenIndx,thresholdLength,numberOfseries);

        %it saves the Random dataset 
        csvwrite(strcat(['./data/',nomeDS,'1d/'],nomeDS,'_Random_', num2str(ids)), dataRandom');
% %         mmmm
        for js=1:longSmooth
            sst=num2str(cell2mat((jsmoothstr(1,js))));
            pathSmooth=strcat('./data/',nomeDS,'1d/',nomeDS,'percentagewin_',num2str(intervalPercentage),'_',sst,'/');
            datasetsmoothed2=datasetsmoothed{1,js};
            %save
            % it creates the folder if it doesn't exist already
            pathmatrix2=['./data/' nomeDS '/percentagewin_' num2str(intervalPercentage) '_' sst  '/' ];
            
            if ~exist(pathmatrix2, 'dir')
                mkdir(pathmatrix2);
            end
            csvwrite(strcat(pathmatrix2,nomeDS,'_', num2str(intervalPercentage), '_smth_',sst,'numRun_',num2str(ids)), [labels;datasetsmoothed2]);
            v=plot(datasetsmoothed2);
            fignome=[pathmatrix2,nomeDS,'_', num2str(intervalPercentage), '_smth_',sst,'numRun_',num2str(ids)];
            save_fig(gcf, fignome, 'eps');
            pause(3)
            datasetsmoothed2=[];
        end
        clear datasetsmoothed;
% %         %--------------------------------------------------
% %         %      % compute the dataset based on the global PR
% %         %         finestra=numwindowsusr;%round(Ms/numwindowsusr);
% %         %         timeGlobalPR=tic;
% %         
        datasetsmoothedPR=DSFixedSmoothGlobal(datanolabels,nomeDS,intervalPercentage);
% %         %         datasetsmoothedPR=DSFixedSmooth(datanolabels,nomeDS,sigmabase);
% %         % store the matrix
% % %         size(labels)
% % %         size(datasetsmoothedPR)
% % %         nnnn
        csvwrite(strcat(['./data/' nomeDS '/percentagewin_' num2str(intervalPercentage) '_Pr+/' ],'Global_percentage_', num2str(intervalPercentage)),[labels;datasetsmoothedPR]);
% %         %save the figure
% %         h=plot(datasetsmoothedPR);
% %         fignome=['./data/', nomeDS ,'/percentagewin_', num2str(intervalPercentage), '_Pr+/','Global_percentage_', num2str(intervalPercentage)];
% %         save_fig(gcf, fignome, 'eps');
        clear datasetsmoothedPR;
        sizeDS(1)=lengthSeries;%Ms;
                
    end
    
       %Classification
    classificationAll(DataSets,sizeDS,sigmabasePerc,jsmoothstr,numClassi,ids,quantityClss,nRun,ids);
    
    
    
end



