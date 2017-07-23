%%
%���ɼ����ͺģ�g�������ڲ��ң����ټ������������Ǽ���Ϊ�ȼ��ȼ��٣����ٶ�Ϊ1.5m/s2
%���������ͺ������ʣ�g/s�������ڲ��ң����ټ�����
%%
clear;
clc;
%1. �����ͺı�FuelAcce
v0=5.5:0.1:16.7;     %���ٶγ��ٶȣ�m/s
v1=5.5:0.1:16.7;     %���ٶ�ĩ�ٶȣ�m/s
n=100;               %��ĩ�ٶȲ�ֵ����
a0=1.5;              %�㶨���ٶ�ֵ��m/s2
for i=1:length(v0)
    for j=1:length(v1)
        ve0=v0(i);
        ve1=v1(j);
        v=linspace(ve0,ve1,n);             %�ٶ�����
        if(ve0<=ve1)
            a=a0*ones(1,100);            %���ٶ�����
        else
            a=-a0*ones(1,100);            %���ٶ�����
        end
        t=linspace(0,(ve1-ve0)/a(1),n); %ʱ������
        [FuelAcce(i,j),~,~]=CalculateFuel(v,a,t);
    end
end
%2. ����ȼ�������ʱ�FuelConst
FuelConst=CalculateConSpdFuelRate(v0);
vTable=v0;
%����
save Fuel FuelAcce FuelConst vTable;
