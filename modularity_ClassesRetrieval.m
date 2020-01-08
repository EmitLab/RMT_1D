function modularity_ClassesRetrieval()
clc;
close all;
addpathFILE;

jsmoothstr= {'R+','E+','Pr+','R-','E-','Pr-'};
jsmooth={1,2,3,4,5,6};
longSmooth=size(jsmooth,2);

cKs=[2,1,3];%[2,1,3];

sigmabasePerc={1,5,10};%percent INTERVAL MINIMUM SIZE =3*sigmabase
longIntsize=size(sigmabasePerc,2);

Entr=[];
%lighiting 11.
nomeDS='coffee';%'Gun_Point_TEST';%'FaceFour_TEST';%Lighting2_TEST';

%'ECG200_TEST';%'Trace_TEST';
% [namematrix1,data11]=importfile1(['./data/' nomeDS '.csv']);  % import matrix dataset
% DSfull=data11';

pathDistances=['./data/' nomeDS '/DistancesDTW/'];
pathRaw=['./data/',nomeDS,'/Raw/'];
pathFixed=['./data/' nomeDS '/FIXED/'];

for ids=1:2%35%50
    dsID=ids;
    
    nomefile=['_Random_', num2str(dsID)];
    
    DSRaw2=csvread(strcat(pathRaw,nomeDS,nomefile));
    %        size(DSRaw)
    labelsnotOrdered=DSRaw2(:,1);
    
    DSRaw=xlsread(strcat(pathDistances,'DTW_',nomeDS,nomefile,'.xls'),'RAW');
    size(DSRaw)
    clear DSRaw2;
    [ktma1,ktmb1] =distanceClass(DSRaw,'RAW',nomefile,nomeDS,labelsnotOrdered);
    ids
    %
    %     [datanolabels,labels]=randomRetireved(nomeDS,dsID);
    for jids=1:longIntsize
        intervalPercentage=(cell2mat((sigmabasePerc(1,jids))));
        intervalPercentageSTRING=num2str(intervalPercentage);%(cell2mat((xlsKTM(1,jids))));
        %global
        DSFix=xlsread(strcat(pathDistances,'DTW_',nomeDS,nomefile,'.xls'),['FIXED',intervalPercentageSTRING]);
        
        [ktma2,ktmb2] =distanceClass(DSFix,['FIXED',intervalPercentageSTRING],nomefile,nomeDS,labelsnotOrdered);
        clear DSFix;
        smoothdistances=[];
        for c=1:length(cKs)
            cTs=cKs(c);
            initialVars = who;
            for js=1:3
                DSSmooth=[];
                smoothdist=[];
                
                sst=num2str(cell2mat((jsmoothstr(1,js))));
                
                sheet1=[num2str(intervalPercentage),sst,'c',num2str(cTs)];
               
                sstmin=num2str(cell2mat((jsmoothstr(1,js+3))));
                
                sheet2=[num2str(intervalPercentage),sstmin,'c',num2str(cTs)];
                
                DSSmoothPlus=xlsread(strcat(pathDistances,'DTW_',nomeDS,nomefile,'.xls'),sheet1);
                [ktma3,ktmb3] =distanceClass(DSSmoothPlus,sheet1,nomefile,nomeDS,labelsnotOrdered);
                
                DSSmoothMinus=xlsread(strcat(pathDistances,'DTW_',nomeDS,nomefile,'.xls'),sheet2);
                [ktma4,ktmb4]=distanceClass(DSSmoothMinus,sheet2,nomefile,nomeDS,labelsnotOrdered);
                
                numClasses=length(unique(labelsnotOrdered));
                WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[ktma1;ktma2;ktma3;ktma4], ['IIS-Class','c',num2str(cTs)],4);
                WritePARTIAL(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[ktmb1;ktmb2;ktmb3;ktmb4], ['PARTIAL','c',num2str(cTs)],4);
                
                %              WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[ktmb1;ktmb2;ktmb3;ktmb4], 'B',numClasses);
%                 WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[modularity1;modularity2;modularity3;modularity4], ['','c',num2str(cTs) ],2);
                % save it
                %              WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClass1;separationClass2;separationClass3;separationClass4], 'totalSeparationSim',numClasses);
%                 WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[sumsimInClasss1;sumsimInClasss2;sumsimInClasss3;sumsimInClasss4], 'simINclass',numClasses);
                %                         WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[sumdistancesClasss1;sumdistancesClasss2;sumdistancesClasss3;sumdistancesClasss4], 'cohesion',numClasses);
