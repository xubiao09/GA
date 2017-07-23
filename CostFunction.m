function Cost = CostFunction(v0,v,green,distance)
%%
%损失函数，v0为初速度，v为各段�?�?NumIntsct*NumGen)，green{i}为绿灯相�?2*n)，distance为车辆距离交叉路距离（NumIntsct*1�?
load Fuel;
%%
a=1.5;
distance   = distance(:);
NumIntsct  = length(distance);
NumGen     = length(v(1,:));
Cost1      = zeros(1,NumGen);
Fuel       = zeros(1,NumGen);
distance   = distance*ones(1,NumGen);           %将distance扩纬成与v维度�?��，便于计�?
v1         = [v0*ones(1,NumGen);v(1:end-1,:)];  %各个体各段的初�?度矩阵，i行j列表示第j个个体第i个路口初速度
v2         = v;                                 %各个体各段的末�?度矩阵，i行j列表示第j个个体第i个路口末速度
d1         = abs(v2.^2-v1.^2)/2/a;              %加�?段的距离
t1         = abs(v2-v1)/a;                      %加�?段的时间
d2         = distance-d1;                       %�??段的距离
t2         = d2./v2;                            %�??段的时间
t_seg      = t1+t2;                             %计算每个种群个体每段的�?过时�?
t          = cumsum(t_seg);                     %计算每个种群个体通过每个交叉路口的�?时间
%parfor i = 1:NumIntsct
for i = 1:NumIntsct
    Cost1_seg(i,:) = IfRed(t(i,:),green{i});
    for j = 1:NumGen
        %先计算加速段的油�?
        v_ind1=v1(i,j);
        v_ind2=v2(i,j);
        %找到初�?度对应的油�?表的�?
        Temp=find(v_ind1<=vTable);
        iIndex=Temp(1);
        %找到末�?度对应的油�?表的�?
        Temp=find(v_ind2<=vTable);
        jIndex=Temp(1);
        Fuel1=FuelAcce(iIndex,jIndex);
        %再计算匀速段的油�?
        Fuel2=FuelConst(jIndex)*t2(i,j);
        %计算总油�?
        Fuel_seg(i,j)=Fuel1+Fuel2;
    end
end
Cost1 = sum(Cost1_seg);
Fuel  = sum(Fuel_seg);
Cost2 = 1-exp(-Fuel/2000);
Cost = Cost1+Cost2;
