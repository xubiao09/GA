function [v1,v_opt,c_opt]=Selection_new(v0,Cost,NumGen)
%%
%���ݸ��ʽ���ѡ��,�ȸ���Cost��������1~ri~NumGen��Ȼ���ո���ri/NumGen(NumGen+1)����ѡ��õ�ѡ�������v1�����ŵ�����Ϊv_opt�����ŵ�ֵΪc_opt
%%
[Cost,Index]=sort(Cost);  %��������
c_opt=Cost(1);
tempv=v0(:,Index);
v_opt=tempv(:,1);
v1=tempv(:,1:NumGen);
