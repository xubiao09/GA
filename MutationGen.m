function v1=MutationGen(v0,PMutation,vmax,vmin)
%%
%�������ӣ��ӳ�ʼ��Ⱥv0(NumIntsct*NumGen)��ѡ��һ�����������ݸ��ʱ���õ�������Ⱥv1(NumIntsct*NumGen)��PMutationΪ�������
%%
NumIntsct=length(v0(:,1));  %�������Ŀ
NumGen=length(v0(1,:));     %��Ⱥ��Ŀ
N=randi([1,NumGen]);        %ѡ�����ĸ�������
Indvd=v0(:,N);                %����ĸ���
PRand=rand(NumIntsct,1);
TempIndex=PRand<=PMutation; %�������ĸ���Ļ����������
R = normrnd(Indvd,ones(size(Indvd)));  %������̬�ֲ������
R(R>vmax)=vmax;
R(R<vmin)=vmin;
Indvd(TempIndex)=R(TempIndex);         %���������Ļ�������滻
v1=v0;
v1(:,N)=Indvd;                         %�滻������壬�õ�������Ⱥv1
