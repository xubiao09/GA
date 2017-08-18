function [t,v,d,fuel,time]=Driver(v0,green,distance)
%Driver drives the car with maximal velocity. Calculate the velocity
%profile,fuel consumption and trip time
NumIntsct = length(distance);  %�������Ŀ
D=cumsum(distance);
t0=0;
d0=0;
vmax=80/3.6;
a0=1.5;
v=v0;   %�洢���ٶȹ���
t=0;    %�洢�����ٶȹ���ƥ���ʱ��
d=0;    %�洢��λ�ƹ���
a=0;    %�洢���ٶ�����
fuel=0;
for i=1:NumIntsct
    v1=vmax;
    tempt=t0+(v1-v0)/a0+(distance(i)-(v1^2-v0^2)/2/a0)/v1;
    G=green{i};
    Green=G(1,:);
    Red  =G(2,:);
    if(any(tempt>Green & tempt<=Red)) %������ٶ�ͨ���ɲ��ü���
        t_acce=linspace(0,(v1-v0)/a0,20);
        t_const=linspace(0,(distance(i)-(v1^2-v0^2)/2/a0)/v1,20);
        t=[t,t0+t_acce,t0+(v1-v0)/a0+t_const];          %�洢���ٶε�ʱ�䡢���ٶε�ʱ��
        v=[v,v0+a0*t_acce,v1+zeros(size(t_const))];     %�洢���ٶε��ٶȡ����ٶε��ٶ�
        d=[d,d0+v0*t_acce+0.5*a0*t_acce.^2,d0+(v1^2-v0^2)/2/a0+v1*t_const]; %�洢���ٶε�λ�ơ����ٶε�λ��
        a=[a,a0*ones(size(t_acce)),zeros(size(t_const))]; %�洢���ٶ�����
        t0=tempt;
        d0=d(end);
        v0=v1;
    else %��ʻ������ٶȺ���Ҫ����
        t_pass=min(Green(Green>tempt));  %�ҵ����ͨ����ʱ��
        tempt=t0+(v1-v0)/a0+v1/a0+(distance(i)-(v1^2-v0^2)/2/a0-v1^2/2/a0)/v1; %������0��ʱ��
        if(tempt<=t_pass)               %���ٶ��轵��0������ͣ���ȴ��̵�
            t_acce=linspace(0,(v1-v0)/a0,20);
            t_dece=linspace(0,v1/a0,20);
            t_const=linspace(0,(distance(i)-(v1^2-v0^2)/2/a0-v1^2/2/a0)/v1,20);
            t_stop=linspace(0,t_pass-tempt,20);
            t=[t,t0+t_acce,t0+max(t_acce)+t_const,t0+max(t_acce)+max(t_const)+t_dece,...
                t0+max(t_acce)+max(t_const)+max(t_dece)+t_stop];
            a=[a,a0+zeros(size(t_acce)),0+zeros(size(t_const)),-a0+zeros(size(t_dece)),...
                0+zeros(size(t_stop))];
            v=[v,v0+a0*t_acce,v1+zeros(size(t_const)),v1-a0*t_dece,zeros(size(t_stop))];
            d=[d,d0+v0*t_acce+0.5*a0*t_acce.^2,d0+(v1^2-v0^2)/2/a0+v1*t_const,...
                d0+(v1^2-v0^2)/2/a0+v1*max(t_const)+v1*t_dece-0.5*a0*t_dece.^2,...
                D(i)+zeros(size(t_stop))];
            t0=t_pass;
            d0=d(end);
            v0=0;
        else
            v_end=-sqrt(-2*a0*distance(i)+2*a0*(t_pass-t0)*v1-(v1-v0)^2)+v1;
            t_acce=linspace(0,(v1-v0)/a0,20);
            t_dece=linspace(0,(v1-v_end)/a0,20);
            t_const=linspace(0,(distance(i)-(v1^2-v0^2)/2/a0-(v1^2-v_end^2)/2/a0)/v1,20);
            t=[t,t0+t_acce,t0+max(t_acce)+t_const,t0+max(t_acce)+max(t_const)+t_dece];
            a=[a,a0+zeros(size(t_acce)),0+zeros(size(t_const)),-a0+zeros(size(t_dece))];
            v=[v,v0+a0*t_acce,v1+zeros(size(t_const)),v1-a0*t_dece];
            d=[d,d0+v0*t_acce+0.5*a0*t_acce.^2,d0+(v1^2-v0^2)/2/a0+v1*t_const,...
                d0+(v1^2-v0^2)/2/a0+v1*max(t_const)+v1*t_dece-0.5*a0*t_dece.^2];
            t0=t_pass;
            d0=d(end);
            v0=v_end;
        end
    end
end
time=t(end);
[fuel,~,~]=CalculateFuel(v,a,t);