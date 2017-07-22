function Cost=IfRed(t,green)
%%
%根据车辆是否碰到红灯计算损失函数一部分Cost(1*NumGen)，若遇见红灯则cost为1，否则为0，t为到达时间（s）(1*NumGen),green为绿灯相位(2*n)
%%
NumGen = length(t);%种群大小
n      = length(green(1,:)); %绿灯相位的周期数
Green  = green(1,:);
Red    = green(2,:);
Cost   = ones(1,NumGen);
%parfor i = 1:NumGen
for i = 1:NumGen
    TempIndex = any(t(i)>Green & t(i)<=Red);
    if(TempIndex == 1)
        Cost(1,i) = 0;
    end
end