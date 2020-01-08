function modularity_ClassesRetrieval()
addpath('./Classification/20130227_xlwrite/20130227_xlwrite/poi_library/');
% addpath('./sumSeriesTest/Classification/20130227_xlwrite/20130227_xlwrite/');

% javaaddpath('./Yair/Utils/JExcelAPI/MXL.jar')
pathlib='./Classification/20130227_xlwrite/20130227_xlwrite/poi_library/';

% javaaddpath(fullfile(matlabroot,'work','./sumSeriesTest/Classification/20130227_xlwrite/20130227_xlwrite/poi_library/'))
%  xlswrite([path nome],tab,foglio);
javaaddpath([pathlib 'poi-3.8-20120326.jar']);
javaaddpath([pathlib 'poi-ooxml-3.8-20120326.jar']);
javaaddpath([pathlib 'poi-ooxml-schemas-3.8-20120326.jar']);
javaaddpath([pathlib 'xmlbeans-2.3.0.jar']);
javaaddpath([pathlib 'dom4j-1.6.1.jar']);
javaaddpath([pathlib 'stax-api-1.0.1.jar']);

javaaddpath('./Classification/jexcelapi/jxl.jar');

addpath('./util/distances');
addpath('./ESFtool');
addpath('./ESFtool/matchphase');
addpath('./fncsmooth');
addpath('./Classification/');
% smoothing=4; % all elements
addpath('./Classification/jexcelapi/');


jsmoothstr= {'R+','E+','Pr+','R-','E-','Pr-'};
addpath(genpath('./Classification/jexcelapi/'));
sigmabasePerc={1,5,10};%percent INTERVAL MINIMUM SIZE =3*sigmabase
% xlsKTM={'one','five','ten'};
jsmooth={1,2,3,4,5,6};
longIntsize=size(sigmabasePerc,2);
longSmooth=size(jsmooth,2);
Entr=[];
%lighiting 11.
nomeDS='sonyaiborobotsurface';
% [namematrix1,data11]=importfile1(['./data/' nomeDS '.csv']);  % import matrix dataset
% DSfull=data11';

