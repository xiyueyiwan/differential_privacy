function [w, b] = Functional_Linear(Train, ep)

% function [w, b] = Functional_Linear(Train, ep)
%
% Differentially private linear regression using Funcational Mechanism. 
% 
% Input parameters: 
% Training data (Train) with last column attribute to be predicted. 
% Train = [x1, x2, ..., xd, y]
% 
% NOTICE: The values of EACH attribute (column) should be converted from [min,
% max] to [-1,1] in order to match the privacy design of Functional
% Mechanism. Please make sure that ALL values in Train are located in
% [-1,1]. If Train is rescaled to meet this requirement, Test should be
% converted IN THE SAME WAY to get the correct answer.
%
% Privacy budget (ep) is a parameter in differential privacy, which
% indicates the strength of privacy protection.
%
% Model is 
%
%   (w, b) = argmin sum((x*w+b-y)^2)
%
% Outputs are regression coefficients w and b.
%
% Copyright 2012 Jun Zhang


rangeChecker = sum(sum(Train>1)) + sum(sum(Train<-1));
if (rangeChecker>0)
    disp('NOTICE: The values in EACH attribute (column) should be converted from [min, max] to [-1,1]');
    return;
end



[TrainRow, TrainCol] = size(Train);

TrainX = Train(:,1:end-1);
TrainX = [TrainX, ones(TrainRow,1)];             % x*w + b, add bias b

TrainY = Train(:,end);

d = TrainCol;

R0 = TrainX' * TrainX;
R1 = (-2) .* (TrainX' * TrainY);

Sensitivity = 2*d*d + 4*d;


global Coe2;
global Coe1;

Coe2 = R0 + laprnd(d, d, 0, Sensitivity * (1/ep));
Coe2 = 0.5 * (Coe2'+Coe2);
Coe2 = Coe2 + 5 * sqrt(2) * Sensitivity * (1/ep) * eye(d);         %Regularization
Coe1 = R1 + laprnd(d, 1, 0, Sensitivity * (1/ep));

%   Consistency: Coe2 positive-define
[vec,val]=eig(Coe2);

del = diag(val)<1e-8;

val(del,:) = [];
val(:,del) = [];

vec(:,del) = [];


Coe2 = val;
Coe1 = vec'*Coe1;
%   End of Consistency

g0 = rand(d-sum(del), 1);
options = optimset('LargeScale','off');
options.MaxFunEvals = 100000;
[g,~,~,~] = fminunc(@noised, g0, options);

bestw = vec * g;

w = bestw(1:end-1);
b = bestw(end);

