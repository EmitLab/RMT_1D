% script testing 
%dataset Olive and gun and trace
clear all;

addpath('./fncmodel');
addpath('./util');
addpath('./ESFtool');
addpath('./ESFtool/matchphase');
addpath('./fncview');
addpath('./Classification/');
% smoothing=4; % all elements

jsmoothstr={'wkps','wil','wpr','wprEucl'};
%{'FaceFour_TEST'};%'Trace_TEST'};%'ECG200_TEST'};%'FaceFour_TEST','Trace_TEST','OSULeaf_TEST'};%,'FaceFour_TEST'};%,'Trace_TEST','CBF_TEST','FaceFour_TEST','ECG200_TEST','OSULeaf_TEST'};
% DataSets={'Lighting7_TEST','Gun_Point_TEST','Lighting2_TEST'};%'Coffee_TEST','FaceFour_TEST','Trace_TEST'};%'OliveOil_TEST','Coffee_TEST'};%};%'CBF_TEST'
% DataSets={'Lighting7_TEST''OliveOil_TEST','FaceFour_TEST','Trace_TEST'};
% numClassi=[7,2,2];,'Lighting2_TEST','Lighting7_TEST''FaceFour_TEST'

intervalsize={10,20,30};
jsmooth={1,2,3,4};
DataSets={'ECG200_TEST'};
numClassi=[2];
sigmaVector={0.25,0.5,1,2,4};

longMtxDS=size(DataSets,2);
longIntsize=size(intervalsize,2);
longSmooth=size(jsmooth,2);
for ids=1:longMtxDS
    nomeDS=num2str(cell2mat((DataSets(1,ids))));
    [namematrix1,data11]=importfile1(['./data/' nomeDS '.csv']);         % import matrix dataset
    data1=data11';
    if exist(['./data/',nomeDS,'1d/'])
        rmdir(['./data/',nomeDS,'1d/'], 's');
        rmdir(['./data/',nomeDS], 's');
    end
    mkdir(['./data/',nomeDS]);
    labels=data1(1,:);
    datanolabels=data1(2:end,:);
    [Ms,Ns]=size(datanolabels);
% %     for jids=1:longIntsize
% %         numwindowsusr=(cell2mat((intervalsize(1,jids))));
% %         pathFeatures=strcat('./data/',nomeDS,'1d/',nomeDS,'sizewin_',num2str(numwindowsusr),'/');
% %         %smoothing datasetsmoothed contains all smoothed ds
% %         [datasetsmoothed,peso]=executetest(numwindowsusr,datanolabels,...
% %                                         longSmooth,nomeDS,1,...
% %                                         pathFeatures);
% % %                  sum(sum(datasetsmoothed{1,1}))
% % %                  sum(sum(datasetsmoothed{1,2}))
% % %                  sum(sum(datasetsmoothed{1,3}))
% % %                  sum(sum(datasetsmoothed{1,4}))
% % 
% % %   ffffffffffffffffffffffff
% %        for js=1:longSmooth
% %             sst=num2str(cell2mat((jsmoothstr(1,js))));
% %             pathSmooth=strcat('./data/',nomeDS,'1d/',nomeDS,'sizewin_',num2str(numwindowsusr),'_',sst,'/');
% %             datasetsmoothed2=datasetsmoothed{1,js};
% %             size(datasetsmoothed2)
% %             %save
% %             % create the folder if it doesn't exist already.ros
% %             pathmatrix2=['./data/' nomeDS '/sizewin_' num2str(numwindowsusr) '_' sst  '/' ];
% % 
% %             if ~exist(pathmatrix2, 'dir')
% %                 mkdir(pathmatrix2);
% %             end
% %             csvwrite(strcat(pathmatrix2,nomeDS,'_', num2str(numwindowsusr), '_smth_',sst), [labels;datasetsmoothed2]);
% %             h=plot(datasetsmoothed2);
% %             fignome=[pathmatrix2,nomeDS,'_', num2str(numwindowsusr), '_smth_',sst];
% %             save_fig(gcf, fignome, 'eps');  
% %             pause(3)
% %             datasetsmoothed2=[];
% %        end
% %        clear datasetsmoothed;
% % 
% %         %      % compute the dataset based on the global PR
% %         finestra=inf;%round(Ms/numwindowsusr);
% %         timeGlobalPR=tic;
% %         datasetsmoothedPR=DSglobalpr(datanolabels,nomeDS,peso,finestra);
% %         timeGPR=toc(timeGlobalPR);
% %         timeGPR1=((timeGPR))/(Ns*Ns);
% %         timeGPR2=repmat(timeGPR1,1,Ns);
% %         %      %store the matrix
% %         csvwrite(strcat(['./data/' nomeDS '/sizewin_' num2str(numwindowsusr) '_wpr/' ],'Global_PR_intervals_', num2str(numwindowsusr)),[labels;datasetsmoothedPR]);
% %         %save the figure
% %         h=plot(datasetsmoothed2);
% %         fignome=['./data/', nomeDS ,'/sizewin_', num2str(numwindowsusr), '_wpr/','Global_PR_intervals_', num2str(numwindowsusr)];
% %         save_fig(gcf, fignome, 'eps');
% %         clear datasetsmoothedPR;
% %     end
finestra=inf;%round(Ms/numwindowsusr);
     sizeDS(ids)=Ms;
     % compute the dataset based on the global entropy
     timeentropy=tic;
     datasetentropy=DSetentropy(datanolabels,nomeDS,finestra);   
     timee=toc(timeentropy);
     timee1=((timee))/(Ns*Ns);
     timee2=repmat(timee1,1,Ns);
%      store the matrix
     csvwrite(strcat(['./data/',nomeDS,'1d/'],'GlobalEntropy'),[labels;datasetentropy]);
     %save the figure
     h=plot(datasetsmoothed2);
     fignome=['./data/',nomeDS,'1d/','GlobalEntropy'];
     save_fig(gcf, fignome, 'eps');
     clear datasetentropy;
end
 sizeDS
 
%Classification
% classificationAll(DataSets,sizeDS,intervalsize,jsmoothstr,numClassi);