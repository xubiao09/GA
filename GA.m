function [v,v_opt,c_opt] = GA(v_intial,green,distance,flag)
%%
%遗传算法求最优速度序列v(m/s)，green{i}为绿灯区间(2*n)，第一行为绿灯开始时间(s)，第二行为绿灯结束时间(s)，distance为车辆距离多个交叉路口的距离(m)

if nargin <= 4
    flag = 1;   % calculate fuel consumption by default
end

%% Parameters of Genetic Algorithm
NumGen    = 1000;      % Number of individuals in a generation
alpha     = 0.33;     % crossover opertor
PMutation = 0.2;      % Mutation probability
Pcross    = 0.95;     % Crossover probability

MaxIter   = 1000;     % Maximum number of iteration
verbose   = 1;        % output or not
dispIter  = 20;

BestKeep  = round(NumGen*0.05);

%% Initialization
vmax      = 60/3.6;%60/3.6;
vmin      = 20/3.6;
NumIntsct = length(distance);
v_opt     = zeros(NumIntsct,MaxIter);           % Optimal velocity profiles
c_opt     = zeros(MaxIter,1);                   % Optimal fuel consumption
t_opt     = zeros(MaxIter,1);                   % Optimla time
NumFesi   = zeros(MaxIter,1);                   % Number of feasible solutions

v0        = IntialGen(vmax,vmin,NumIntsct,NumGen,distance,green); % Initialization

%% Main function
Iter      = 1;                                                    %循环数目
fprintf('\n Iteration     Fuel     Time      Fitness      No. \n')

%flag = 2; % time consumption as the cost funtion

while(true)
    %% Selection + Crossover + Mutation
    [Cost,ArvTime,Time_seg] = CostFunction(v_intial,v0,green,distance,flag);                    % Fitness evaluation
    [Cost_sort,Index] = sort(Cost);                                     % Individual with minimal cost
    v_opt(:,Iter)   = v0(:,Index(1));                                   % GA中每代种群中最优个体
    c_opt(Iter)     = Cost_sort(1);                                     % GA中每代种群中最优个体的损失函数
    t_opt(Iter)     = ArvTime(Index(1));
    NumFesi(Iter)   = length(find(Cost<1));
    
    vn                = zeros(NumIntsct,NumGen);
    for i = 1:BestKeep
        vn(:,i) = v0(:,Index(i)); %% keep the best individual from the last generation
    end
    Selection_Num     = BestKeep;    
    while(Selection_Num <= NumGen)
       %% Selection
        [tempv1,Time_seg1] = Selection(v0,Time_seg,Cost);       %% Select an individual to cross
        [tempv2,Time_seg2] = Selection(v0,Time_seg,Cost);       %% Select another individual to cross
        while(tempv1 == tempv2)
            [tempv2,Time_seg2] = Selection(v0,Time_seg,Cost);   %% Select another individual to cross
        end
       %% cross over
       if rand() < Pcross
            [tempv1,tempv2]  = CrossGen(tempv1,tempv2,Time_seg1,Time_seg2,alpha,vmax,vmin,green,distance,v_intial);
       end
       vn(:,Selection_Num+1:Selection_Num+2) = [tempv1, tempv2];
       Selection_Num    = Selection_Num + 2;
    end
    v0  = MutationGen_new(vn,PMutation,vmax,vmin);         %% Mutation
    %% Stopping Conidtion：1. 迭代代数超过一定值N；（或）2. 迭代次数超过100且最优值近似不变且约束条件全部满足
    if(Iter > MaxIter)
        v = v_opt(:,end);
        break;
    elseif(Iter > inf)
        if(abs(c_opt(end)-c_opt(end-10))<1e-5)&&(abs(c_opt(end-1)-c_opt(end-9))<1e-5)&&(abs(c_opt(end-2)-c_opt(end-8))<1e-5)&&(c_opt(end)<1)
            v = v_opt(:,end);
            break;
        end
    end
    
    %% output
    Fuel = -2000*log(1-c_opt(Iter))./sum(distance)*100;       %% fuel consumption per 100 km 
    if verbose == 1 && (mod(Iter,dispIter) == 0 || Iter == 1)
        fprintf('%9d %9.3f %9.3f %9.3f % 9d\n', Iter, Fuel, t_opt(Iter), c_opt(Iter),NumFesi(Iter) )
    end
    Iter = Iter + 1;  
end