for ids=1:1
    
    dsID=ids;
    
    nomefile=['_Random_', num2str(dsID)];
    DSRaw2=csvread(strcat(['./data/',nomeDS,'1d/'],nomeDS,'_Random_', num2str(dsID)));
    %        size(DSRaw)
    labelsnotOrdered=DSRaw2(:,1);
    
    DSRaw=load(strcat(['./data/' nomeDS '/'],'DTW_',nomeDS,nomefile,'RAW'));
    size(DSRaw)
    
    [separationtwoClass1,sumsimInClasss1,sumTotalClass1,modularity1,ktma1,ktmb1] =distanceClass(DSRaw,'RAW',nomefile,nomeDS,labelsnotOrdered);
    ids
    clear DSRaw;
    %     [datanolabels,labels]=randomRetireved(nomeDS,dsID);
    for jids=1:longIntsize
        intervalPercentage=(cell2mat((sigmabasePerc(1,jids))));
        intervalPercentageSTRING=num2str(intervalPercentage);%(cell2mat((xlsKTM(1,jids))));
        %global
        DSFix= load(strcat(['./data/' nomeDS '/'],nomeDS,nomefile,[intervalPercentageSTRING,'_FIXED']));
       
        [separationtwoClass2,sumsimInClasss2,sumTotalClass2,modularity2,ktma2,ktmb2] =distanceClass(DSFix,[intervalPercentageSTRING,'_FIXED'],nomefile,nomeDS,labelsnotOrdered);
        
        smoothdistances=[];
        for js=1:3
            DSSmooth=[];
            smoothdist=[];
            sst=num2str(cell2mat((jsmoothstr(1,js))));
            pathmatrix2=['./data/' nomeDS '/percentagewin_' num2str(intervalPercentage) '_' sst  '/' ];
            sstmin=num2str(cell2mat((jsmoothstr(1,js+3))));
            pathmatrix3=['./data/' nomeDS '/percentagewin_' num2str(intervalPercentage) '_' sstmin  '/' ];
            
            DSSmoothPlus=load(strcat(['./data/' nomeDS '/'],nomeDS,nomefile,[intervalPercentageSTRING,'_',sst]));
            
            [separationtwoClass3,sumsimInClasss3,sumTotalClass3,modularity3,ktma3,ktmb3] =distanceClass(DSSmoothPlus,[intervalPercentageSTRING,'_',sst],nomefile,nomeDS,labelsnotOrdered);
            
            DSSmoothMinus=load(strcat(['./data/' nomeDS '/'],nomeDS,nomefile,[intervalPercentageSTRING,'_',sstmin]));
            
            [separationtwoClass4,sumsimInClasss4,sumTotalClass4,modularity4,ktma4,ktmb4]=distanceClass(DSSmoothMinus,[intervalPercentageSTRING,'_',sstmin],nomefile,nomeDS,labelsnotOrdered);
            
            numClasses=length(unique(labelsnotOrdered));
            WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[ktma1;ktma2;ktma3;ktma4], 'A',numClasses);
            %              WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[ktmb1;ktmb2;ktmb3;ktmb4], 'B',numClasses);
            WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[modularity1;modularity2;modularity3;modularity4], 'modularity',numClasses);
            % save it
            %              WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClass1;separationClass2;separationClass3;separationClass4], 'totalSeparationSim',numClasses);
            WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[sumsimInClasss1;sumsimInClasss2;sumsimInClasss3;sumsimInClasss4], 'simINclass',numClasses);
            %                         WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[sumdistancesClasss1;sumdistancesClasss2;sumdistancesClasss3;sumdistancesClasss4], 'cohesion',numClasses);
            WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[sumTotalClass1;sumTotalClass2;sumTotalClass3;sumTotalClass4],'totPairwiseSim',numClasses);
            % %
            WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationtwoClass1;separationtwoClass2;separationtwoClass3;separationtwoClass4], 'sepclass',numClasses);
            % %             WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClassMIN1;separationClassMIN2;separationClassMIN3;separationClassMIN4],'separationMIN',numClasses);
            % %             WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClassMAX1;separationClassMAX2;separationClassMAX3;separationClassMAX4],'separationMAX',numClasses);
            % %                     %%%UNION
            % %             WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClassMeanUNION1;separationClassMeanUNION2;separationClassMeanUNION3;separationClassMeanUNION4], 'sepMeanUnion',numClasses);
            % %             WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClassMinUNION1;separationClassMinUNION2;separationClassMinUNION3;separationClassMinUNION4], 'sepMinUnion',numClasses);
            % %             WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClassMaxUNION1;separationClassMaxUNION2;separationClassMaxUNION3;separationClassMaxUNION4], 'sepMaxUnion',numClasses);
        end
        
        %     [rawdistances;fixdistances;smoothdistPlus;smoothdistMinus]
    end
    
end

function [separationtwoClass2,sumsimInClasss,sumTotalClass,modularity,ktma1,ktmb1]=distanceClass(DSR,sheet,nomefile,nomeDS,labelsnotOrdered)

DistancesMatrixAll=[];
accsum=0;
distancesClasss=[];
% separationClass=[];
matrixDist=[];
matrixC=[];
% quantityClss=arrayfun( @(x)sum(DSR(1,:)==x), unique(DSR(1,:)));
labels=sort(labelsnotOrdered);
orderedlabels=unique(labels);
separationtwoClass2=[];


clear matrixDist;% matrice1 matrixC ;

numOfClasses=length(orderedlabels);
for iclsss=1:numOfClasses
    
    alab1=find(labels==orderedlabels(iclsss));
    [akt,bkt]=size(DSR);
    %     ci=DSR(2:end,alab);
    %con o senza identita?
    %      cilength=size(ci,1);
    for jclsss=1:numOfClasses
        
        alab=find(labels==orderedlabels(jclsss));
%         if jclsss>iclsss && akt~=bkt
%             alab=alab-1;%tolgo identita'
%         end
        alab(end)=[];
        matrixDist=[];
        matrixD1=[];
        matrixD=[];
        %         cj=classes{jclsss};
        rowD1=[];
        if jclsss==iclsss
            if  akt~=bkt
                
                
                alab(end)=[];%tolgo identita'

                matrixDist=DSR(alab1,alab);
                for mi=1:size(matrixDist,1)
                    
                    rowD1=matrixDist(mi,:);
               
                    normal=max(rowD1);
                    rowD=rowD1./normal;
                    
                    matrixD1=cat(1,matrixD1,rowD);
                    
                end
            else
                matrixDist=DSR(alab1,alab);
                for mi=1:size(matrixDist,1)
                    
                    rowD1=matrixDist(mi,:);
                    %%%indetita'
                    
