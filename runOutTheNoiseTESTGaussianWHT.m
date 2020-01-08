function runOutTheNoiseTESTGaussianWHT(kpsExtraction,DataSets)

clc;
close all;

addpathFILE;

jsmoothstr= {'R+','E+','Pr+','R-','E-','Pr-'};
jsmooth={1,2,3,4,5,6};
longSmooth=size(jsmooth,2);

cKs=[2,1,3];%[2,1,3];

sigmabasePerc={1,5,10};%percent INTERVAL MINIMUM SIZE =3*sigmabase
longIntsize=size(sigmabasePerc,2);

%% ds
%
%          'Lighting2_TEST','coffee','ECG200_TEST' ,...
% DataSets={'coffee'};%'synthetic_control_TEST','ECG200_TEST','coffee'...
%             'FaceFour_TEST','sonyaiborobotsurface'};
%
%           'Lighting2_TEST','coffee','ECG200_TEST'
% DataSets={'Gun_Point_TEST','Trace_TEST','FaceFour_TEST',...
%            'Lighting2_TEST','coffee','ECG200_TEST',...
%            'sonyaiborobotsurface','synthetic_control_TEST'};
% pathIn='./data/allMatrices4PeriodicityBinary/';
longDS=size(DataSets,2)
for ktm=1:longDS
    
    %      =num2str(cell2mat((DataSets(1,ktm))));
    nomeDS=num2str(cell2mat((DataSets(1,ktm))));
    [namematrix1,data11]=importfile1(['./data/datasetTEST/' nomeDS '.csv']);  % import matrix dataset
    DSfull=data11';
    numberOfseries=size(DSfull,2); % Number of series in DS (rows)
    lengthSeries=size(DSfull,1)-1; % Length of the series in DS (columns)
    DatasetWithOutLabel=DSfull(2:end,:);
    labelsOriginal=DSfull(1,:);
    % it counts the total number of the clasdses
    quantityClss=arrayfun( @(x)sum(labelsOriginal==x), unique(labelsOriginal));
    numClassi=length(quantityClss);
    
    %% DIR
    pathINdex=['./data/',nomeDS,'1d/'];
    pathRaw=['./data/',nomeDS,'/Raw/'];
    pathFixed=['./data/' nomeDS '/FIXED/'];
    pathDistances=['./data/' nomeDS '/DistancesDTW/'];
    pathWHT=['./data/' nomeDS '/WHT/'];
    
    % % it checks the directories
    if ~exist(['./data/',nomeDS])
        mkdir(['./data/',nomeDS]);
        mkdir(['./data/',nomeDS,'1d/']);
    end
    
    if ~exist(pathWHT)
        mkdir(pathRaw);
        mkdir(pathFixed);
        mkdir(pathDistances);
        mkdir(pathWHT);
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
            
            sigmabase=(lengthSeries/100)*intervalPercentage;
            
            for c=1:3
                
                cTs=cKs(c);
                thresholdLength= ceil(cTs*sigmabase);  %round((lengthSeries/100)*(intervalPercentage*3)); %INTERVAL MINIMUM SIZE =3*sigmabase
                sigma0our=(cTs/12)*sigmabase;
                pathFeatures=strcat(pathINdex,nomeDS,'percentagewin_',num2str(intervalPercentage),'_c',num2str(cTs),'/');
                for num=1:numberOfseries
                    generateFeaturesSeries(DatasetWithOutLabel,nomeDS,...
                        num,thresholdLength,pathFeatures,sigma0our,cTs);
                    num
                end
            end
        end
    end
    %%
    kin=3;
    % smoothApproach={'shrinkRadius','addPad'};%legate ad ids
    chosenIndx=[1:1:numberOfseries];
    sigmawht=0.09;
    for ids=1:1
        fprintf('RUNN..  %d \n',ids);
        %         nomefile=['_WHT_'];
        
        labelsRandom=DSfull(1,:);
        quantityClss=arrayfun( @(x)sum(labelsRandom==x), unique(labelsRandom ));
        dataNolabelsRandom=DSfull(2:end,:);
        %%%%%%%%%%5
        dataWHT= dataNolabelsRandom + sigmawht*randn(size(dataNolabelsRandom));
        %         plot(dataWHT);
        
        xMTXRaw=comparisonofNoise(dataNolabelsRandom,dataNolabelsRandom);
        
        nomeexcel=strcat('./data/WHT_noise.xls');
        sheet2=[nomeDS];
        xlwrite(nomeexcel,{'Raw'},sheet2,[kin,0]);
        xlwrite(nomeexcel,xMTXRaw,sheet2,[1,1]);
        
        for jids=1:longIntsize
            
            intervalPercentage=(cell2mat((sigmabasePerc(1,jids))));
            %         pathFeatures=strcat('./data/',nomeDS,'1d/',nomeDS,'percentagewin_',num2str(intervalPercentage),'/');
            
            sigmabase=(lengthSeries/100)*intervalPercentage;%(segWidth/2);
            
            for c=1:length(cKs)
                initialVars = who;
                
                cTs=cKs(c);
                pathFeatures=strcat(pathINdex,nomeDS,'percentagewin_',num2str(intervalPercentage),'_c',num2str(cTs),'/');
                thresholdLength= ceil(cTs*sigmabase);
                
                %         dataNolabelsRandom=DatasetWithOutLabel;
                % %                 xMTX2=ClassificationDTWGlobal(dataNolabelsRandom);
                % %                 xlwrite(strcat(pathDistances,'DTW_',nomeDS,nomefile,'.xls'),xMTX2,'RAW',[1,1]);
                [datasetsmoothed]=executetest(intervalPercentage,dataWHT,...
                    longSmooth,nomeDS, pathFeatures,ids,sigmabase,...
                    chosenIndx,thresholdLength,numberOfseries,cTs);
                %smoothing datasetsmoothed contains all smoothed ds
                
                for js=1:longSmooth
                    sst=num2str(cell2mat((jsmoothstr(1,js))));
                    %             pathSmooth=strcat('./data/',nomeDS,'/',nomeDS,'percentagewin_',num2str(intervalPercentage),'_',sst,'_c',num2str(cTs),'/');
                    datasetsmoothed2=datasetsmoothed{1,js};
                    
                    %save
                    % it creates the folder if it doesn't exist already
                    pathmatrix2=[pathWHT 'percentagewin_' num2str(intervalPercentage) '_' sst '_c' num2str(cTs) '/' ];
                    pathmFIGUREs=[pathWHT 'Figures /'];
                    
                    if ~exist(pathmatrix2, 'dir') || ~exist(pathmFIGUREs, 'dir')
                        mkdir(pathmatrix2);
                        mkdir(pathmFIGUREs)
                    end
                    fignomeSmooth=[nomeDS,'_', num2str(intervalPercentage), '_smth_',sst,'_c',num2str(cTs)];
                    
                    csvwrite(strcat(pathmatrix2,fignomeSmooth), [labelsRandom;datasetsmoothed2]);
                    plot(datasetsmoothed2);
                    title([nomeDS,' ', num2str(intervalPercentage), ' smth',sst,' numRun',num2str(ids),' c',num2str(cTs)]);
                    save_fig(gcf,[pathmFIGUREs fignomeSmooth], 'eps');
                    pause(2)
                    %%%   distance
                    xMTX2=comparisonofNoise(datasetsmoothed2,dataNolabelsRandom);
                    
                    sheet={strcat(num2str(intervalPercentage),sst,'c',num2str(cTs))};
                    xlwrite(nomeexcel,sheet,sheet2,[kin,0]);
                    xlwrite(nomeexcel,xMTX2,sheet2,[kin,1]);
                    %                     xlwrite(nomeexcel,sheet,sheet2,[kin,0]);
                    
                    kin=kin+1;
                    datasetsmoothed2=[];
                end
                
                ww=thresholdLength;
                [yy1,yexp,ywma] = movingAverage(dataWHT, ww);
                
                xMTXma=comparisonofNoise(yy1,dataNolabelsRandom);
                xlwrite(nomeexcel,{strcat(['MA_c',num2str(cTs)])},sheet2,[kin,3]);
                xlwrite(nomeexcel,xMTXma,sheet2,[kin,4]);
                
                
                yexp(isnan(yexp))=0;
                xMTXma2=comparisonofNoise(yexp,dataNolabelsRandom);

                xlwrite(nomeexcel,{'EMA_fix'},sheet2,[kin,5]);
                xlwrite(nomeexcel,xMTXma2,sheet2,[kin,6]);
                %             xlwrite(nomeexcel,[mean(xMTXma),max(xMTXma),min(xMTXma)],sheet2,[kin,6]);
                
                h=plot(yexp);
                title([ 'fixed ', num2str(intervalPercentage)]);
                save_fig(gcf, [pathmFIGUREs,'EMA_Fixed_', num2str(intervalPercentage)], 'eps');
                
                
                kin=kin+1;
                fignomeSmooth2=[nomeDS,'_MA_', num2str(intervalPercentage), '_smth_',sst,'_c',num2str(cTs)];
                
                csvwrite(strcat(pathmatrix2,fignomeSmooth2), [labelsRandom;datasetsmoothed2]);
                plot(yy1);
                title([nomeDS,' MA ', num2str(intervalPercentage), ' smth',sst,' numRun',num2str(ids),' c',num2str(cTs)]);
                save_fig(gcf,[pathmFIGUREs fignomeSmooth2], 'eps');
                pause(1)
                
                clear datasetsmoothed datasetsmoothed2 xMTXma yy1;
                
            end
            % %         %--------------------------------------------------
            %      % compute the dataset based on the global PR
            
            datasetsmoothedPR=DSFixedSmoothGlobal(dataWHT,nomeDS,intervalPercentage);
            
            fignomeFIX={strcat( 'Fixed_', num2str(intervalPercentage))};
            % store the matrix
            csvwrite(strcat(pathWHT,'Fixed_', num2str(intervalPercentage)),[labelsRandom;datasetsmoothedPR]);
            xMTXFix=comparisonofNoise(datasetsmoothedPR,dataNolabelsRandom);
            %             sheet=['FIXED',num2str(intervalPercentage)];
            xlwrite(nomeexcel,fignomeFIX,sheet2,[kin,0]);
            xlwrite(nomeexcel,xMTXFix,sheet2,[kin,1]);
            %save the figure
            h=plot(datasetsmoothedPR);
            title([ 'fixed ', num2str(intervalPercentage)]);
            save_fig(gcf, [pathmFIGUREs,'Fixed_', num2str(intervalPercentage)], 'eps');
            clear datasetsmoothedPR;
            
            ww=round(sigmabase*6);
            [yy,yexp2,ywma] = movingAverage(dataWHT, ww);
            
            xMTXma=comparisonofNoise(yy,dataNolabelsRandom);
            xlwrite(nomeexcel,{'MA_fix'},sheet2,[kin,3]);
            xlwrite(nomeexcel,xMTXma,sheet2,[kin,4]);
            %             xlwrite(nomeexcel,[mean(xMTXma),max(xMTXma),min(xMTXma)],sheet2,[kin,4]);
            
            h=plot(yy);
            title([ 'fixed ', num2str(intervalPercentage)]);
            save_fig(gcf, [pathmFIGUREs,'MA_Fixed_', num2str(intervalPercentage)], 'eps');
            clear yy;
            
            yexp2(isnan(yexp2))=0;
            xMTXma1=comparisonofNoise(yexp2,dataNolabelsRandom);
            xlwrite(nomeexcel,{'EMA_fix'},sheet2,[kin,5]);
            xlwrite(nomeexcel,xMTXma1,sheet2,[kin,6]);
            %             xlwrite(nomeexcel,[mean(xMTXma),max(xMTXma),min(xMTXma)],sheet2,[kin,6]);
            
            h=plot(yexp);
            title([ 'fixed ', num2str(intervalPercentage)]);
            save_fig(gcf, [pathmFIGUREs,'EMA_Fixed_', num2str(intervalPercentage)], 'eps');
            clear xMTXma1 yy;
            
            
            
            kin=kin+2;
            clearvars('-except', initialVars{:});
        end
        
        %Classification
        %     classificationAll(DataSets,sizeDS,sigmabasePerc,jsmoothstr,numClassi,ids,quantityClss,nRun,ids);
        
    end
end


