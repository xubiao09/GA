clear;close all; clc;


fileName = 'Case4_1.mat';
N = 4;
[green, distance] = GenerateCases(fileName,N);

v0   = 10;
flag = 3;           % fuel consumption + trip time
N    = length(distance);

%% %1个路口1组进行优化
t0       = 0;
tempv0   = v0;
v_1      = [];
Fuel_1   = 0;
f_seg1   = [];
InitialV = [];
for i = 1:N/1
    [tempv,tempt,~,tempc_opt,tmpf_seg1] = GA(tempv0,{green{i}-t0},distance(i),InitialV,flag);
    TempFuel = tempc_opt(end);
    v_1      = [v_1;tempv(:)];
    t0       = t0+tempt;
    Fuel_1   = Fuel_1+TempFuel;
    f_seg1   = [f_seg1;tmpf_seg1];
    tempv0   = v_1(end);
end
triptime_1=t0;
%%
%2个路口1组进行优化
t0=0;
tempv0=v0;
v_2=[];
Fuel_2=0;
f_seg2 = [];
tempgreen=[];
tempv00=[];
for i=1:N/2
    for j=1:2
        tempgreen{j}=green{2*i-2+j}-t0;
        tempv00(j,1)=v_1(2*i-2+j);
    end
    [tempv,tempt,~,tempc_opt,tmpf_seg2] = GA(tempv0,tempgreen,distance(2*i-1:2*i),tempv00,flag);
    TempFuel = tempc_opt(end);
    v_2=[v_2;tempv(:)];
    t0=t0+tempt;
    Fuel_2=Fuel_2+TempFuel;
    f_seg2   = [f_seg2;tmpf_seg2];
    tempv0=v_2(end);
end
triptime_2=t0;

%%
% 4个路口1组进行优化
t0=0;
tempv0=v0;
v_5=[];
Fuel_5=0;
f_seg5 = [];
tempgreen=[];
tempv00=[];
for i=1:N/4
    for j=1:4
        tempgreen{j}=green{4*i-4+j}-t0;
        tempv00(j,1)=v_1(2*i-2+j);
        tempv00(j,2)=v_2(2*i-2+j);
    end
    [tempv,tempt,~,tempc_opt,tmpf_seg5] = GA(tempv0,tempgreen,distance(4*i-3:4*i),tempv00,flag);
    TempFuel = tempc_opt(end);
    v_5      = [v_5;tempv(:)];
    t0       = t0+tempt;
    Fuel_5   = Fuel_5+TempFuel;
    f_seg5   = [f_seg5;tmpf_seg5];
    tempv0   = v_5(end);
end
triptime_5 = t0;


v = [v_1,v_2,v_5];
Fuel     = [Fuel_1,Fuel_2,Fuel_5];
f_seg    = [f_seg1,f_seg2,f_seg5];
triptime = [triptime_1,triptime_2,triptime_5];

save(fileName,'green','v0','v','distance', 'Fuel','triptime','f_seg');

%% figure plot
[h11,h12,tlim1]=PlotTrajct(green,v0,v_1,distance);
[h21,h22,tlim2]=PlotTrajct(green,v0,v_2,distance);
[h31,h32,tlim3]=PlotTrajct(green,v0,v_5,distance);
figure(1);
legend([h11,h21,h31],'One by one','Two by two','Five by five');
xlim([0,max([tlim1,tlim2,tlim3])*1.1]);

figure(2);
legend([h12,h22,h32],'One by one','Two by two','Five by five');
xlim([0,max([tlim1,tlim2,tlim3])*1.1]);
ylim([0,24]);

figure(3);
xt=[1,2,3,4];
bar(Fuel);
set(gca, 'xticklabel', {'One by one','Two by two','Five by five'}); 
xlabel('Algorithm');
ylabel('Fuel[g]');ylim([round(0.9*min(Fuel)),round(1.1*max(Fuel))]);

figure(4);
bar(triptime);
set(gca, 'xticklabel', {'One by one','Two by two','Five by five'}); 
xlabel('Algorithm');
ylabel('Trip time[s]');
ylabel('Fuel[g]');ylim([round(0.9*min(triptime)),round(1.1*max(triptime))]);