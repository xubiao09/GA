clear;close all; clc;
load TrafficSignal.mat;
v0   = 10;
flag = 3;           % 1: fuel consumption, 2:trip time, 3: combined
N    = length(distance);
if(mod(N,10) ~= 0)
    fprintf('Error, No. of intersections must be a multiple of 20');
end

%%
n = [1,2,5,10];    % 1,2,5,10个路口1组进行优化

v_opt = zeros(N,length(n));
t_opt = zeros(1,length(n));
f_opt = zeros(1,length(n));
f_seg = zeros(N,length(n));
for Index = 1:length(n)
    ni = n(Index);
    if Index == 1
        v_initial = [];
    end
    [v,t,fopt,fseg] = glov(ni,v0,green,distance,v_initial,flag);
    v_opt(:,Index) = v;
    t_opt(Index)   = t;
    f_opt(Index)   = fopt;
    f_seg(:,Index) = fseg;
    v_initial      = [v_initial,v];    % record the initial profile    
end

%%
[t_driver,v_driver,d_driver,fuel_driver,time_driver]=Driver(v0,green,distance);
TrajectoryFigure(green,v0,v_opt,distance,t_driver,v_driver,d_driver);

figure;
bar([f_opt,fuel_driver],'FaceColor', [0.75 0.75 0.75]);
set(gca, 'xticklabel', {'1 intersection','2 intersections','5 intersections','10 intersections','Fast driving'},...
    'fontsize',8); 
xlabel('Algorithm','fontsize',8); %ylim([300,400])
ylabel('Fuel ($g$)','interpreter','latex','fontsize',8);
set(gca,'TickLabelInterpreter','latex','FontSize',8);
set(gcf,'Position',[250 150 400 350]);
print(gcf,'Fig2.eps','-painters','-depsc2','-r 600')

figure;
bar([t_opt time_driver],'FaceColor', [0.75 0.75 0.75]);
set(gca, 'xticklabel', {'1 intersection','2 intersections','5 intersections','10 intersections'},...
    'fontsize',8); 
xlabel('Algorithm','fontsize',8);%ylim([300,450])
ylabel('Trip time ($s$)','interpreter','latex','fontsize',8);
set(gca,'TickLabelInterpreter','latex','FontSize',8);
set(gcf,'Position',[250 150 400 350]);
print(gcf,'Fig3.eps','-painters','-depsc2','-r 600')
save RESULT green distance v0 v_opt t_opt f_opt f_seg fuel_driver time_driver t_driver v_driver d_driver