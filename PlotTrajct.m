function PlotTrajct(green,v0,v,d)
%%
%画图，green为绿灯相位，v为各段车速，d为距离
%%
d=d(:);
v=v(:);
NumIntsct=length(v);  %交叉口数目
SumD=cumsum(d);
t0=0;
d0=0;
t_plot=[];
d_plot=[];
v_plot=[];
figure(2);
hold on;
for i=1:NumIntsct
    G=green{i};
    for j=1:length(G(1,:))
        plot(G(:,j),[SumD(i);SumD(i)],'g','LineWidth',2);
    end
    if(i~=1)
        %plot([SumT(i-1),SumT(i)],[SumD(i-1),SumD(i)],'y','LineWidth',2);
        t1=t0+abs(v(i)-v(i-1))/1.5;
        d1=SumD(i-1)+abs(v(i)^2-v(i-1)^2)/2/1.5;
        t_acce=linspace(t0,t1,10);
        d_acce=SumD(i-1)+v(i-1)*(t_acce-t0)+0.5*1.5*(t_acce-t0).^2;
        v_acce=linspace(v(i-1),v(i),10);
        t2=t1+(SumD(i)-d1)/v(i);
        t_plot=[t_plot,t_acce,t2];
        d_plot=[d_plot,d_acce,SumD(i)];
        v_plot=[v_plot,v_acce,v(i)];
        t0=t2;
    else
        %plot([0,SumT(i)],[0,SumD(i)],'y','LineWidth',2);
        t1=t0+abs(v(i)-v0)/1.5;
        d1=0+abs(v(i)^2-v0^2)/2/1.5;
        t_acce=linspace(t0,t1,10);
        d_acce=0+v0*(t_acce-t0)+0.5*1.5*(t_acce-t0).^2;
        v_acce=linspace(v0,v(i),10);
        t2=t1+(SumD(i)-d1)/v(i);
        t_plot=[t_plot,t_acce,t2];
        d_plot=[d_plot,d_acce,SumD(i)];
        v_plot=[v_plot,v_acce,v(i)];
        t0=t2;
    end
end
plot(t_plot,d_plot,'LineWidth',2);
xlabel('t[s]');
ylabel('d[m]');
xlim([0,max(t_plot)+10]);
hold off;
figure(3);
hold on;
plot(t_plot,v_plot,'LineWidth',2);
xlabel('t[s]');
ylabel('v[m/s]');
ylim([0,20]);
grid on;
hold off;
