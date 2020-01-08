%%% script classification All
function classificationAll(DataSets,sizeDS,intervalsize,jsmoothstr,...
                            numClassi,randomRun,quantityClss,nRun,numRun)

% clear all;
allMTX=[];



nomeDist={'DTWraw','DTWfix','DTW_smooth+','DTW_smooth-'};

%script for classifing, collecting the distance matrices
% 
scriptClassificationDTWraw(DataSets,randomRun);

scriptClassificationGlobal_PR(DataSets,intervalsize,randomRun);

scriptClassificationDTW(DataSets,intervalsize,jsmoothstr,numRun,randomRun);


%tops
numTopK=10;
% make this for one dataset per time
longMtxDS=size(DataSets,2);
for ids=1:longMtxDS
    nomeDS=num2str(cell2mat((DataSets(1,ids))));
    
    allMTX=importAllfile(nomeDS,intervalsize,jsmoothstr,randomRun);
     
    
    topKclassification(allMTX,nomeDS,numTopK,nomeDist,...
                        intervalsize,jsmoothstr,...
                        sizeDS(ids),numClassi(ids),...
                        randomRun,quantityClss,nRun);
    clear allMTX;
end
