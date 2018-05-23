function J = computeCostMulti(X, y, theta)
m = length(y); % number of training examples
J = 0;
J = sum((X * theta - y).^2) / m;    
end