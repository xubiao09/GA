function v1=MutationGen_new(v0,PMutation,vmax,vmin)
%%
%变异算子：从初始种群v0(NumIntsct*NumGen)中选出一个，分量根据概率变异得到最终种群v1(NumIntsct*NumGen)，PMutation为变异概率
%%
NumIntsct=length(v0(:,1));  %交叉口数目
NumGen=length(v0(1,:));     %种群数目
v1=v0;
for i=1:NumGen
    if(rand()<=PMutation)
        Indvd=v0(:,i);                %变异的个体
        PRand=rand(NumIntsct,1);
        TempIndex=PRand<=PMutation; %参与变异的个体的基因分量索引
        R = normrnd(Indvd,3*ones(size(Indvd)));  %生成正态分布随机数
        R(R>vmax)=vmax;
        R(R<vmin)=vmin;
        Indvd(TempIndex)=R(TempIndex);         %将参与变异的基因进行替换
        v1=[v1,Indvd];                         %替换变异个体，得到最终种群v1
    end
end