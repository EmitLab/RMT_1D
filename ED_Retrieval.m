function ED_Retrieval()
clc;
close all;

jsmoothstr= {'R+','E+','Pr+','R-','E-','Pr-'};
jsmooth={1,2,3,4,5,6};
longSmooth=size(jsmooth,2);

cKs=[2,1,3];%[2,1,3];

sigmabasePerc={1,5,10};%percent INTERVAL MINIMUM SIZE =3*sigmabase
longIntsize=size(sigmabasePerc,2);

Entr=[];
%lighiting 11.
nomeDS='coffee';
% [namematrix1,data11]=importfile1(['./data/' nomeDS '.csv']);  % import matrix dataset
% DSfull=data11';

pathDistances=['./data/' nomeDS '/DistancesDTW/'];
pathRaw=['./data/',nomeDS,'/Raw/'];
pathFixed=['./data/' nomeDS '/FIXED/'];

for ids=1:50
    dsID=ids;
    
    nomefile=['_Random_', num2str(dsID)];
    
    DSRaw2=csvread(strcat(pathRaw,nomeDS,nomefile));
    %        size(DSRaw)
    labelsnotOrdered=DSRaw2(:,1);
    DataSetOriginalRandom=DSRaw2(:,2:end)';
    %     DSRaw=xlsread(strcat(pathDistances,'DTW_',nomeDS,nomefile,'.xls'),'RAW');
    size(DSRaw2)
    
    %     [ktma1] =distanceClass(DSRaw,DSRaw2(2:end,:),'RAW',nomefile,nomeDS,labelsnotOrdered);
    %         clear DSRaw2 DSRaw;
    ids
    %
    
    for jids=1:longIntsize
        intervalPercentage=(cell2mat((sigmabasePerc(1,jids))));
        intervalPercentageSTRING=num2str(intervalPercentage);%(cell2mat((xlsKTM(1,jids))));
        %global
        fignomeFIX=[ 'fixed_', num2str(intervalPercentage),'_Random_', num2str(ids)];
        DSFixorg=csvread(strcat(pathFixed,fignomeFIX));
        size(DSFixorg)
        [ktma2] =distanceClass(DSFixorg(3:end,:),DataSetOriginalRandom,['FIXED',intervalPercentageSTRING],nomefile,nomeDS,labelsnotOrdered);
        clear DSFix;
        smoothdistances=[];
        
        for c=1:length(cKs)
            cTs=cKs(c);
            initialVars = who;
            for js=1:3
                DSSmooth=[];
                smoothdist=[];
  
                sst=num2str(cell2mat((jsmoothstr(1,js))));
                pathmatrix2=['./data/' nomeDS '/percentagewin_' num2str(intervalPercentage) '_' sst '_c' num2str(cTs) '/' ];
                sheet1=[num2str(intervalPercentage),sst,'c',num2str(cTs)];
                fignomeSmooth=[nomeDS,'_', num2str(intervalPercentage), '_smth_',sst,'numRun_',num2str(ids),'_c',num2str(cTs)];
                
                sstmin=num2str(cell2mat((jsmoothstr(1,js+3))));
                pathmatrix3=['./data/' nomeDS '/percentagewin_' num2str(intervalPercentage) '_' sstmin '_c' num2str(cTs) '/' ];
                sheet2=[num2str(intervalPercentage),sstmin,'c',num2str(cTs)];
                fignomeSmooth2=[nomeDS,'_', num2str(intervalPercentage), '_smth_',sstmin,'numRun_',num2str(ids),'_c',num2str(cTs)];
                
                DSSmoothPlus=csvread(strcat(pathmatrix2,fignomeSmooth));
                [ktma3] =distanceClass(DSSmoothPlus(2:end,:),DataSetOriginalRandom,sheet1,nomefile,nomeDS,labelsnotOrdered);
                
                DSSmoothMinus=csvread(strcat(pathmatrix3,fignomeSmooth2));
                [ktma4]=distanceClass(DSSmoothMinus(2:end,:),DataSetOriginalRandom,sheet2,nomefile,nomeDS,labelsnotOrdered);
                
                numClasses=length(unique(labelsnotOrdered));
                WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[ktma2;ktma3;ktma4], ['Sep_','c',num2str(cTs)],numClasses);
            end
            clearvars('-except', initialVars{:});
            
        end
    end
end

function [ktma]=distanceClass(DSR,DSRorg,sheet,nomefile,nomeDS,labelsnotOrdered)


clear matrixD;%

numOfClasses=length(labelsnotOrdered);
for iclsss=1:numOfClasses
    
    %     alab1=find(labels==orderedlabels(iclsss));
    rowDs1=DSR(:,iclsss);
%     size(rowDs1)
    for jclsss=1:numOfClasses
        
        rowDs2=DSRorg(:,jclsss);
%         size(rowDs2)
        
        matrixD(iclsss,jclsss)= pdist2(rowDs1',rowDs2','euclidean');
        
    end
    
end
clear DSR DSRorg;

ktma=(mean(mean(matrixD)));

clear matrixD;



function WriteAllEntropy(whatSmooth,randomRun,path,nomeds,percentage,taball,nomesheet,numClasses)
n=numClasses;

jst= {'Fixed','Smooth+','Smooth-'};

switch whatSmooth
    case 'R+'
        colum=1;
        nume=randomRun;
    case 'E+'
        colum=1;
        nume=50+6+randomRun;
    case 'Pr+'
        colum=1;
        nume=50*2+12+randomRun;
end

sheet=[ num2str(percentage) 'percentage_' nomesheet];%[num2str(n),'_',num2str(jsmooth),num2str(percentage) num2str(numwindowsusr)];[num2str(n),'_',num2str(jsmooth),num2str(numwindowsusr)];
nome=['EDorg-smooth_',nomeds,'prova'];


    
xlwrite(strcat([path nome],'_',nomeds,'.xls'),taball(1,:),sheet,[nume,1]);
xlwrite(strcat([path nome],'_',nomeds,'.xls'),jst(1),sheet,[0,1]);
% xlwrite(strcat([path nome],'_',nomeds,'.xls'),num2str(randomRun),sheet,[nume,0]);

for itj=1:2
    columnR=((itj)*n)+(n/2)*(itj);
    xlwrite(strcat([path nome],'_',nomeds,'.xls'),taball(itj+1,:),sheet,[nume,columnR]);
    xlwrite(strcat([path nome],'_',nomeds,'.xls'),jst(itj+1),sheet,[0,columnR]);
    %     xlwrite(strcat([path nome],'_',nomeds,'.xls'),strcat(num2str(randomRun)),sheet,[nume,0]);
end


