function v1=MutationGen_new(v0,PMutation,vmax,vmin)
%%
%�������ӣ��ӳ�ʼ��Ⱥv0(NumIntsct*NumGen)��ѡ��һ�����������ݸ��ʱ���õ�������Ⱥv1(NumIntsct*NumGen)��PMutationΪ�������
%%
NumIntsct=length(v0(:,1));  %�������Ŀ
NumGen=length(v0(1,:));     %��Ⱥ��Ŀ
v1=v0;
for i=1:NumGen
    if(rand()<=PMutation)
        Indvd=v0(:,i);                %����ĸ���
        PRand=rand(NumIntsct,1);
        TempIndex=PRand<=PMutation; %�������ĸ���Ļ����������
        R = normrnd(Indvd,3*ones(size(Indvd)));  %������̬�ֲ������
        R(R>vmax)=vmax;
        R(R<vmin)=vmin;
        Indvd(TempIndex)=R(TempIndex);         %���������Ļ�������滻
        v1=[v1,Indvd];                         %�滻������壬�õ�������Ⱥv1
    end
end