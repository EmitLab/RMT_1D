% script testing
%dataset Olive and gun and trace
%function scrptTest()

clear;
clc;
close all;

addpath('./fncmodel');
addpath('./util');
addpath('./ESFtool');
addpath('./ESFtool/matchphase');
addpath('./fncsmooth');
addpath('./Classification/');
% smoothing=4; % all elements
addpath('./Classification/jexcelapi/');
% Add Java POI Libs to matlab javapath
javaaddpath('poi_library/poi-3.8-20120326.jar');
javaaddpath('poi_library/poi-ooxml-3.8-20120326.jar');
javaaddpath('poi_library/poi-ooxml-schemas-3.8-20120326.jar');
javaaddpath('poi_library/xmlbeans-2.3.0.jar');
javaaddpath('poi_library/dom4j-1.6.1.jar');
javaaddpath('poi_library/stax-api-1.0.1.jar');

% jsmoothstr= {'R+','E+','Pr+','R-','E-','Pr-'};
%{};%'Trace_TEST'};%'ECG200_TEST'};%'FaceFour_TEST','Trace_TEST','OSULeaf_TEST'};%,'FaceFour_TEST'};%,'Trace_TEST','CBF_TEST','FaceFour_TEST''OSULeaf_TEST'};
% DataSets={'Lighting7_TEST','Gun_Point_TEST','Lighting2_TEST'};%'Coffee_TEST','FaceFour_TEST','Trace_TEST'};%'OliveOil_TEST','Coffee_TEST'};%};%'CBF_TEST'
% DataSets={'Lighting7_TEST''OliveOil_TEST','FaceFour_TEST','Trace_TEST'};
% numClassi=[7,2,2];,'Lighting2_TEST','Lighting7_TEST''Beef_TEST'
%

% intervalsize={3,5};%percent
% jsmooth={1,2,3,4,5,6};
% DataSets={'ECG200_TEST'};

jsmoothstr= {'R+','E+','Pr+','R-','E-','Pr-'};

sigmabasePerc={1,5,10};%percent INTERVAL MINIMUM SIZE =3*sigmabase
jsmooth={1,2,3,4,5,6};
%synthe 'Coffee_TEST' 'OliveOil_TEST''Coffee_TEST''Beef_TEST''synthetic_control_TEST'
DataSets={'coffee'};
%
% longMtxDS=size(DataSets,2);

longIntsize=size(sigmabasePerc,2);
longSmooth=size(jsmooth,2);

nomeDS=num2str(cell2mat((DataSets(1,1))));
[namematrix1,data11]=importfile1(['./data/' nomeDS '.csv']);  % import matrix dataset
DSfull=data11';

% % it checks the directories
% if ~exist(['./data/',nomeDS,'1d/'])
%     mkdir(['./data/',nomeDS]);
% end
%%%ERASES the files and directories
% if exist(['./data/',nomeDS,'1d/']) %&& ids==1
%     rmdir(['./data/',nomeDS,'1d/'], 's');
%     rmdir(['./data/',nomeDS], 's');
%     mkdir(['./data/',nomeDS]);
% else
%     mkdir(['./data/',nomeDS]);
% end

%%%%%it extract kps AND STORES THEM
% 
% for jids=1:longIntsize
%     intervalPercentage=(cell2mat((sigmabasePerc(1,jids))));
%     pathFeatures=strcat('./data/',nomeDS,'1d/',nomeDS,'percentagewin_',num2str(intervalPercentage),'/');
%     lds=size(DSfull,2);%uuuu 2
% 
%     thresholdLength=round((size(DSfull,1)/100)*(intervalPercentage*3));%INTERVAL MINIMUM SIZE =3*sigmabase
%     for num=1:lds
%         generateFeaturesSeries(DSfull(2:end,:),nomeDS,num,thresholdLength,pathFeatures,intervalPercentage,longIntsize); 
%         %% missed info generateFeaturesSeries(DSfull(2:end,:),nomeDS,num,thresholdLength,pathFeatures,);
%         % Silv added 
%         % ,sigma0our = intervalPercentage
%         % ,cTs = longIntsize);
%         num
%     end
% end

