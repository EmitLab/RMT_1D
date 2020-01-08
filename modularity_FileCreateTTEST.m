function modularity_FileCreate(nomeDS)
clc;
close all;

addpath('./testt/');
addpathFILE();
jsmoothstr= {'R','E','P'};
jsmooth={1,2,3,4,5,6};
longSmooth=size(jsmooth,2);

cKs=[2,1,3];%[2,1,3];

sigmabasePerc={1,5,10};%percent INTERVAL MINIMUM SIZE =3*sigmabase
longIntsize=size(sigmabasePerc,2);

Entr=[];
%lighiting 11.
% nomeDS='ECG200_TEST';
% [namematrix1,data11]=importfile1(['./data/' nomeDS '.csv']);  % import matrix dataset
% DSfull=data11';


pathModularity=['data/',nomeDS,'1d/'];
% retrieve file

nomefile=['modularity_',nomeDS,'prova','_',nomeDS,'.xls'];

rangeSheet=[1,50; 51,100; 101,150];
rangeColumn=[1,3;4,6;7,9;10,12];

% for ifoglio=1:9  %numero fogli


for ifoglio=1:longIntsize
    intervalPercentage=(cell2mat((sigmabasePerc(1,ifoglio))));
    intervalPercentageSTRING=num2str(intervalPercentage);%(cell2mat((xlsKTM(1,jids))));
    if ifoglio>1
        ifgl=((ifoglio-1)*55);
        
    else
        ifgl=1;
    end
    for c=1:length(cKs)
        cTs=cKs(c);
        
        sheet=[ intervalPercentageSTRING 'percentage_IIS-Class','c',num2str(cTs)];
        
        AllCriteria=xlsread(strcat(pathModularity,nomefile),sheet);
%         AllCriteria=AllCriteria(isfinite(AllCriteria(:, 1)), :)
          AllCriteria = AllCriteria(:,any(~isnan(AllCriteria)));  % for columns
          AllCriteria = AllCriteria(any(~isnan(AllCriteria),2),:);   %for rows

%         initialVars = who;
        for icriterion=1:3
            sst=num2str(cell2mat((jsmoothstr(1,icriterion))))
            
            MTXCriterion=AllCriteria(rangeSheet(icriterion,1):rangeSheet(icriterion,2),:);
            avgRow=[];
            for js=1:4
                
                MTXRow=MTXCriterion(:,rangeColumn(js,1):rangeColumn(js,2));
                %
                [avgRow1,iterz]= calcolaM(MTXRow);
                
                avgRow=cat(2,avgRow,avgRow1);
            end
            percDiff=calcolaC(avgRow,iterz);
            %                   ttestRow= calcolaT(MTXRow,iterz);
%             if ifoglio>1
%                 cfog=(c);
%             else
%                 cfog=(c-1);
%             end
            
            foglio=((c-1)*18)+ifgl
            
            WriteAllEntropy(sst,pathModularity,nomeDS,intervalPercentage,[avgRow;percDiff], ['ttest'],4,foglio,iterz,cTs);
            
            
            %                 clearvars('-except', initialVars{:});
            %     [rawdistances;fixdistances;smoothdistPlus;smoothdistMinus]
        end
    end
end
% end

function WriteAllEntropy(whatSmooth,path,nomeds,percentage,taball,nomesheet,numClasses,sheetsnumber,iterz,c)
n=numClasses;
jst= {'Raw','Fixed','Smooth+','Smooth-'};
switch whatSmooth
    case 'R'
        colum=1;
        nume=1+sheetsnumber;
        WSmo={'Repr'};
    case 'E'
        colum=1;
        nume=(5+sheetsnumber)+2;
        WSmo={'Entropy'};
    case 'P'
        colum=1;
        nume=(8+sheetsnumber)+5;
        WSmo={'Ppr'};
end

cCc={strcat('c', num2str(c))};

sheet=[ nomesheet];%[num2str(n),'_',num2str(jsmooth),num2str(percentage) num2str(numwindowsusr)];[num2str(n),'_',num2str(jsmooth),num2str(numwindowsusr)];
nome=['modularity_',nomeds,'prova'];

% vvvvvvvvvvvvv
%     xlwrite(strcat([path nome],'_',nomeds,'.xls'),[quantityClss,nums,sizeS],sheet,[nume,50]);
%     xlwrite(strcat([path nome],'_',nomeds,'.xls'),measures,sheet,[nume,(colum+3)]);
xlwrite(strcat([path nome],'_',nomeds,'.xls'),WSmo,sheet,[nume,0]);
xlwrite(strcat([path nome],'_',nomeds,'.xls'),percentage,sheet,[nume+1,0]);
xlwrite(strcat([path nome],'_',nomeds,'.xls'),cCc,sheet,[nume+2,0]);
xlwrite(strcat([path nome],'_',nomeds,'.xls'),jst(1),sheet,[nume-1,1]);
% xlwrite(strcat([path nome],'_',nomeds,'.xls'),taball(1:2,1:iterz),sheet,[nume+1,1]);

xlwrite(strcat([path nome],'_',nomeds,'.xls'),{'Intra_class','Inter_class','Sparcity'},sheet,[nume,1]);
% xlwrite(strcat([path nome],'_',nomeds,'.xls'),num2str(randomRun),sheet,[nume,0]);

aaa={strcat('=TEST.T(''5percentage_IIS-Classc''num2str(c)''''!F$59:F$108,''5percentage_IIS-Classc2''!$B$59:$B$108,1,1)')};

for itj=1:3
    columnR=((itj)*n)+((n/2)-1)*(itj);
    startit=(3*itj);
    xlwrite(strcat([path nome],'_',nomeds,'.xls'),jst(itj+1),sheet,[nume-1,columnR]);
    
%     xlwrite(strcat([path nome],'_',nomeds,'.xls'),{'Intra_class','Inter_class','Sparcity'},sheet,[nume,columnR]);
    
%     xlwrite(strcat([path nome],'_',nomeds,'.xls'),taball(1:2,startit+1:(startit+iterz)),sheet,[nume+1,columnR]);
    
    xlwrite(strcat([path nome],'_',nomeds,'.xls'),{aaa},sheet,[nume+1,columnR]);
    
    %     xlwrite(strcat([path nome],'_',nomeds,'.xls'),strcat(num2str(randomRun)),sheet,[nume,0]);
end

% if strcmp(whatSmooth,'E+')==1
% taball
%
% vvv
% end
