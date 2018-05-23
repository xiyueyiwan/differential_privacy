clear;clc;
tic;
RawData = load('Data2_Linear.dat');
%RawData = load('roomprice.txt');
[DataRow, DataCol] = size (RawData);

RawData_min = min(RawData,[],1);
RawData_max = max(RawData,[],1);

Data = (RawData-ones(DataRow,1)*RawData_min)./(ones(DataRow,1)*(RawData_max-RawData_min));  % Convert all attributes to [0, 1]
Data = (Data-0.5).*2;                                                                       % Convert all attributes to [-1,1]
errSum = 0;
w_sum = [];
for rep = 1:100
    
    fold = rand(DataRow, 1);
    SepLine = (0<fold) & (fold<=0.2);
    Test = Data(SepLine,:);
    Train = Data(not(SepLine),:);
    
    epsilon = 3.2;
    [w, b] = Functional_Linear(Train, epsilon);
    w_sum = [w_sum,w];
    errorRate = linearError(Test, w, b)/size(Test, 1);
    errSum = errSum + errorRate;
end

disp(errSum/100);
toc;