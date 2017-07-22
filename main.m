clear;close all
clc;
load TrafficSignal.mat;
[v,v_opt,c_opt]=GA(green,distance);
plot(c_opt);
Fuel=-2000*log(1-c_opt);
plot(Fuel);
xlabel('No. of Iteration');
ylabel('Cost');
grid on;
figure;
PlotTrajct(green,v,distance);
hold on;
PlotTrajct(green,v_opt(:,1),distance);