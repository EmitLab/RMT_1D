function entropy_Classes()
addpath('/home/ros/Dropbox/code/SmoothSeries/Classification/20130227_xlwrite/20130227_xlwrite/poi_library/');
% addpath('./sumSeriesTest/Classification/20130227_xlwrite/20130227_xlwrite/');

% javaaddpath('./Yair/Utils/JExcelAPI/MXL.jar')
pathlib='/home/ros/Dropbox/code/SmoothSeries/Classification/20130227_xlwrite/20130227_xlwrite/poi_library/';

% javaaddpath(fullfile(matlabroot,'work','./sumSeriesTest/Classification/20130227_xlwrite/20130227_xlwrite/poi_library/'))
%  xlswrite([path nome],tab,foglio);
javaaddpath([pathlib 'poi-3.8-20120326.jar']);
javaaddpath([pathlib 'poi-ooxml-3.8-20120326.jar']);
javaaddpath([pathlib 'poi-ooxml-schemas-3.8-20120326.jar']);
javaaddpath([pathlib 'xmlbeans-2.3.0.jar']);
javaaddpath([pathlib 'dom4j-1.6.1.jar']);
javaaddpath([pathlib 'stax-api-1.0.1.jar']);

javaaddpath('/home/ros/Dropbox/code/SmoothSeries/Classification/jexcelapi/jxl.jar');

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
xlsKTM={'one','five','ten'};
jsmooth={1,2,3,4,5,6};
longIntsize=size(sigmabasePerc,2);
longSmooth=size(jsmooth,2);
Entr=[];
%lighiting 11.
nomeDS='coffee';
% [namematrix1,data11]=importfile1(['./data/' nomeDS '.csv']);  % import matrix dataset
% DSfull=data11';

for ids=40:50
    %     ecct=[0,0,10,11,27,28,24,22,23,15];
    %     if ids>=43
    %         if ids==50
    %             dsID=15;
    %         else
    %         a=mod(ids,10);
    %          dsID=ecct(a);
    %         end
    %     else
    dsID=ids;
    %     end
    nomefile=['_Random_', num2str(dsID)];
    DSRaw=csvread(strcat(['./data/',nomeDS,'1d/'],nomeDS,'_Random_', num2str(dsID)));
    %        size(DSRaw)
    labels=DSRaw(:,1);
    [MeanClasss1,minClasss1,maxClasss1,...
        separationClass1,separationClassMIN1,separationClassMAX1,...
        separationClassMeanUNION1,separationClassMinUNION1,separationClassMaxUNION1 ] =distanceClass(DSRaw','RAW',nomefile,nomeDS);
    ids
    %
    %     [datanolabels,labels]=randomRetireved(nomeDS,dsID);
    for jids=1:longIntsize
        intervalPercentage=(cell2mat((sigmabasePerc(1,jids))));
        intervalPercentageSTRING=num2str(intervalPercentage);%(cell2mat((xlsKTM(1,jids))));
        %global
        DSFix=csvread(strcat(['./data/' nomeDS '/percentagewin_' num2str(intervalPercentage) '_Pr+/' ],'Global_percentage_', num2str(intervalPercentage),'_',num2str(ids)));%,[labels;datasetsmoothedPR]);
        [MeanClasss2,minClasss2,maxClasss2,...
            separationClass2,separationClassMIN2,separationClassMAX2,...
            separationClassMeanUNION2,separationClassMinUNION2,separationClassMaxUNION2 ] =distanceClass(DSFix,[intervalPercentageSTRING,'_FIXED'],nomefile,nomeDS);
        
        smoothdistances=[];
        for js=1:3
            DSSmooth=[];
            smoothdist=[];
            sst=num2str(cell2mat((jsmoothstr(1,js))));
            pathmatrix2=['./data/' nomeDS '/percentagewin_' num2str(intervalPercentage) '_' sst  '/' ];
            sstmin=num2str(cell2mat((jsmoothstr(1,js+3))));
            pathmatrix3=['./data/' nomeDS '/percentagewin_' num2str(intervalPercentage) '_' sstmin  '/' ];
            
            DSSmoothPlus=csvread(strcat(pathmatrix2,nomeDS,'_', num2str(intervalPercentage), '_smth_',sst,'numRun_',num2str(dsID)));%, [labels;datasetsmoothed2]);
            [MeanClasss3,minClasss3,maxClasss3,...
                separationClass3,separationClassMIN3,separationClassMAX3,...
                separationClassMeanUNION3,separationClassMinUNION3,separationClassMaxUNION3 ] =distanceClass(DSSmoothPlus,[intervalPercentageSTRING,'_',sst],nomefile,nomeDS);
            
            DSSmoothMinus=csvread(strcat(pathmatrix3,nomeDS,'_', num2str(intervalPercentage), '_smth_',sstmin,'numRun_',num2str(dsID)));%, [labels;datasetsmoothed2]);
            [MeanClasss4,minClasss4,maxClasss4,...
                separationClass4,separationClassMIN4,separationClassMAX4,...
                separationClassMeanUNION4,separationClassMinUNION4,separationClassMaxUNION4 ]=distanceClass(DSSmoothMinus,[intervalPercentageSTRING,'_',sstmin],nomefile,nomeDS);
            
            numClasses=length(unique(labels));
            
            
            % save it
            WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[minClasss1;minClasss2;minClasss3;minClasss4], 'minSameClass',numClasses);
            WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[maxClasss1;maxClasss2;maxClasss3;maxClasss4], 'maxSameClass',numClasses);
            %             WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[sumdistancesClasss1;sumdistancesClasss2;sumdistancesClasss3;sumdistancesClasss4], 'cohesion',numClasses);
            WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[MeanClasss1;MeanClasss2;MeanClasss3;MeanClasss4],'meanSameClass',numClasses);
            
            %             if js==1
            %                 Entr(js)=segmentWentropy(labels);
            %                  WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[Entr(1);Entr(1);Entr(1);Entr(1)], 'entropy',numClasses);
            %             end
            WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClass1;separationClass2;separationClass3;separationClass4], 'separationMEAN',numClasses);
            WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClassMIN1;separationClassMIN2;separationClassMIN3;separationClassMIN4],'separationMIN',numClasses);
            WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClassMAX1;separationClassMAX2;separationClassMAX3;separationClassMAX4],'separationMAX',numClasses);
            %         %%%UNION
            WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClassMeanUNION1;separationClassMeanUNION2;separationClassMeanUNION3;separationClassMeanUNION4], 'sepMeanUnion',numClasses);
            WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClassMinUNION1;separationClassMinUNION2;separationClassMinUNION3;separationClassMinUNION4], 'sepMinUnion',numClasses);
            WriteAllEntropy(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[separationClassMaxUNION1;separationClassMaxUNION2;separationClassMaxUNION3;separationClassMaxUNION4], 'sepMaxUnion',numClasses);
        end
        
        %     [rawdistances;fixdistances;smoothdistPlus;smoothdistMinus]
    end
    
