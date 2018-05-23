function sense = Calculate_sense(theta,data,DataCol,mu,sigma,row)
income=ones(row,1);
s=data(:,1:(DataCol-1));
for i=1:row
    income(i)= [1 ((s(i,:)-mu) ./ sigma)] * theta ;
end
[ma mx]=max(income);
[mi mn]=min(income);
sense=ma-mi;
end