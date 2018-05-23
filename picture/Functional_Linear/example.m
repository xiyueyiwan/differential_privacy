%clear;clc;
RawData = load('Data2_Linear.dat');
%RawData = load('roomprice.txt');
[DataRow, DataCol] = size (RawData);

RawData_min = min(RawData,[],1);
RawData_max = max(RawData,[],1);

Data = (RawData-ones(DataRow,1)*RawData_min)./(ones(DataRow,1)*(RawData_max-RawData_min));  % Convert all attributes to [0, 1]
Data = (Data-0.5).*2;                                                                       % Convert all attributes to [-1,1]
errSum =[0 0 0 0 0 0];
error=[0 0 0 0 0 0];
epsilon=[0.1 0.2 0.4 0.8 1.6 3.2];
w_sum = [];
b_sum = [];
for p=1:6
for rep = 1:10
    
    fold = rand(DataRow, 1);
    SepLine = (0<fold) & (fold<=0.2);
    Test = Data(SepLine,:);
    Train = Data(not(SepLine),:);
    
    [w, b] = Functional_Linear(Train, epsilon(p));
    w_sum = [w_sum,w];
    b_sum = [b_sum,b];
    errorRate = linearError(Test, w, b)/size(Test, 1);
    errSum(p) = errSum(p) + errorRate;
end
    error(p)=errSum(p)/10;
end

%figure;
subplot(1,2,2);
plot(epsilon,error,'Marker','square','MarkerIndices',[1 2 3 4 5 6]);
title("Functional Mechanism");     
xlabel('Number of privacy');
ylabel('Error');