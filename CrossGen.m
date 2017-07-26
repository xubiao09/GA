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
    if(i==1)
        tempv0_1=v0;
        tempv0_2=v0;
    else
        tempv0_1=v3(i-1);
        tempv0_2=v4(i-1);
    end
    tmin3_1=TotalTime1+(vmax-tempv0_1)/1.5+(distance(i)-(vmax^2-tempv0_1^2)/3)/vmax;     %运动学约束的最短时间（子代1）
    tmin3_2=TotalTime2+(vmax-tempv0_2)/1.5+(distance(i)-(vmax^2-tempv0_2^2)/3)/vmax;     %运动学约束的最短时间（子代2）
    tmin1=min(t1(i),t2(i));                               %两个母代所夹的时间区间的最小值
    tmax1=max(t1(i),t2(i));                               %两个母代所夹的时间区间的最大值
    tmin1_1=max(tmin1,tmin3_1);                               %运动学约束最短时间和上面的最小值取交集（子代1）
    tmin1_2=max(tmin1,tmin3_2);                               %运动学约束最短时间和上面的最小值取交集（子代2）
    Index1=find(tmin1_1<green{i}(2,:)&tmax1>green{i}(1,:));   %找出落在最大最小时间内的绿灯区间1（子代1）
    Index2=find(tmin1_2<green{i}(2,:)&tmax1>green{i}(1,:));   %找出落在最大最小时间内的绿灯区间2（子代2）
    if(~isempty(Index1))                              %若绿灯区间1存在
        SelectIndex=Index1(randi([1,length(Index1)]));     %随机选出一个区间
        tmin2_1=green{i}(1,SelectIndex);                      %找出随机选出的区间的最小时间（子代1）
        tmax2=green{i}(2,SelectIndex);                      %找出随机选出的区间的最大时间（子代1）
        tmin_1=max(tmin1_1,tmin2_1);                           %找出两个区间的交集（子代1）
        tmax_1=min(tmax1,tmax2);
    else                                             %若绿灯区间1不存在
        tmin_1=tmin1_1;
        tmax_1=tmax1;
    end
    if(~isempty(Index2))                              %若绿灯区间2存在
        SelectIndex=Index2(randi([1,length(Index2)]));     %随机选出一个区间（子代2）
        tmin2_2=green{i}(1,SelectIndex);                      %找出随机选出的区间的最小时间（子代2）
        tmax2=green{i}(2,SelectIndex);                      %找出随机选出的区间的最大时间（子代2）
        tmin_2=max(tmin1_2,tmin2_2);                           %找出两个区间的交集（子代2）
        tmax_2=min(tmax1,tmax2);
    else                                             %若绿灯区间2不存在
        tmin_2=tmin1_1;
        tmax_2=tmax1;
    end
    tempt3=alpha*tmin_1+(1-alpha)*tmax_1;                %交叉得到子代1
    tempt4=(1-alpha)*tmin_2+alpha*tmax_2;                %交叉得到子代2
    t3=tempt3-TotalTime1;                            %得到每段的时间
    t4=tempt4-TotalTime2;
    
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
%     if(v3(i,1)>vmax)
%         TEST=1;     %for breakpoint
%     end
    v3(i,1)=max(min(v3(i,1),vmax),vmin);
    v4(i,1)=max(min(v4(i,1),vmax),vmin);
    TotalTime1=tempt3;
    TotalTime2=tempt4;
end