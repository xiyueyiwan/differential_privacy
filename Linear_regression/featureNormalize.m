function [X_norm, mu, sigma] = featureNormalize(X)
X_norm = X;
mu = zeros(1, size(X, 2));      % size(X,2) 取矩阵x的列数，生成1*size(X,2)矩阵
sigma = zeros(1, size(X, 2));   % size(X,2) 取矩阵x的列数，生成1*size(X,2)矩阵    
  mu = mean(X);       %  均值 
  sigma = std(X);     %  方差
  X_norm  = (X - repmat(mu,size(X,1),1)) ./  repmat(sigma,size(X,1),1);

end