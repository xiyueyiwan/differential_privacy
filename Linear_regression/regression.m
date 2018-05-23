
%clear;close all;clc
tic;
fprintf("loading data...\n");

RawData = load('Data2_Linear.dat');
[DataRow, DataCol] = size (RawData);

RawData_min = min(RawData,[],1);
RawData_max = max(RawData,[],1);

Data = (RawData-ones(DataRow,1)*RawData_min)./(ones(DataRow,1)*(RawData_max-RawData_min));  
Data = (Data-0.5).*2; 
ErrNum=0;
for rep = 1:1
    
    fold = rand(DataRow, 1);
    SepLine = (0<fold) & (fold<=0.2);
    data = Data(not(SepLine),:);
    Test = Data(SepLine,:);
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
    
    [test_row,test_col]=size(Test);
    x_Test=Test(:,1:test_col-1);
    x_test=[ones(test_row,1) x_Test];
    y_test=Test(:,test_col);
    ErrNum=ErrNum+sum((x_test * opti_theta - y_test).^2) / m;
end

error=ErrNum/1;
disp(error);
toc;

