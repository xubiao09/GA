clear;close all
clc;
load TrafficSignal.mat;
v0 = 10;
flag = 2;
[v,v_opt,c_opt] = GA(v0,green,distance,flag); % flag = 1: fuel£¬ flag = 2, time

% plot(c_opt);
figure(1);
Fuel=-2000*log(1-c_opt);
plot(Fuel);
xlabel('No. of Iteration');
ylabel('Fuel[g]');
grid on;
[h11,h12]=PlotTrajct(green,v0,v,distance);
[h21,h22]=PlotTrajct(green,v0,v_opt(:,1),distance);
figure(2);
legend([h11,h21],'Final','Initial');
figure(3);
legend([h12,h22],'Final','Initial');