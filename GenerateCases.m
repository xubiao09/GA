%%
%生成工况
%%
clear;
clc;
N=5;  %灯的数目
Cycle0=50:5:80;
Distance0=400:20:800;
for i=1:N
    Index_C=randi([1,length(Cycle0)]);
    Cycle=Cycle0(Index_C);
    randnum=0.3+0.4*rand();
    GreenTime=ceil(Cycle*randnum);
    if(GreenTime>50)
        GreenTime=50;
    elseif(GreenTime<15)
        GreenTime=15;
    end
    PhaseTime0=randi([0,Cycle]);
    green{i}=[(0:1:40)*Cycle-PhaseTime0;(0:1:40)*Cycle-PhaseTime0+GreenTime];
    Index_D=randi([1,length(Distance0)]);
    distance(i)=Distance0(Index_D);
end
save TrafficSignal green distance;
