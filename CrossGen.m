function [v3,v4] = CrossGen(v1,v2,alpha,vmax,vmin)
%%
%���Խ������ӣ�����ϵ��Ϊalpha,ĸ��Ϊv1��v2���Ӵ�Ϊv3��v4
%%
 constant = 0;
 if constant == 1
    v3 = alpha*v1 + (1-alpha)*v2;
    v4 = (1-alpha)*v1 + alpha*v2;
 else
     alpha = 2*rand(1);
     v3    = alpha*v1 + (1-alpha)*v2;
     v3(find(v3<vmin)) = vmin;
     v3(find(v3>vmax)) = vmax;
     
     v4    = (1-alpha)*v1 + alpha*v2;
     v4(find(v4<vmin)) = vmin;
     v4(find(v4>vmax)) = vmax;
 end