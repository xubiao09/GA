clear;close all; clc;
load TrafficSignal.mat;
v0   = 10;
flag = 1;           % fuel consumption
N    = length(distance);
if(mod(N,10) ~= 0)
    fprintf('Error, No. of intersections must be a multiple of 20');
end
%%
%20个路口全局优化
% [v_20,t_20,v_opt_20,c_opt_20] = GA(v0,green,distance,flag); % flag = 1: fuel， flag = 2, time
% Fuel_20=-2000*log(1-c_opt_20(end));
%%
%1个路口1组进行优化
t0=0;
tempv0=v0;
v_1=[];
Fuel_1=0;
tempv00=[];
for i=1:N/1
    [tempv,tempt,~,tempc_opt] = GA(tempv0,{green{i}-t0},distance(i),tempv00,flag);
    TempFuel=-2000*log(1-tempc_opt(end));
    v_1=[v_1;tempv(:)];
    t0=t0+tempt;
    Fuel_1=Fuel_1+TempFuel;
    tempv0=v_1(end);
end
triptime_1=t0;
%%
%2个路口1组进行优化
t0=0;
tempv0=v0;
v_2=[];
Fuel_2=0;
tempgreen=[];
tempv00=[];
for i=1:N/2
    for j=1:2
        tempgreen{j}=green{2*i-2+j}-t0;
        tempv00(j,1)=v_1(2*i-2+j);
    end
    [tempv,tempt,~,tempc_opt] = GA(tempv0,tempgreen,distance(2*i-1:2*i),tempv00,flag);
    TempFuel=-2000*log(1-tempc_opt(end));
    v_2=[v_2;tempv(:)];
    t0=t0+tempt;
    Fuel_2=Fuel_2+TempFuel;
    tempv0=v_2(end);
end
triptime_2=t0;
%%
%5个路口1组进行优化
t0=0;
tempv0=v0;
v_5=[];
Fuel_5=0;
tempgreen=[];
tempv00=[];
for i=1:N/5
    for j=1:5
        tempgreen{j}=green{5*i-5+j}-t0;
        tempv00(j,1)=v_1(2*i-2+j);
        tempv00(j,2)=v_2(2*i-2+j);
    end
    [tempv,tempt,~,tempc_opt] = GA(tempv0,tempgreen,distance(5*i-4:5*i),tempv00,flag);
    TempFuel=-2000*log(1-tempc_opt(end));
    v_5=[v_5;tempv(:)];
    t0=t0+tempt;
    Fuel_5=Fuel_5+TempFuel;
    tempv0=v_5(end);
end
triptime_5=t0;
%%
%10个路口1组进行优化
t0=0;
tempv0=v0;
v_10=[];
Fuel_10=0;
tempgreen=[];
for i=1:N/10
    for j=1:10
        tempgreen{j}=green{10*i-10+j}-t0;
        tempv00(j,1)=v_1(2*i-2+j);
        tempv00(j,2)=v_2(2*i-2+j);
        tempv00(j,3)=v_5(2*i-2+j);
    end
    [tempv,tempt,~,tempc_opt] = GA(tempv0,tempgreen,distance(10*i-9:10*i),tempv00,flag);
    TempFuel=-2000*log(1-tempc_opt(end));
    v_10=[v_10;tempv(:)];
    t0=t0+tempt;
    Fuel_10=Fuel_10+TempFuel;
    tempv0=v_10(end);
end
triptime_10=t0;
% plot(c_opt);
% figure(1);
% Fuel=-2000*log(1-c_opt);
% plot(Fuel);
% xlabel('No. of Iteration');
% ylabel('Fuel[g]');
% grid on;
[h11,h12,tlim1]=PlotTrajct(green,v0,v_1,distance);
[h21,h22,tlim2]=PlotTrajct(green,v0,v_2,distance);
[h31,h32,tlim3]=PlotTrajct(green,v0,v_5,distance);
[h41,h42,tlim4]=PlotTrajct(green,v0,v_10,distance);
figure(1);
legend([h11,h21,h31,h41],'One by one','Two by two','Five by five','Ten by ten');
xlim([0,max([tlim1,tlim2,tlim3,tlim4])*1.1]);
figure(2);
legend([h12,h22,h32,h42],'One by one','Two by two','Five by five','Ten by ten');
xlim([0,max([tlim1,tlim2,tlim3,tlim4])*1.1]);
ylim([0,24]);
figure(3);
xt=[1,2,3,4];
Fuel0=[Fuel_1,Fuel_2,Fuel_5,Fuel_10];
triptime0=[triptime_1,triptime_2,triptime_5,triptime_10];
bar(Fuel0);
set(gca, 'xticklabel', {'One by one','Two by two','Five by five','Ten by ten'}); 
xlabel('Algorithm');
ylabel('Fuel[g]');
figure(4);
bar(triptime0);
set(gca, 'xticklabel', {'One by one','Two by two','Five by five','Ten by ten'}); 
xlabel('Algorithm');
ylabel('Trip time[s]');
save RESULT green v0 v_1 v_2 v_5 v_10 distance Fuel_1 Fuel_2 Fuel_5 Fuel_10...
    triptime_1 triptime_2 triptime_5 triptime_10;