pathINdex=['./data/',nomeDS,'1d/'];

nRun=50;
for ids=40:50
    
    
    % it counts the total number of the clasdses
    quantityClss=arrayfun( @(x)sum(DSfull(1,:)==x), unique(DSfull(1,:) ));
    numClassi=length(quantityClss);
    %------------------------random
    [dataRandom,chosenIndx]=randomSTC(DSfull,ids,nomeDS,pathINdex);
%%%retrieve the old dataset
%      [datanolabels,labels]=randomRetireved(nomeDS,ids);
     
    labels=DSfull(1,chosenIndx);
    quantityClss=arrayfun( @(x)sum(labels==x), unique(labels ));
    datanolabels=DSfull(2:end,chosenIndx);
% % 
    [Ms,Ns]=size(datanolabels);
    
    % loop on the percentage 2
    for jids=1:longIntsize
        
        intervalPercentage=(cell2mat((sigmabasePerc(1,jids))));
        pathFeatures=strcat('./data/',nomeDS,'1d/',nomeDS,'percentagewin_',num2str(intervalPercentage),'/');
        thresholdLength=round((size(DSfull,1)/100)*(intervalPercentage*3));
        %smoothing datasetsmoothed contains all smoothed ds
%         [datasetsmoothed,sigmabase]=executetest(intervalPercentage,datanolabels,longSmooth,       nomeDS,  1,       pathFeatures,ids,chosenIndx,thresholdLength);
        [datasetsmoothed,sigmabase]=executetest(intervalPercentage,datanolabels,longSmooth,       nomeDS, pathFeatures,ids,intervalPercentage,chosenIndx,thresholdLength,1);
%                                     executetest(intervalPercentage,DatasetWithOutLabel,longSmooth,nomeDS,pathFeatures,ids,sigmabase,chosenIndx,thresholdLength,numberOfseries,cTs)
        %                  sum(sum(datasetsmoothed{1,1}))
        %                  sum(sum(datasetsmoothed{1,2}))
        %                  sum(sum(datasetsmoothed{1,3}))
        %                  sum(sum(datasetsmoothed{1,4}))
        %it saves the Random dataset
        csvwrite(strcat(['./data/',nomeDS,'1d/'],nomeDS,'_Random_', num2str(ids)), dataRandom');
        for js=1:longSmooth
            sst=num2str(cell2mat((jsmoothstr(1,js))));
            pathSmooth=strcat('./data/',nomeDS,'1d/',nomeDS,'percentagewin_',num2str(intervalPercentage),'_',sst,'/');
            datasetsmoothed2=datasetsmoothed{1,js};
%             size(datasetsmoothed2)
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
        %--------------------------------------------------
        %      % compute the dataset based on the global PR
        %         finestra=numwindowsusr;%round(Ms/numwindowsusr);
        %         timeGlobalPR=tic;
        
        datasetsmoothedPR=DSFixedSmoothGlobal(datanolabels,nomeDS,intervalPercentage);
        %         datasetsmoothedPR=DSFixedSmooth(datanolabels,nomeDS,sigmabase);
        % store the matrix
%         size(labels)
%         size(datasetsmoothedPR)
%         nnnn
        csvwrite(strcat(['./data/' nomeDS '/percentagewin_' num2str(intervalPercentage) '_Pr+/' ],'Global_percentage_', num2str(intervalPercentage)),[labels;datasetsmoothedPR]);
        %save the figure
        h=plot(datasetsmoothedPR);
        fignome=['./data/', nomeDS ,'/percentagewin_', num2str(intervalPercentage), '_Pr+/','Global_percentage_', num2str(intervalPercentage)];
        save_fig(gcf, fignome, 'eps');
        clear datasetsmoothedPR;
        sizeDS(1)=Ms;
                
    end
    %Classification
    classificationAll(DataSets,sizeDS,sigmabasePerc,jsmoothstr,numClassi,ids,quantityClss,nRun,ids);
    
end
clear all;