%                 WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[sumTotalClass1;sumTotalClass2;sumTotalClass3;sumTotalClass4],'totPairwiseSim',numClasses);
                % %
%                 WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationtwoClass1;separationtwoClass2;separationtwoClass3;separationtwoClass4], 'sepclass',numClasses);
                % %             WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClassMIN1;separationClassMIN2;separationClassMIN3;separationClassMIN4],'separationMIN',numClasses);
                % %             WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClassMAX1;separationClassMAX2;separationClassMAX3;separationClassMAX4],'separationMAX',numClasses);
                % %                     %%%UNION
                % %             WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClassMeanUNION1;separationClassMeanUNION2;separationClassMeanUNION3;separationClassMeanUNION4], 'sepMeanUnion',numClasses);
                % %             WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClassMinUNION1;separationClassMinUNION2;separationClassMinUNION3;separationClassMinUNION4], 'sepMinUnion',numClasses);
                % %             WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClassMaxUNION1;separationClassMaxUNION2;separationClassMaxUNION3;separationClassMaxUNION4], 'sepMaxUnion',numClasses);
            end
            clearvars('-except', initialVars{:});
            %     [rawdistances;fixdistances;smoothdistPlus;smoothdistMinus]
        end
    end
end

function [ktma1,ktmb1]=distanceClass(DSR,sheet,nomefile,nomeDS,labelsnotOrdered)

DistancesMatrixAll=[];
distancesClasss=[];
% separationClass=[];
matrixDist=[];
matrixC=[];
 
labels=sort(labelsnotOrdered);
orderedlabels=unique(labels);
% separationtwoClass2=[];
% modularity=[];

% DSRNormalized=DSR/max(max(DSR));

clear matrixDist;% matrice1 matrixC ;

numOfClasses=length(orderedlabels);
% clsSpanOut=[];
spanOUT=[];
% DistancesMatrixAll{numOfClasses,numOfClasses}=[];
clsSpanOut2{1,numOfClasses}=[];
for iclsss=1:numOfClasses
    
    alab1=find(labelsnotOrdered==orderedlabels(iclsss));
%     [akt,bkt]=size(DSR);

    for jclsss=1:numOfClasses
        
        alab=find(labelsnotOrdered==orderedlabels(jclsss));
        matrixD=[];
        matrixD2=[];
        matrixD=DSR(alab1,alab);
        
        if iclsss==jclsss
            alab2=find(labelsnotOrdered~=orderedlabels(jclsss));
            matrixD2=DSR(alab1,alab2);

            clsSpan=mean(matrixD,2);
            clsSpanRemain=mean(matrixD2,2);

           
           spanOUT=cat(1, spanOUT, clsSpan./clsSpanRemain);
           clsSpanOut2{1,jclsss}=[mean(clsSpan),mean(clsSpanRemain)];
        end
         

        sumsimInClasss(iclsss,jclsss)=sum(sum(matrixD));
%         DistancesMatrixAll{iclsss,jclsss}=matrixD;
        %%compute the separation
%         separationtwoClass(iclsss,jclsss)=(sum(sum(matrixD)));
        %stores it
        
        %         separationClass(iclsss,jclsss)=(sum(sum(matrice1)))*(1/(cilength*(cjlength)));
    end
%     separationtwoClass2(iclsss)=(sum(sum(separationtwoClass)));
    %     separationClassMINavg(iclsss)=(min(min(separationClassMIN)));
    %     separationClassMAXavg(iclsss)=(max(max(separationClassMAX)));
 

%     clsSpanOut2=cat(1,clsSpanOut2,clsSpanOut);
end
clear DSR clsSpan;
% DistancesMatrixAll
% xMTX=[];
% xMTX2=[];

% for iclsss=1:numOfClasses
%     for jclsss=1:numOfClasses
%         if iclsss~=jclsss
%             clsSpan=mean(DistancesMatrixAll{iclsss,jclsss},2)./DistancesMatrixAll{iclsss,jclsss}(:,1);
%             clsSpan
%         end
%         xMTX=cat(2,xMTX,DistancesMatrixAll{iclsss,jclsss});
%         
%     end
%     xMTX2=cat(1,xMTX2,xMTX);
%     
%     xMTX=[];
% end

% ktma=[];
% ktmb=[];
% sumTotalClass=(sum(sum(xMTX2)));