end

function [MeanClasss,minClasss,maxClasss,...
    separationClassMEANavg,separationClassMINavg,separationClassMAXavg,...
    separationClassMeanUNION,separationClassMinUNION,separationClassMaxUNION]=distanceClass(DSR,sheet,nomefile,nomeDS)

DistancesMatrixAll=[];
accsum=0;
distancesClasss=[];
separationClass=[];
matrixDist=[];
matrixC=[];
% quantityClss=arrayfun( @(x)sum(DSR(1,:)==x), unique(DSR(1,:)));
labels=DSR(1,:);
orderedlabels=unique(labels);

clear matrixDist;% matrice1 matrixC ;

numOfClasses=length(orderedlabels);
for iclsss=1:numOfClasses
    
    alab=find(labels==orderedlabels(iclsss));
    
    ci=DSR(2:end,alab);
    
    %      cilength=size(ci,1);
    for jclsss=1:numOfClasses
        alab=find(labels==orderedlabels(jclsss));
        
        cj=DSR(2:end,alab);
        matrixDist=[];
        matrixD=[];
        %         cj=classes{jclsss};
        if jclsss==iclsss
            
            matrixDist=ClassificationDTWGlobal(cj);
            for mi=1:size(matrixDist,1)
                
                rowD=matrixDist(mi,:);
                rowD(mi)=[];
                %         rowDist=matrixDist(mi,:);
                %         rowDist(mi)=[];
                %         normal=max(rowD);
                %         rowD=rowD./normal;
                
                %         matrixC=cat(1,matrixC,rowD);
                matrixD=cat(1,matrixD,rowD);
                
            end
            %%computes within same class
            MeanClasss(iclsss)=mean(mean(matrixD));
            
            %     sumdistancesClasss(jc)=sum(sum(matrice1))*(1/(clength*(clength-1)));%choseion
            minClasss(iclsss)=min(min(matrixD));
            maxClasss(iclsss)=max(max(matrixD));
            
        else
            
            %         matrixDist=pdist2(ci,cj);
            matrixD=ClassificationDTWDoubleMTX(ci,cj);
            
        end
        
        %%compute the separation
        separationClass(iclsss,jclsss)=(mean(mean(matrixD)));
        separationClassMIN(iclsss,jclsss)=(min(min(matrixD)));
        separationClassMAX(iclsss,jclsss)=(max(max(matrixD)));
        %stores it
        DistancesMatrixAll{iclsss,jclsss}=matrixD;
        %         separationClass(iclsss,jclsss)=(sum(sum(matrice1)))*(1/(cilength*(cjlength)));
    end
    separationClassMEANavg(iclsss)=(mean(mean(separationClass)));
    separationClassMINavg(iclsss)=(min(min(separationClassMIN)));
    separationClassMAXavg(iclsss)=(max(max(separationClassMAX)));
    
end
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
xlwrite(strcat(['./data/',nomeDS,'1d/'],'DTW_',nomeDS,nomefile,'.xls'),xMTX2,sheet,[1,1]);

clear matrixDist ;

for iclsss=1:numOfClasses
    matrixDist=[];
    %     cjM=[];
    %
    %     ci=classes{iclsss};
    %
    %     cj=classes;
    %     cj(iclsss)=[];
    %     cjM=[cj{1},cj{2},cj{3},cj{4},cj{5}];
    for icS=1:numOfClasses
        if icS~=iclsss
            matrixDist=cat(2,matrixDist,DistancesMatrixAll{iclsss,icS});
        end
    end
%     DistancesMatrixAll
%     size(matrixDist)
%     mmmmmm
    separationClassMeanUNION(iclsss)=(mean(mean(matrixDist)));
    separationClassMinUNION(iclsss)=(min(min(matrixDist)));
    separationClassMaxUNION(iclsss)=(max(max(matrixDist)));
    %         separationClass(iclsss,jclsss)=(sum(sum(matrice1)))*(1/(cilength*(cjlength)));
end


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
nome=['classes','Study_'];

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