%                     rowD1(mi)=[];
                    normal=max(rowD1);
                    rowD=rowD1./normal;
                    
                    matrixD1=cat(1,matrixD1,rowD);
                    
                end
                
                
            end
             

            matrixD=(1-matrixD1);

            %%computes within same class
            sumsimInClasss(iclsss)=sum(sum(matrixD));
            clear rowD1 rowD ;
            
        else
            
            matrixDist=DSR(alab1,alab);
            for mi=1:size(matrixDist,1)
                rowD1=matrixDist(mi,:);
                normal=max(rowD1);
                rowD=rowD1./normal;
                
                matrixD1=cat(1,matrixD1,rowD);
                
            end
            matrixD=(1-matrixD1);
        end

        
       
        %%compute the separation
        separationtwoClass(iclsss,jclsss)=(sum(sum(matrixD)));
        %stores it
        DistancesMatrixAll{iclsss,jclsss}=matrixDist;
        %         separationClass(iclsss,jclsss)=(sum(sum(matrice1)))*(1/(cilength*(cjlength)));
    end
    separationtwoClass2(iclsss)=(sum(sum(separationtwoClass)));
    %     separationClassMINavg(iclsss)=(min(min(separationClassMIN)));
    %     separationClassMAXavg(iclsss)=(max(max(separationClassMAX)));
    
end
clear DSR;
% DistancesMatrixAll
xMTX=[];
xMTX2=[];

for iclsss=1:numOfClasses
    for jclsss=1:numOfClasses
        xMTX=cat(2,xMTX,DistancesMatrixAll{iclsss,jclsss});
    end
    xMTX2=cat(1,xMTX2,xMTX);
    xMTX=[];
end
% xlwrite(strcat(['./data/',nomeDS,'1d/'],'DTW_',nomeDS,nomefile,'.xls'),xMTX2,sheet,[1,1]);
% csvwrite(strcat(['./data/' nomeDS '/'],'DTW_',nomeDS,nomefile,sheet),xMTX2);
ktma=[];
ktmb=[];
sumTotalClass=(sum(sum(xMTX2)));
for icl=1:numOfClasses
    
    modularity(icl)=((sumsimInClasss(icl))/(sumTotalClass))-((separationtwoClass2(icl))/(sumTotalClass))^2;
    ktma(icl)=(sumsimInClasss(icl))/(sumTotalClass);
    ktmb(icl)=((separationtwoClass2(icl))/(sumTotalClass))^2;
end
ktma1=[sum(ktma),sum(ktmb)];
ktmb1=sum(ktmb);


clear matrixDist matrixD;
%
% for iclsss=1:numOfClasses
%     matrixDist=[];
%     %     cjM=[];
%     %
%     %     ci=classes{iclsss};
%     %
%     %     cj=classes;
%     %     cj(iclsss)=[];
%     %     cjM=[cj{1},cj{2},cj{3},cj{4},cj{5}];
%     for icS=1:numOfClasses
%         if icS~=iclsss
%             matrixDist=cat(2,matrixDist,DistancesMatrixAll{iclsss,icS});
%         end
%     end
% %     DistancesMatrixAll
% %     size(matrixDist)
% %     mmmmmm
%     separationClassMeanUNION(iclsss)=(mean(mean(matrixDist)));
%     separationClassMinUNION(iclsss)=(min(min(matrixDist)));
%     separationClassMaxUNION(iclsss)=(max(max(matrixDist)));
%     %         separationClass(iclsss,jclsss)=(sum(sum(matrice1)))*(1/(cilength*(cjlength)));
% end


function WriteAllEntropy(whatSmooth,randomRun,path,nomeds,percentage,taball,nomesheet,numClasses)
n=numClasses;

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
xlwrite(strcat([path nome],'_',nomeds,'.xls'),taball(1,:),sheet,[nume,1]);

% xlwrite(strcat([path nome],'_',nomeds,'.xls'),num2str(randomRun),sheet,[nume,0]);

for itj=1:3
    columnR=((itj)*n)+(n/2)*(itj);
    xlwrite(strcat([path nome],'_',nomeds,'.xls'),taball(itj+1,:),sheet,[nume,columnR]);
    %     xlwrite(strcat([path nome],'_',nomeds,'.xls'),strcat(num2str(randomRun)),sheet,[nume,0]);
end


