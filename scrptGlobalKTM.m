% script testing
%dataset Olive and gun and trace
function scrptGlobalKTM()

clear;
clc;
close all;
addpathFILE();

%{};%'Trace_TEST'};%'ECG200_TEST'};%'FaceFour_TEST','Trace_TEST','OSULeaf_TEST'};%,'FaceFour_TEST'};%,'Trace_TEST','CBF_TEST','FaceFour_TEST''OSULeaf_TEST'};
% DataSets={'Lighting7_TEST','Gun_Point_TEST','Lighting2_TEST'};%'Coffee_TEST','FaceFour_TEST','Trace_TEST'};%'OliveOil_TEST','Coffee_TEST'};%};%'CBF_TEST'
% DataSets={'Lighting7_TEST''OliveOil_TEST','FaceFour_TEST','Trace_TEST'};
% numClassi=[7,2,2];,'Lighting2_TEST','Lighting7_TEST''Beef_TEST'
%
% intervalsize={3,5};%percent
% jsmooth={1,2,3,4,5,6};
% DataSets={'coffee'};

jsmoothstr= {'R+','E+','Pr+','R-','E-','Pr-'};

sigmabasePerc={1,5,10};%percent INTERVAL MINIMUM SIZE =3*sigmabase
jsmooth={1,2,3,4,5,6};


longIntsize=size(sigmabasePerc,2);




nomeDS='Trace_TEST';
pathRaw=['./data/',nomeDS,'/Raw/'];
pathFixed=['./data/' nomeDS '/FIXED/'];
pathDistances=['./data/' nomeDS '/DistancesDTW/'];
for ids=1:50
    
    %------------------------rando
    %%%retrieve the old dataset
    DSfull=csvread([pathRaw nomeDS '_Random_' num2str(ids)]);
    ids
    labelsRandom=DSfull(:,1)';
    nomefile=['_Random_', num2str(ids)];
    
    dataNolabelsRandom=DSfull(:,2:end)';
    
    % %
%     [Ms,Ns]=size(datanolabels);
    
    % loop on the percentage 2
    for jids=1:longIntsize
        
        intervalPercentage=(cell2mat((sigmabasePerc(1,jids))));
 
            
            datasetsmoothedPR=DSFixedSmoothGlobal(dataNolabelsRandom,nomeDS,intervalPercentage);
            
            fignomeFIX=[ 'fixed_', num2str(intervalPercentage),'_Random_', num2str(ids)];
            % store the matrix
            csvwrite(strcat(pathFixed,fignomeFIX),[labelsRandom;datasetsmoothedPR]);
            xMTXFix=ClassificationDTWGlobal(datasetsmoothedPR);
            sheet=['FIXED',num2str(intervalPercentage)];
            xlwrite(strcat(pathDistances,'DTW_',nomeDS,nomefile,'.xls'),xMTXFix,sheet,[1,1]);
            %save the figure
            
            
            h=plot(datasetsmoothedPR);
            title([ 'fixed ', num2str(intervalPercentage)]);
            save_fig(gcf, [pathFixed,fignomeFIX], 'eps');
            clear datasetsmoothedPR;
            pause(1);

    end
    
end
clear all;