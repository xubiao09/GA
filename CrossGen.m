function [v3,v4] = CrossGen(v1,v2,alpha)
%%
%���Խ������ӣ�����ϵ��Ϊalpha,ĸ��Ϊv1��v2���Ӵ�Ϊv3��v4
%%
 v3 = alpha*v1+(1-alpha)*v2;
 v4 = (1-alpha)*v1+alpha*v2;