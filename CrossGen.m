function [v3,v4] = CrossGen(v1,v2,t1,t2,alpha,vmax,vmin,green,distance,v0)
%%
%���Խ������ӣ�����ϵ��Ϊalpha,ĸ��Ϊv1��v2���Ӵ�Ϊv3��v4
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
    tmin3_1=TotalTime1+(vmax-tempv0_1)/1.5+(distance(i)-(vmax^2-tempv0_1^2)/3)/vmax;     %�˶�ѧԼ�������ʱ�䣨�Ӵ�1��
    tmin3_2=TotalTime2+(vmax-tempv0_2)/1.5+(distance(i)-(vmax^2-tempv0_2^2)/3)/vmax;     %�˶�ѧԼ�������ʱ�䣨�Ӵ�2��
    tmin1=min(t1(i),t2(i));                               %����ĸ�����е�ʱ���������Сֵ
    tmax1=max(t1(i),t2(i));                               %����ĸ�����е�ʱ����������ֵ
    tmin1_1=max(tmin1,tmin3_1);                               %�˶�ѧԼ�����ʱ����������Сֵȡ�������Ӵ�1��
    tmin1_2=max(tmin1,tmin3_2);                               %�˶�ѧԼ�����ʱ����������Сֵȡ�������Ӵ�2��
    Index1=find(tmin1_1<green{i}(2,:)&tmax1>green{i}(1,:));   %�ҳ����������Сʱ���ڵ��̵�����1���Ӵ�1��
    Index2=find(tmin1_2<green{i}(2,:)&tmax1>green{i}(1,:));   %�ҳ����������Сʱ���ڵ��̵�����2���Ӵ�2��
    if(~isempty(Index1))                              %���̵�����1����
        SelectIndex=Index1(randi([1,length(Index1)]));     %���ѡ��һ������
        tmin2_1=green{i}(1,SelectIndex);                      %�ҳ����ѡ�����������Сʱ�䣨�Ӵ�1��
        tmax2=green{i}(2,SelectIndex);                      %�ҳ����ѡ������������ʱ�䣨�Ӵ�1��
        tmin_1=max(tmin1_1,tmin2_1);                           %�ҳ���������Ľ������Ӵ�1��
        tmax_1=min(tmax1,tmax2);
    else                                             %���̵�����1������
        tmin_1=tmin1_1;
        tmax_1=tmax1;
    end
    if(~isempty(Index2))                              %���̵�����2����
        SelectIndex=Index2(randi([1,length(Index2)]));     %���ѡ��һ�����䣨�Ӵ�2��
        tmin2_2=green{i}(1,SelectIndex);                      %�ҳ����ѡ�����������Сʱ�䣨�Ӵ�2��
        tmax2=green{i}(2,SelectIndex);                      %�ҳ����ѡ������������ʱ�䣨�Ӵ�2��
        tmin_2=max(tmin1_2,tmin2_2);                           %�ҳ���������Ľ������Ӵ�2��
        tmax_2=min(tmax1,tmax2);
    else                                             %���̵�����2������
        tmin_2=tmin1_1;
        tmax_2=tmax1;
    end
    tempt3=alpha*tmin_1+(1-alpha)*tmax_1;                %����õ��Ӵ�1
    tempt4=(1-alpha)*tmin_2+alpha*tmax_2;                %����õ��Ӵ�2
    t3=tempt3-TotalTime1;                            %�õ�ÿ�ε�ʱ��
    t4=tempt4-TotalTime2;
    
    tempd=distance(i);
    if(tempd/tempv0_1<t3)     %��Ҫ����
        a=-1.5;
        v3(i,1)=tempv0_1+a*t3+sqrt(2*a*t3*tempv0_1+a^2*t3^2-2*a*tempd);
    elseif(tempd/tempv0_1>t3) %��Ҫ����
        a=1.5;
        v3(i,1)=tempv0_1+a*t3-sqrt(2*a*t3*tempv0_1+a^2*t3^2-2*a*tempd);
    else                      %��������
        v3(i,1)=tempv0_1;
    end
    if(tempd/tempv0_2<t4)     %��Ҫ����
        a=-1.5;
        v4(i,1)=tempv0_2+a*t4+sqrt(2*a*t4*tempv0_2+a^2*t4^2-2*a*tempd);
    elseif(tempd/tempv0_2>t4) %��Ҫ����
        a=1.5;
        v4(i,1)=tempv0_2+a*t4-sqrt(2*a*t4*tempv0_2+a^2*t4^2-2*a*tempd);
    else                      %��������
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