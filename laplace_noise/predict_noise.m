%²âÊÔÔ¤²âÖµ+²î·ÖÒþË½ÔëÉù
clear;close all;clc
tic;
fprintf("loading data...\n");

RawData = load('Data2_Linear.dat');
[DataRow, DataCol] = size (RawData);

RawData_min = min(RawData,[],1);
RawData_max = max(RawData,[],1);


Data = (RawData-ones(DataRow,1)*RawData_min)./(ones(DataRow,1)*(RawData_max-RawData_min));  
Data = (Data-0.5).*2; 
laplace_err=0;
for rep=1:100
    fold = rand(DataRow, 1);
    SepLine = (0<fold) & (fold<=0.2);
    Test = Data(SepLine,:);
    data = Data(not(SepLine),:);
    m=size(data,1);
    global x;
    global y;
    x=data(:,1:DataCol-1);
    y=data(:,DataCol);
    x=[ones(m,1) x];

    theta=zeros(DataCol,1);
    options = optimset('LargeScale','off');
    options.MaxFunEvals = 100000;
   [opti_theta,~,~,~]= fminunc(@object, theta, options);

    privacy=3.2;
    [test_row,test_col]=size(Test);
    x_Test=Test(:,1:test_col-1);
    y_test=Test(:,test_col);
    x_test=[ones(test_row,1) x_Test];
    [x_Test mu_test sigma_test]=featureNormalize(x_Test);
    sense=Calculate_sense(opti_theta,data,DataCol,mu_test,sigma_test,test_row);
    noise_cre=Create_noise(sense, privacy,test_row);
    noise=transpose(noise_cre);
    predict=x_test * opti_theta+noise;

    laplace_err=laplace_err+sum((predict - y_test).^2) / test_row;
end

error=laplace_err/100;
disp(error);
toc;



