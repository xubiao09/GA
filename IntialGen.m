function v0=IntialGen(vmax,vmin,NumIntsct,NumGen,d,green)
%%
%�õ���ʼ��Ⱥv0(NumIntsct*NumGen)��vmaxΪ�ٶ����ޣ�vminΪ�ٶ����ޣ�NumIntsctΪ�������Ŀ,dΪ����·�ڼ���룬greenΪ�̵���λ
%%
Prb=0.2;
v0=[];
for i=1:NumGen
    if(rand()<=Prb)
        %�������Լ�������Ľ�
        t0=0;
        for j=1:NumIntsct
            t01=t0+d(j)/vmax;
            t02=t0+d(j)/vmin;
            Index=find(t01<green{j}(2,:)&t02>green{j}(1,:));  %�ҵ������Сʱ��֮�����λ
            n=randi([1,length(Index)]);
            CycleN=Index(n);         %ѡȡһ������ͨ��
            if(n==1)
                CycleLow=max(t01,green{j}(1,CycleN));
                CycleHigh=green{j}(2,CycleN);
            elseif(n==length(Index))
                CycleLow=green{j}(1,CycleN);
                CycleHigh=min(t02,green{j}(2,CycleN));
            else
                CycleLow=green{j}(1,CycleN);
                CycleHigh=green{j}(2,CycleN);
            end
            t_corss=CycleLow+rand()*(CycleHigh-CycleLow)-t0;
            t0=t_corss+t0;
            tempv0(j,1)=d(j)/t_corss;
        end
        v0=[v0,tempv0];
    else
        rou=rand(NumIntsct,1);
        v0=[v0,vmin+rou*(vmax-vmin)];
    end
end