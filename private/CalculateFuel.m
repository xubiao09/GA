function [Fuel,P,Fb]=CalculateFuel(v,a,t)
%%
%����ȼ������Fuel(g)������Ϊv���ٶ�����(m/s)��a�����ٶ�����(m/s2)��t��ʱ������(s)
%%
M=1500;  %��������
F=0.015; %������ʻ����ϵ��
A=0.36;  %����ϵ��
ALPHA=[0.590858024136993;0.0573372137218396;0.000139191515258181]; %����ʽ�ͺ�ϵ��
%%
v=v(:);
a=a(:);
t=t(:);
B=M*9.8*F; %������ʻ������N��
P=v.*(M*a+A*v.^2+B)/1000;  %���������ʣ�kw��
Fb=zeros(size(P));
Fb(P>=0)=0;
Fb(P<0)=-(M*a(P<0)+A*v(P<0).^2+B);
P(P<0)=0;
Fc=ALPHA(1)+ALPHA(2)*P+ALPHA(3)*P.^2;
deltaT=t(2:end,:)-t(1:end-1,:);
deltaT=[deltaT;deltaT(end)];
Fuel=sum(Fc.*deltaT);
