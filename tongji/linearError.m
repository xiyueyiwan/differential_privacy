function y = linearError(Test, w, b)
TestX = Test(:,1:end-1);
TestY = Test(:,end);

Pred = TestX*w + b;
y = sum((TestY-Pred).^2);