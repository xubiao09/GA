function [v,t,v_opt,f_opt,f_seg] = GA(v_initial,green,distance,v00,flag)
%%
%遗传算法求最优速度序列v(m/s)，green{i}为绿灯区间(2*n)，第一行为绿灯开始时间(s)，第二行为绿灯结束时间(s)，
%distance为车辆距离多个交叉路口的距离(m),v00为直接放入的初始解，flag为目标函数选取的标志

% Input information:
%          v_initial: initial speed before crossing the intersections
%          green    : traffic signal information, cell format
%          distance : distance between two consecutve intersections
%          v00      : initial solutions
%          flag     : cost function: 2: trip time; 1: fuel consumption; 3: combination of the two choices

% Output information:
%          v :    final optimal velocity profile
%          t:     final optimal trip time
%          v_opt: optimal velocity profile at each iteration
%          f_opt: optimal fuel consumption at each iteration
%          f_seg: final optimal fuel consumption at each segment

if nargin <= 4
    flag = 1;         % calculate fuel consumption by default
end

%% Parameters of Genetic Algorithm
NumGen    = 500;      % Number of individuals in a generation  500
alpha     = 0.33;     % crossover opertor
PMutation = 0.1;      % Mutation probability
Pcross    = 0.95;     % Crossover probability

MaxIter   = 1000;     % Maximum number of iteration
verbose   = 1;        % output or not
dispIter  = 20;
BestKeep  = round(round(NumGen*0.05)/2)*2;

vmax      = 80/3.6;                             % maximal speed  m/s
vmin      = 20/3.6;                             % minimal speed  m/s
NumIntsct = length(distance);                   % Number of intersections
v_opt     = zeros(NumIntsct,MaxIter);           % Optimal velocity profiles
f_seg     = zeros(NumIntsct,1);                 % Fuel consumption at each segment
f_opt     = zeros(MaxIter,1);                   % Optimal fuel consumption
t_opt     = zeros(MaxIter,1);                   % Optimal time
NumFesi   = zeros(MaxIter,1);                   % Number of feasible solutions
c_opt     = zeros(MaxIter,1);                   % Number of feasible solutions

%% Initialization
v0        = IntialGen(vmax,vmin,v_initial,NumIntsct,NumGen,distance,green,v00); % Initialization

%% Main function
Iter      = 1;                                  % 循环数目
fprintf('\n Iter.  Fitness     Fuel_100      Time      Fuel     No. \n')

StopIter = 1;             % for stop information
Stop     = false;
while(true)
    %% Selection + Crossover + Mutation
    [Cost,ArvTime,Time_seg, Fuel,Fuel_seg] = CostFunction(v_initial,v0,green,distance,flag);    % Fitness evaluation
    [Cost_sort,Index] = sort(Cost);                                             % Individual with minimal cost
    v_opt(:,Iter)     = v0(:,Index(1));                                         % GA中每代种群中最优个体
    f_opt(Iter)       = Fuel(Index(1));                                         % GA中每代种群中最优个体的损失函数  
    c_opt(Iter)       = Cost_sort(1);
    t_opt(Iter)       = ArvTime(Index(1));
    NumFesi(Iter)     = length(find(Cost < 1));
    
    vn                = zeros(NumIntsct,NumGen);
    for i = 1:BestKeep
        vn(:,i) = v0(:,Index(i));    %% keep the best individual from the last generation
    end
    Selection_Num     = BestKeep;    
    while(Selection_Num < NumGen)
       %% Selection
        [tempv1,Time_seg1] = Selection(v0,Time_seg,Cost);       %% Select an individual to cross
        [tempv2,Time_seg2] = Selection(v0,Time_seg,Cost);       %% Select another individual to cross
        while(tempv1 == tempv2)
            [tempv2,Time_seg2] = Selection(v0,Time_seg,Cost);   %% Select another individual to cross
        end
       %% cross over
       if rand() < Pcross
            [tempv1,tempv2]  = CrossGen(tempv1,tempv2,Time_seg1,Time_seg2,alpha,vmax,vmin,green,distance,v_initial);
       end
       vn(:,Selection_Num+1:Selection_Num+2) = [tempv1, tempv2];
       Selection_Num = Selection_Num + 2;
    end
    v0  = MutationGen_new(vn,PMutation,vmax,vmin);         %% Mutation
    
    %% Stopping Conidtion：1. 迭代代数超过一定值N；（或）2. 迭代次数超过100且最优值近似不变且约束条件全部满足
    if(Iter > MaxIter)
        v = v_opt(:,Iter);
        t = t_opt(Iter);
        f_seg  = Fuel_seg(:,Index(1)); 
        Stop = true;
    elseif(Iter > 500)
        
        if f_opt(Iter) == f_opt(Iter-1)
            StopIter = StopIter + 1;
        else
            StopIter = 1;
            Stop = false;
        end
        
        if StopIter >=200
            Stop = true;
        end
    end
    
    %% output
    fuel = f_opt(Iter)./sum(distance)*100;       %% fuel consumption per 100 km 
    if verbose == 1 && (mod(Iter,dispIter) == 0 || Iter == 1 || Stop == true)
        fprintf('%5d %10.5f %9.3f %9.3f %9.3f % 9d\n', Iter,c_opt(Iter), fuel, t_opt(Iter), f_opt(Iter), NumFesi(Iter) )
    end
       
    if Stop == true
            v = v_opt(:,Iter);
            t = t_opt(Iter);
            f_seg  = Fuel_seg(:,Index(1)); 
            v_opt     = v_opt(NumIntsct,1:Iter);           % Optimal velocity profiles
            f_opt     = f_opt(1:Iter,1);                   % Optimal fuel consumption            
            break;
    end
    
    Iter = Iter + 1;  
end