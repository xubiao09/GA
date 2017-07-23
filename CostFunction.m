function Cost = CostFunction(v0,v,green,distance)
%%
%��ʧ������v0Ϊ���ٶȣ�vΪ�����ٶ�(NumIntsct*NumGen)��green{i}Ϊ�̵���λ(2*n)��distanceΪ�������뽻��·���루NumIntsct*1��
load Fuel;
%%
a=1.5;
distance   = distance(:);
NumIntsct  = length(distance);
NumGen     = length(v(1,:));
distance   = distance*ones(1,NumGen);          %��distance��γ����vά��һ�£����ڼ���
v1         =[v0*ones(1,NumGen);v(1:end-1,:)];  %��������εĳ��ٶȾ���i��j�б�ʾ��j�������i��·�ڳ��ٶ�
v2         =v;                                 %��������ε�ĩ�ٶȾ���i��j�б�ʾ��j�������i��·��ĩ�ٶ�
d1         =abs(v2.^2-v1.^2)/2/a;              %���ٶεľ���
t1         =abs(v2-v1)/a;                      %���ٶε�ʱ��
d2         =distance-d1;                       %���ٶεľ���
t2         =d2./v2;                            %���ٶε�ʱ��
t_seg      = t1+t2;                            %����ÿ����Ⱥ����ÿ�ε�ͨ��ʱ��
t          = cumsum(t_seg);                    %����ÿ����Ⱥ����ͨ��ÿ������·�ڵ���ʱ��
%parfor i = 1:NumIntsct
for i = 1:NumIntsct
    Cost1_seg(i,:) = IfRed(t(i,:),green{i});
    for j=1:NumGen
        %�ȼ�����ٶε��ͺ�
        v_ind1=v1(i,j);
        v_ind2=v2(i,j);
        %�ҵ����ٶȶ�Ӧ���ͺı����
        Temp=find(v_ind1<=vTable);
        iIndex=Temp(1);
        %�ҵ�ĩ�ٶȶ�Ӧ���ͺı����
        Temp=find(v_ind2<=vTable);
        jIndex=Temp(1);
        Fuel1=FuelAcce(iIndex,jIndex);
        %�ټ������ٶε��ͺ�
        Fuel2=FuelConst(jIndex)*t2(i,j);
        %�������ͺ�
        Fuel_seg(i,j)=Fuel1+Fuel2;
    end
end
Cost1 = sum(Cost1_seg);
Fuel  = sum(Fuel_seg);
Cost2 = 1-exp(-Fuel/2000);
Cost = Cost1+Cost2;