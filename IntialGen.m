function v0=IntialGen(vmax,vmin,v_initial,NumIntsct,NumGen,d,green,v00)
%%
%得到初始种群v0(NumIntsct*NumGen)，vmax为速度上限，vmin为速度下限，NumIntsct为交叉口数目,
%d为交叉路口间距离，green为绿灯相位，v00为构造的初始解

%%
Prb = 0.4;
v0  = [];
%%
%放入初始解
v0  = [v0,v00];
%%
%构造最短时间的解
t0 = 0;
velocity0 = v_initial;
for j = 1:NumIntsct
    t01       = t0 + (vmax - velocity0)/1.5 + (d(j)-(vmax^2-velocity0^2)/3)/vmax;
    t02       = t0 + d(j)/vmin;
    Index     = find(t01<green{j}(2,:)&t02>green{j}(1,:));  %找到最大最小时间之间的相位
    CycleN    = Index(1);                                   %选取时间最短的周期通过
    CycleLow  = max(t01,green{j}(1,CycleN));
    t_corss   = CycleLow-t0;
    t0        = CycleLow;
    if(d(j)/velocity0 < t_corss)  %需要减速
        a = -1.5;
        tempv0(j,1) = velocity0+a*t_corss+sqrt(2*a*t_corss*velocity0+a^2*t_corss^2-2*a*d(j));
    elseif(d(j)/velocity0>t_corss) %需要加速
        a=1.5;
        tempv0(j,1) = velocity0+a*t_corss-sqrt(2*a*t_corss*velocity0+a^2*t_corss^2-2*a*d(j));
    else                           %保持匀速
        tempv0(j,1) = d(j)/t_corss;
    end
    velocity0 = tempv0(j,1);
end
v0 = [v0,tempv0];

%% 构造其余解
TempN = length(v0(1,:));
for i = TempN+1:NumGen
    if(rand() <= Prb)
        %构造符合约束条件的解
        t0 = 0;
        for j = 1:NumIntsct
            t01    = t0 + d(j)/vmax;
            t02    = t0 + d(j)/vmin;
            Index  = find(t01<green{j}(2,:)&t02>green{j}(1,:));  %找到最大最小时间之间的相位
            n      = randi([1,length(Index)]);
            CycleN = Index(n);         %选取一个周期通过
            if(n == 1)
                CycleLow  = max(t01,green{j}(1,CycleN));
                CycleHigh = green{j}(2,CycleN);
            elseif(n == length(Index))
                CycleLow  = green{j}(1,CycleN);
                CycleHigh = min(t02,green{j}(2,CycleN));
            else
                CycleLow  = green{j}(1,CycleN);
                CycleHigh = green{j}(2,CycleN);
            end
            t_corss     = CycleLow+rand()*(CycleHigh-CycleLow)-t0;
            t0          = t_corss+t0;
            tempv0(j,1) = d(j)/t_corss;
        end
        v0 = [v0,tempv0];
    else
        rou = rand(NumIntsct,1);
        v0  = [v0,vmin+rou*(vmax-vmin)];
    end
end