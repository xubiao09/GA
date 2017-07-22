function [v,v_opt,c_opt]=GA(green,distance)
%%
%�Ŵ��㷨�������ٶ�����v(m/s)��green{i}Ϊ�̵�����(2*n)����һ��Ϊ�̵ƿ�ʼʱ��(s)���ڶ���Ϊ�̵ƽ���ʱ��(s)��distanceΪ��������������·�ڵľ���(m)
%%
%�Ŵ��㷨����
NumGen=500;    %������Ⱥ��Ŀ
alpha=0.33;    %���Խ�������ϵ��
PMutation=0.2; %�������
N=500;         %��������Ŀ
%%
vmax=60/3.6;
vmin=20/3.6;
NumIntsct=length(distance);
v0=IntialGen(vmax,vmin,NumIntsct,NumGen,distance,green);
v_opt=[];
c_opt=[];
k=0;  %ѭ����Ŀ
while(true)
    v1=CrossGen(v0,alpha);   %%GA��������
    %v2=MutationGen(v1,PMutation,vmax,vmin); 
    v2=MutationGen_new(v1,PMutation,vmax,vmin);  %%GA��������
    Cost=CostFunction(v2,green,distance);  %%GA������ʧ����
    [v3,temp_v_opt,temp_c_opt]=Selection(v2,Cost,NumGen);
    %[v3,temp_v_opt,temp_c_opt]=Selection_new(v2,Cost,NumGen); %%GAѡ������
    v0=v3;
    v_opt=[v_opt,temp_v_opt];   %%GA��ÿ����Ⱥ�����Ÿ���
    c_opt=[c_opt,temp_c_opt];   %%GA��ÿ����Ⱥ�����Ÿ������ʧ����
    k=k+1;
    [k,temp_c_opt]
    %%
    %��ֹ������1. ������������һ��ֵN������2. ������������100������ֵ���Ʋ�����Լ������ȫ������
    if(k>N)
        v=v_opt(:,end);
        break;
    elseif(k>inf)
        if(abs(c_opt(end)-c_opt(end-10))<1e-5)&&(abs(c_opt(end-1)-c_opt(end-9))<1e-5)&&(abs(c_opt(end-2)-c_opt(end-8))<1e-5)&&(c_opt(end)<1)
            v=v_opt(:,end);
            break;
        end
    end
end