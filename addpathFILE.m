function addpathFILE()


addpath('./util');
addpath('./ESFtool');
addpath('./ESFtool/matchphase');
addpath('./fncsmooth');
addpath('./Classification/');
addpath('./util/distances');
% smoothing=4; % all elements
addpath('./Classification/jexcelapi/');



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
% p = javaclasspath