% class_sparcity1=[];
intra_class=sum(diag(sumsimInClasss))/sum(sum(sumsimInClasss));
inter_class=sum(diag(fliplr(sumsimInClasss)))/sum(sum(sumsimInClasss));


% class_sparcity=[];
% for iclsss=1:numOfClasses
%        for jclsss=1:numOfClasses
%            if jclsss~=iclsss
%            class_sparcity=cat(2,class_sparcity,clsSpanOut2{iclsss,iclsss}./clsSpanOut2{iclsss,jclsss});
%            end
%        end
%        class_sparcity1=cat(1,class_sparcity1,class_sparcity);
%        class_sparcity=[];
% end
% class_sparcity2=mean(class_sparcity1);%colonne
class_sparcity2=mean(spanOUT);
ktma1=[intra_class,inter_class,class_sparcity2];
ktmb1=clsSpanOut2;

 
clear matrixDist matrixD;



function WriteAllEntropy(whatSmooth,randomRun,path,nomeds,percentage,taball,nomesheet,numClasses)
n=numClasses;
jst= {'Raw','Fixed','Smooth+','Smooth-'};
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
nome=['modularity_',nomeds,'prova'];

% vvvvvvvvvvvvv
%     xlwrite(strcat([path nome],'_',nomeds,'.xls'),[quantityClss,nums,sizeS],sheet,[nume,50]);
%     xlwrite(strcat([path nome],'_',nomeds,'.xls'),measures,sheet,[nume,(colum+3)]);

xlwrite(strcat([path nome],'_',nomeds,'.xls'),taball(1,:),sheet,[nume+1,1]);
xlwrite(strcat([path nome],'_',nomeds,'.xls'),jst(1),sheet,[0,1]);
xlwrite(strcat([path nome],'_',nomeds,'.xls'),{'Intra_class','Inter_class','Sparcity'},sheet,[1,1]);
% xlwrite(strcat([path nome],'_',nomeds,'.xls'),num2str(randomRun),sheet,[nume,0]);

for itj=1:3
    columnR=((itj)*n)+((n/2)-1)*(itj);
    
    xlwrite(strcat([path nome],'_',nomeds,'.xls'),taball(itj+1,:),sheet,[nume+1,columnR]);
    xlwrite(strcat([path nome],'_',nomeds,'.xls'),jst(itj+1),sheet,[0,columnR]);
    xlwrite(strcat([path nome],'_',nomeds,'.xls'),{'Intra_class','Inter_class','Sparcity'},sheet,[1,columnR]);
    %     xlwrite(strcat([path nome],'_',nomeds,'.xls'),strcat(num2str(randomRun)),sheet,[nume,0]);
end

% if strcmp(whatSmooth,'E+')==1
% taball
% 
% vvv
% end

function WritePARTIAL(whatSmooth,randomRun,path,nomeds,percentage,taball,nomesheet,numClasses)

n=numClasses;
% jst= {'Raw','Fixed','Smooth+','Smooth-'};
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
nome=['modularity_',nomeds,'prova'];

% vvvvvvvvvvvvv
%     xlwrite(strcat([path nome],'_',nomeds,'.xls'),[quantityClss,nums,sizeS],sheet,[nume,50]);
%     xlwrite(strcat([path nome],'_',nomeds,'.xls'),measures,sheet,[nume,(colum+3)]);

xlwrite(strcat([path nome],'_',nomeds,'.xls'),taball{1},sheet,[nume+1,1]);
% xlwrite(strcat([path nome],'_',nomeds,'.xls'),jst(1),sheet,[0,1]);
xlwrite(strcat([path nome],'_',nomeds,'.xls'),{'class1','Allclass'},sheet,[1,1]);
% xlwrite(strcat([path nome],'_',nomeds,'.xls'),num2str(randomRun),sheet,[nume,0]);

for itj=1:3
    columnR=((itj)*n)+((n/2)-1)*(itj);
    
    xlwrite(strcat([path nome],'_',nomeds,'.xls'),taball{itj+1},sheet,[nume+1,columnR]);
%     xlwrite(strcat([path nome],'_',nomeds,'.xls'),jst(itj+1),sheet,[0,columnR]);
    xlwrite(strcat([path nome],'_',nomeds,'.xls'),{['meanclass',num2str(itj+1)],'meanAllclass'},sheet,[1,columnR]);
    %     xlwrite(strcat([path nome],'_',nomeds,'.xls'),strcat(num2str(randomRun)),sheet,[nume,0]);
end
