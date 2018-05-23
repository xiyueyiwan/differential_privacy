function J = object(theta)

global x;
global y;

J=transpose((x*theta-y))*(x*theta-y);