function Cost=CostFunction(v,green,distance)
%%
%��ʧ������vΪ�����ٶ�(NumIntsct*NumGen)��green{i}Ϊ�̵���λ(2*n)��distanceΪ�������뽻��·���루NumIntsct*1��
%%
distance=distance(:);
NumIntsct=length(distance);
NumGen=length(v(1,:));
Cost1=zeros(1,NumGen);
Fuel=zeros(1,NumGen);
distance=distance*ones(1,NumGen);  %��distance��γ����vά��һ�£����ڼ���
t_seg=distance./v;                 %����ÿ����Ⱥ����ÿ�ε�ͨ��ʱ��
t=cumsum(t_seg);                   %����ÿ����Ⱥ����ͨ��ÿ������·�ڵ���ʱ��
parfor i=1:NumIntsct
    Cost1_seg(i,:)=IfRed(t(i,:),green{i});
    Fuel_seg(i,:)=CalculateConSpdFuelRate(v(i,:)).*t_seg(i,:);
end
Cost1=sum(Cost1_seg);
Fuel=sum(Fuel_seg);
Cost2=1-exp(-Fuel/2000);
Cost=Cost1+Cost2;