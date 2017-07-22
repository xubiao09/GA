function [v,v_opt,c_opt]=GA(green,distance)
%%
%遗传算法求最优速度序列v(m/s)，green{i}为绿灯区间(2*n)，第一行为绿灯开始时间(s)，第二行为绿灯结束时间(s)，distance为车辆距离多个交叉路口的距离(m)
%%
%遗传算法参数
NumGen=500;    %初代种群数目
alpha=0.33;    %线性交叉算子系数
PMutation=0.2; %变异概率
N=500;         %最大迭代数目
%%
vmax=60/3.6;
vmin=20/3.6;
NumIntsct=length(distance);
v0=IntialGen(vmax,vmin,NumIntsct,NumGen,distance,green);
v_opt=[];
c_opt=[];
k=0;  %循环数目
while(true)
    v1=CrossGen(v0,alpha);   %%GA交叉算子
    %v2=MutationGen(v1,PMutation,vmax,vmin); 
    v2=MutationGen_new(v1,PMutation,vmax,vmin);  %%GA变异算子
    Cost=CostFunction(v2,green,distance);  %%GA计算损失函数
    [v3,temp_v_opt,temp_c_opt]=Selection(v2,Cost,NumGen);
    %[v3,temp_v_opt,temp_c_opt]=Selection_new(v2,Cost,NumGen); %%GA选择算子
    v0=v3;
    v_opt=[v_opt,temp_v_opt];   %%GA中每代种群中最优个体
    c_opt=[c_opt,temp_c_opt];   %%GA中每代种群中最优个体的损失函数
    k=k+1;
    [k,temp_c_opt]
    %%
    %终止条件：1. 迭代代数超过一定值N；（或）2. 迭代次数超过100且最优值近似不变且约束条件全部满足
    if(k>N)
        v=v_opt(:,end);
        break;
    elseif(k>inf)
        if(abs(c_opt(end)-c_opt(end-10))<1e-5)&&(abs(c_opt(end-1)-c_opt(end-9))<1e-5)&&(abs(c_opt(end-2)-c_opt(end-8))<1e-5)&&(c_opt(end)<1)
            v=v_opt(:,end);
            break;
        end
    end
end