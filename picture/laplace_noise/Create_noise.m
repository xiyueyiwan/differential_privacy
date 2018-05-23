function noise = Create_noise(sense, privacy,row)
mu=0;                   %拉普拉斯分布的期望为0
b=sense/privacy;
a=rand(1,1000000)-0.5; 
s=a(randperm(row));
noise=mu-b*sign(s).*log(1-2*abs(s));
end
 
