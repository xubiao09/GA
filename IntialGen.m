function v0=IntialGen(vmax,vmin,v_initial,NumIntsct,NumGen,d,green,v00)
%%
%�õ���ʼ��Ⱥv0(NumIntsct*NumGen)��vmaxΪ�ٶ����ޣ�vminΪ�ٶ����ޣ�NumIntsctΪ�������Ŀ,
%dΪ����·�ڼ���룬greenΪ�̵���λ��v00Ϊ����ĳ�ʼ��

%%
Prb = 0.4;
v0  = [];
%%
%�����ʼ��
v0  = [v0,v00];
%%
%�������ʱ��Ľ�
t0 = 0;
velocity0 = v_initial;
for j = 1:NumIntsct
    t01       = t0 + (vmax - velocity0)/1.5 + (d(j)-(vmax^2-velocity0^2)/3)/vmax;
    t02       = t0 + d(j)/vmin;
    Index     = find(t01<green{j}(2,:)&t02>green{j}(1,:));  %�ҵ������Сʱ��֮�����λ
    CycleN    = Index(1);                                   %ѡȡʱ����̵�����ͨ��
    CycleLow  = max(t01,green{j}(1,CycleN));
    t_corss   = CycleLow-t0;
    t0        = CycleLow;
    if(d(j)/velocity0 < t_corss)  %��Ҫ����
        a = -1.5;
        tempv0(j,1) = velocity0+a*t_corss+sqrt(2*a*t_corss*velocity0+a^2*t_corss^2-2*a*d(j));
    elseif(d(j)/velocity0>t_corss) %��Ҫ����
        a=1.5;
        tempv0(j,1) = velocity0+a*t_corss-sqrt(2*a*t_corss*velocity0+a^2*t_corss^2-2*a*d(j));
    else                           %��������
        tempv0(j,1) = d(j)/t_corss;
    end
    velocity0 = tempv0(j,1);
end
v0 = [v0,tempv0];

%% ���������
TempN = length(v0(1,:));
for i = TempN+1:NumGen
    if(rand() <= Prb)
        %�������Լ�������Ľ�
        t0 = 0;
        for j = 1:NumIntsct
            t01    = t0 + d(j)/vmax;
            t02    = t0 + d(j)/vmin;
            Index  = find(t01<green{j}(2,:)&t02>green{j}(1,:));  %�ҵ������Сʱ��֮�����λ
            n      = randi([1,length(Index)]);
            CycleN = Index(n);         %ѡȡһ������ͨ��
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