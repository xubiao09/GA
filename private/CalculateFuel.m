function [Fuel,P,Fb]=CalculateFuel(v,a,t)
%%
%计算燃油消耗Fuel(g)，输入为v—速度向量(m/s)，a—加速度向量(m/s2)，t—时间向量(s)
%%
M=1500;  %汽车质量
F=0.015; %地面行驶阻力系数
A=0.36;  %风阻系数
ALPHA=[0.590858024136993;0.0573372137218396;0.000139191515258181]; %多项式油耗系数
%%
v=v(:);
a=a(:);
t=t(:);
B=M*9.8*F; %地面行驶阻力（N）
P=v.*(M*a+A*v.^2+B)/1000;  %发动机功率（kw）
Fb=zeros(size(P));
Fb(P>=0)=0;
Fb(P<0)=-(M*a(P<0)+A*v(P<0).^2+B);
P(P<0)=0;
Fc=ALPHA(1)+ALPHA(2)*P+ALPHA(3)*P.^2;
deltaT=t(2:end,:)-t(1:end-1,:);
deltaT=[deltaT;deltaT(end)];
Fuel=sum(Fc.*deltaT);
