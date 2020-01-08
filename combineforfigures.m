%% Aggregation  script

clc;
close all;

addpathFILE;
DataSets={'coffee','ECG200_TEST','FaceFour_TEST','Gun_Point_TEST','Lighting2_TEST','synthetic_control_TEST','coffee'};
methods={'SelcukAVG','Rosaria'};
jsmoothstr= {'R+','E+','E-','Pr+','R-','Pr-'};
jsmooth={1,2,3,4,5,6};
longSmooth=size(jsmooth,2);

cKs=[1,2,3];

sigmabasePerc=[1,2,3,5];%,10};%percent INTERVAL MINIMUM SIZE =3*sigmabase
longIntsize=size(sigmabasePerc,2);
longDS=size(DataSets,2);


for idxMethods=1:1%size(DataSets,2)
    %%crate a file for each  parameter set
    for DSindex=1:6%6%longDS % iterate on datasets
        nomeDS=DataSets{DSindex};
        BasePath=['E:\Rosaria Laptop\Rosaria\data\',methods{idxMethods}];%Selcuk'
        DataALL=[];
        RaWdata=csvread([BasePath,'\',nomeDS,'_SelcukSigma\Raw\',nomeDS,'_Random_1']);
        AllpercentageData=[];
        for idxpercentage =2:2
            sigmabasePercused=sigmabasePerc(idxpercentage);
            dataFixed= csvread([BasePath,'\',nomeDS,'_SelcukSigma\FIXED\','fixed_',num2str(sigmabasePercused),'_Random_1']);
            DataWithFixed=[];
            for idxCKS=1:3
                DataMethodAdaptive=[];
                for idxstrategy =1 : longSmooth
                    temp=strcat(BasePath,'\',nomeDS,'_SelcukSigma\percentagewin_',num2str(sigmabasePercused),'_',jsmoothstr(idxstrategy),'_c',num2str(idxCKS),'\',nomeDS,'_',num2str(sigmabasePercused),'_smth_',jsmoothstr(idxstrategy),'numRun_1_c',num2str(idxCKS));
                    data= csvread(temp{1,1});%strcat(BasePath,'\',nomeDS,'_SelcukSigma\percentagewin_1_',jsmoothstr(idxstrategy),'_c',num2str(idxCKS),'\',nomeDS,'_1_smth_',jsmoothstr(idxstrategy),'numRun_1_c',num2str(idxCKS)));
                    DataMethodAdaptive=[DataMethodAdaptive;data(2:end,1)'];
                end
                DataWithFixed=[DataWithFixed;RaWdata(1,2:end)];
                DataWithFixed=[DataWithFixed;dataFixed(2:end,1)'];
                DataWithFixed=[DataWithFixed;DataMethodAdaptive];
            end
            AllpercentageData=[AllpercentageData;DataWithFixed];
        end   
        csvwrite(strcat('E:\Rosaria Laptop\Rosaria\data\',methods{idxMethods},'\Allpercentage1sample_',nomeDS,'.xls'),AllpercentageData);%,strcat(nomeDS));
    end
end
