function J = object(theta)

global x;
global y;

J=sum((x*theta-y).*(x*theta-y));