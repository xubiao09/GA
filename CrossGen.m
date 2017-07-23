function [v3,v4] = CrossGen(v1,v2,alpha)
%%
%线性交叉算子，交叉系数为alpha,母代为v1和v2，子代为v3和v4
%%
alpha = 2*rand(1);
 v3 = alpha*v1 + (1-alpha)*v2;
 v4 = (1-alpha)*v1 + alpha*v2;