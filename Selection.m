function [v1,t1]=Selection(v0,Time_seg,Cost)
%%
%���ݸ��ʽ���ѡ��,�������̶ĵķ�������ѡ��
%%
[~,Index] = sort(Cost);  %��������
tempv     = v0(:,Index);
tempt     = Time_seg(:,Index);
NumGen    = length(v0(1,:));
tempn     = 1:NumGen;
Pn        = 2*tempn/NumGen/(NumGen+1);  %�����д�1~NumGen�ĸ���
P         = cumsum(Pn);                %�����ۻ����
v1        = [];

%ͨ�����̶ķ������ݸ������ѡ������
p = rand();
c = find(P <= p);
if(~isempty(c))
    v1 = tempv(:,c(end)+1);
    t1 = tempt(:,c(end)+1);
else
    v1 = tempv(:,1);
    t1 = tempt(:,1);
end

