function Cost=CostFunction(v,green,distance)
%%
%损失函数，v为各段速度(NumIntsct*NumGen)，green{i}为绿灯相位(2*n)，distance为车辆距离交叉路距离（NumIntsct*1）
%%
distance=distance(:);
NumIntsct=length(distance);
NumGen=length(v(1,:));
Cost1=zeros(1,NumGen);
Fuel=zeros(1,NumGen);
distance=distance*ones(1,NumGen);  %将distance扩纬成与v维度一致，便于计算
t_seg=distance./v;                 %计算每个种群个体每段的通过时间
t=cumsum(t_seg);                   %计算每个种群个体通过每个交叉路口的总时间
parfor i=1:NumIntsct
    Cost1_seg(i,:)=IfRed(t(i,:),green{i});
    Fuel_seg(i,:)=CalculateConSpdFuelRate(v(i,:)).*t_seg(i,:);
end
Cost1=sum(Cost1_seg);
Fuel=sum(Fuel_seg);
Cost2=1-exp(-Fuel/2000);
Cost=Cost1+Cost2;