function [v3,v4] = CrossGen(v1,v2,t1,t2,alpha,vmax,vmin,green,distance,v0)
%%
%线性交叉算子，交叉系数为alpha,母代为v1和v2，子代为v3和v4
%t1 is the trip time when arriving at each intersection for v1
%t2 is the trip time when arriving at each intersection for v2
%%
N=length(v1);   %No. of intersections
TotalTime1=0;
TotalTime2=0;
for i=1:N
    tmin1=min(t1(i),t2(i));
    tmax1=max(t1(i),t2(i));
    Index=find(tmin1<green{i}(2,:)&tmax1>green{i}(1,:));   %找出落在最大最小时间内的绿灯区间
    if(~isempty(Index))                              %若存在
        SelectIndex=Index(randi([1,length(Index)]));     %随机选出一个区间
        tmin2=green{i}(1,SelectIndex);                      %找出随机选出的区间的最小时间
        tmax2=green{i}(2,SelectIndex);                      %找出随机选出的区间的最大时间
        
        tmin=max(tmin1,tmin2);                           %找出两个区间的交集
        tmax=min(tmax1,tmax2);
    else                                             %若不存在
        tmin=tmin1;
        tmax=tmax1;
    end
        tempt3=alpha*tmin+(1-alpha)*tmax;                %将旅行时间进行交叉
        tempt4=(1-alpha)*tmin+alpha*tmax;
        t3=tempt3-TotalTime1;                            %得到每段的时间
        t4=tempt4-TotalTime2;
        if(i==1)
            tempv0_1=v0;
            tempv0_2=v0;
        else
            tempv0_1=v3(i-1);
            tempv0_2=v4(i-1);
        end
        tempd=distance(i);
        if(tempd/tempv0_1<t3)     %需要减速
            a=-1.5;
            v3(i,1)=tempv0_1+a*t3+sqrt(2*a*t3*tempv0_1+a^2*t3^2-2*a*tempd);
        elseif(tempd/tempv0_1>t3) %需要加速
            a=1.5;
            v3(i,1)=tempv0_1+a*t3-sqrt(2*a*t3*tempv0_1+a^2*t3^2-2*a*tempd);
        else                      %保持匀速
            v3(i,1)=tempv0_1;
        end
        if(tempd/tempv0_2<t4)     %需要减速
            a=-1.5;
            v4(i,1)=tempv0_2+a*t4+sqrt(2*a*t4*tempv0_2+a^2*t4^2-2*a*tempd);
        elseif(tempd/tempv0_2>t4) %需要加速
            a=1.5;
            v4(i,1)=tempv0_2+a*t4-sqrt(2*a*t4*tempv0_2+a^2*t4^2-2*a*tempd);
        else                      %保持匀速
            v4(i,1)=tempv0_2;
        end
        v3(i,1)=max(min(v3(i,1),vmax),vmin);
        v4(i,1)=max(min(v4(i,1),vmax),vmin);
        TotalTime1=tempt3;
        TotalTime2=tempt4;
end