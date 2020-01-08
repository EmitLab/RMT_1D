function computeIdentityInClass()

jsmoothstr= {'R+','E+','Pr+','R-','E-','Pr-'};
addpath(genpath('./Classification/jexcelapi/'));
sigmabasePerc={1,5,10};%percent INTERVAL MINIMUM SIZE =3*sigmabase
jsmooth={1,2,3,4,5,6};
longIntsize=size(sigmabasePerc,2);
longSmooth=size(jsmooth,2);


nomeDS='synthetic_control_TEST';
% [namematrix1,data11]=importfile1(['./data/' nomeDS '.csv']);  % import matrix dataset
% DSfull=data11';

for ids=1:50
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
    
    DSRaw=csvread(strcat(['./data/',nomeDS,'1d/'],nomeDS,'_Random_', num2str(dsID)));

    rawdistances =distanceClass(DSRaw');
    ids

%     [datanolabels,labels]=randomRetireved(nomeDS,dsID);
    for jids=1:longIntsize
        intervalPercentage=(cell2mat((sigmabasePerc(1,jids))));
        
        %global
        DSFix=csvread(strcat(['./data/' nomeDS '/percentagewin_' num2str(intervalPercentage) '_Pr+/' ],'Global_percentage_', num2str(intervalPercentage)));%,[labels;datasetsmoothedPR]);
        fixdistances =distanceClass(DSFix);

        smoothdistances=[];
        for js=1:3
            DSSmooth=[];
            smoothdist=[];
            sst=num2str(cell2mat((jsmoothstr(1,js))));
            pathmatrix2=['./data/' nomeDS '/percentagewin_' num2str(intervalPercentage) '_' sst  '/' ];
            sstmin=num2str(cell2mat((jsmoothstr(1,js+3))));
            pathmatrix3=['./data/' nomeDS '/percentagewin_' num2str(intervalPercentage) '_' sstmin  '/' ];
                        
            DSSmoothPlus=csvread(strcat(pathmatrix2,nomeDS,'_', num2str(intervalPercentage), '_smth_',sst,'numRun_',num2str(dsID)));%, [labels;datasetsmoothed2]);
            smoothdistPlus =distanceClass(DSSmoothPlus);
            
            DSSmoothMinus=csvread(strcat(pathmatrix3,nomeDS,'_', num2str(intervalPercentage), '_smth_',sstmin,'numRun_',num2str(dsID)));%, [labels;datasetsmoothed2]);
            smoothdistMinus =distanceClass(DSSmoothMinus);
 
            if length(smoothdistMinus) < 5
                smoothdistMinus(5)=0;
                smoothdistPlus(5)=0;
                fixdistances(5)=0;
                rawdistances(5)=0;
            end
            
                % save it 
            WriteAll(sst,ids,['./data/',nomeDS,'1d/'],nomeDS,intervalPercentage,[rawdistances;fixdistances;smoothdistPlus;smoothdistMinus]);

        end
%     [rawdistances;fixdistances;smoothdistPlus;smoothdistMinus]
    end

end

function distancesClasss=distanceClass(DSR)
accsum=0;
distancesClasss=[];
% quantityClss=arrayfun( @(x)sum(DSR(1,:)==x), unique(DSR(1,:)));
   labels=DSR(1,:);
   orderedlabels=unique(labels);
%computes the distancein the classes
for jc=1:length(orderedlabels)

    alab=find(labels==orderedlabels(jc));
    
    
    seriesClass=DSR(2:end,alab);
%     size(seriesClass)
    matrixDist=pdist2(seriesClass,seriesClass);
    
    distancesClasss(jc)=mean(mean(matrixDist));
    
    
end
    
    
