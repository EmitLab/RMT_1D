%% this function reads the index files by run to get same dataset for multiple runs
function [data1,chosenIndx]=readRandomSTC(data12,numRun,nomeDS,pathINdex)
    ndx= xlsread(strcat([pathINdex nomeDS],'_chosenINDEX.xls'));
    %ndx=ndx';
    chosenIndx= ndx(numRun,1:round(length(data12(1,:))/2));
    data1=data12(:,chosenIndx);
end