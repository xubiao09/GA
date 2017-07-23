%%
%生成加速油耗（g）表，用于查找，减少计算量，加速是假设为匀加匀减速，加速度为1.5m/s2
%生成匀速油耗喷射率（g/s）表，用于查找，减少计算量
%%
clear;
clc;
%1. 加速油耗表FuelAcce
v0=5.5:0.1:16.7;     %加速段初速度，m/s
v1=5.5:0.1:16.7;     %加速段末速度，m/s
n=100;               %初末速度插值点数
a0=1.5;              %恒定加速度值，m/s2
for i=1:length(v0)
    for j=1:length(v1)
        ve0=v0(i);
        ve1=v1(j);
        v=linspace(ve0,ve1,n);             %速度序列
        if(ve0<=ve1)
            a=a0*ones(1,100);            %加速度序列
        else
            a=-a0*ones(1,100);            %加速度序列
        end
        t=linspace(0,(ve1-ve0)/a(1),n); %时间序列
        [FuelAcce(i,j),~,~]=CalculateFuel(v,a,t);
    end
end
%2. 匀速燃油喷射率表FuelConst
FuelConst=CalculateConSpdFuelRate(v0);
vTable=v0;
%保存
save Fuel FuelAcce FuelConst vTable;
