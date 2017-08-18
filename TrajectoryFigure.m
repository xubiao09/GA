function TrajectoryFigure(green,v0,v,d,td,vd,dd)
%%
%画图，green: green phase; v: velocity profiles; d: distance
%td,vd,dd分别为最快驾驶的时间、速度、加速度序列
%%
[~,n]     = size(v);
d         = d(:);
NumIntsct = length(v);  %交叉口数目
SumD      = cumsum(d);


Ninter    = 10;         % number of interpolations for the acceleration/decceleration time

t_plot    = zeros(NumIntsct*Ninter+NumIntsct,n);
d_plot    = zeros(NumIntsct*Ninter+NumIntsct,n);
v_plot    = zeros(NumIntsct*Ninter+NumIntsct,n);


%% Creat the plot sequences
for Index = 1:n;
    t0        = 0;
    for i = 1:NumIntsct
        if(i ~= 1)
            t1 = t0 + abs(v(i,Index)-v(i-1,Index))/1.5;                 % time for accleration or deceleration
            d1 = SumD(i-1) + abs(v(i,Index)^2-v(i-1,Index)^2)/2/1.5;                % distance for accleration or deceleration
            t_acce = linspace(t0,t1,10);
            if v(i,Index) > v0
                a = 1.5;
            else
                a = -1.5;
            end
            d_acce = SumD(i-1) + v(i-1,Index)*(t_acce - t0) + 0.5*a*(t_acce-t0).^2;
            v_acce = linspace(v(i-1,Index),v(i,Index),10);
            t2 = t1 + (SumD(i)-d1)/v(i,Index);
            t_plot((Ninter+1)*(i-1)+1:(Ninter+1)*i,Index) = [t_acce';t2];
            d_plot((Ninter+1)*(i-1)+1:(Ninter+1)*i,Index) = [d_acce';SumD(i)];
            v_plot((Ninter+1)*(i-1)+1:(Ninter+1)*i,Index) = [v_acce';v(i,Index)];
            t0     = t2;
        else
            t1     = t0 + abs(v(i,Index)   - v0)/1.5;
            d1     = 0  + abs(v(i,Index)^2 - v0^2)/2/1.5;
            t_acce = linspace(t0,t1,Ninter);
            if v(i,Index) > v0
                a = 1.5;
            else
                a = -1.5;
            end
            d_acce = 0 + v0*(t_acce-t0) + 0.5*a*(t_acce-t0).^2;
            v_acce = linspace(v0,v(i,Index),Ninter);
            t2     = t1 + (SumD(i)-d1)/v(i,Index);
            t_plot((Ninter+1)*(i-1)+1:(Ninter+1)*i,Index) = [t_acce';t2];
            d_plot((Ninter+1)*(i-1)+1:(Ninter+1)*i,Index) = [d_acce';SumD(i)];
            v_plot((Ninter+1)*(i-1)+1:(Ninter+1)*i,Index) = [v_acce';v(i,Index)];
            t0     = t2;
        end
    end
end

figure; hold on; % first, plot the green light phase
for i=1:NumIntsct
    G = green{i};
    for j = 1:length(G(1,:))
        plot(G(:,j),[SumD(i);SumD(i)],'g','LineWidth',2);
    end
end

ColorSet = ['k','b','m','r','c','y'];
for Index = 1:n
    h(Index) = plot(t_plot(:,Index),d_plot(:,Index),ColorSet(Index),'LineWidth',2);
end
h(Index+1) = plot(td,dd,ColorSet(Index+1),'LineWidth',2);
xlim([0, max(t_plot(end,:))*1.1]);
set(gca,'Position',[0.1 0.2 0.85 0.75],'TickLabelInterpreter','latex','fontsize',8)

xlabel('Time ($s$)','interpreter','latex','fontsize',8);
ylabel('Distance ($m$)','interpreter','latex','fontsize',8);
set(gca,'TickLabelInterpreter','latex','FontSize',8);
set(gcf,'Position',[250 150 500 400]);
h1 = legend([h(1),h(2),h(3),h(4),h(5)],'1 intersection','2 intersections','5 intersections','10 intersections','Fast driving');
set(h1,'orientation','horizontal','FontSize',8,...
    'Position',[0.15 0.06 0.7 0.03],'Interpreter','latex')
set(h1,'box','off')

print(gcf,'Fig1.eps','-painters','-depsc2','-r 600')

figure; hold on;
ColorSet = ['k','b','m','r','c','y'];
for Index = 1:n
    h(Index)=plot(t_plot(:,Index),v_plot(:,Index),ColorSet(Index),'LineWidth',2);
end
h(Index+1) = plot(td,vd,ColorSet(Index+1),'LineWidth',2);
xlabel('Time ($s$)','interpreter','latex','fontsize',8);
ylabel('Velocity ($m/s$)','interpreter','latex','fontsize',8);
h1 = legend([h(1),h(2),h(3),h(4),h(5)],'1 intersection','2 intersections','5 intersections','10 intersections','Fast driving');
set(gca,'TickLabelInterpreter','latex','FontSize',8);
grid on;
