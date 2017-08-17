clear;close all; clc;
load TrafficSignal.mat;
v0   = 10;
flag = 1;           % fuel consumption
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
TrajectoryFigure(green,v0,v,d);

figure(3);
bar(f_opt);
set(gca, 'xticklabel', {'1 intersection','2 intersections','5 intersections','10 intersections'},...
    'interpreter','latex','fontsize',8); 
xlabel('Algorithm','interpreter','latex','fontsize',8);
ylabel('Fuel g','interpreter','latex','fontsize',8);
xlabel('Algorithm');
ylabel('Fuel[g]');
set(gca,'TickLabelInterpreter','latex','FontSize',8);

figure(4);
bar(t_opt);
set(gca, 'xticklabel', {'One by one','Two by two','Five by five','Ten by ten'}); 
xlabel('Algorithm');
ylabel('Trip time[s]');
save RESULT green v0 v_1 v_2 v_5 v_10 distance Fuel_1 Fuel_2 Fuel_5 Fuel_10...
    triptime_1 triptime_2 triptime_5 triptime_10;