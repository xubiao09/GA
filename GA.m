function [v,v_opt,c_opt] = GA(v_intial,green,distance)
%%
%遗传算法求最优速度序列v(m/s)，green{i}为绿灯区间(2*n)，第一行为绿灯开始时间(s)，第二行为绿灯结束时间(s)，distance为车辆距离多个交叉路口的距离(m)

%% Parameters of Genetic Algorithm
NumGen    = 200;      % Number of individuals in a generation
alpha     = 0.33;     % crossover opertor
PMutation = 0.1;     % Mutation probability
MaxIter   = 1000;     % Maximum number of iteration
verbose   = 1;        % output or not
dispIter  = 20;

%% Initialization
vmax      = 60/3.6;
vmin      = 20/3.6;
NumIntsct = length(distance);
v_opt     = zeros(NumIntsct,MaxIter);           % Optimal velocity profiles
c_opt     = zeros(MaxIter,1);                   % Optimal fuel consumption
t_opt     = zeros(MaxIter,1);                   % Optimla time

v0        = IntialGen(vmax,vmin,NumIntsct,NumGen,distance,green); % Initialization
Cost      = CostFunction(v_intial,v0,green,distance);             % cost for initialization
[TempCost,Ind] = sort(Cost);                                      % Sort in a increasing order
c_opt(1)  = TempCost(1);
tempv     = v0(:,Ind);
v_opt(:,1)= tempv(:,1);
t_opt(1)  = sum(distance(:)./tempv(:,1));

%% Main function
Iter      = 1;                                                    %循环数目
fprintf('\n Iteration     Fuel     Time      Fitness\n')
fprintf('%9d %9.3f %9.3f %9.3f\n', Iter, -2000*log(1-c_opt(1))./sum(distance)*1000/10, t_opt(1), c_opt(1))

while(true)
    %% Selection + Crossover + Mutation
    Cost = CostFunction(v_intial,v0,green,distance);                    % Fitness evaluation
    [Cost_sort,Index] = sort(Cost);                                     % Individual with minimal cost
    v_opt(:,Iter+1)   = v0(:,Index(1));                                 % GA中每代种群中最优个体
    c_opt(Iter+1)     = Cost_sort(1);                                   % GA中每代种群中最优个体的损失函数
    t_opt(:,1)        = sum(distance(:)./v_opt(:,Iter+1));
    
    vn                = zeros(NumIntsct,NumGen);
    vn(:,1:3)         = [v0(:,Index(1)),v0(:,Index(2)),v0(:,Index(3))]; % v1 is population after cross
    Selection_Num     = 3;    
    while(Selection_Num <= NumGen)
       %% Selection
        tempv1 = Selection(v0,Cost);       %% Select an individual to cross
        tempv2 = Selection(v0,Cost);       %% Select another individual to cross
        while(tempv1 == tempv2)
            tempv2 = Selection(v0,Cost);   %% Select another individual to cross
        end
       %% cross over
        [tempv3,tempv4]  = CrossGen(tempv1,tempv2,alpha);
        vn(:,Selection_Num+1:Selection_Num+2) = [tempv3, tempv4];
        Selection_Num    = Selection_Num + 2;
    end
    v0  = MutationGen_new(vn,PMutation,vmax,vmin);         %% Mutation
    %% Stopping Conidtion：1. 迭代代数超过一定值N；（或）2. 迭代次数超过100且最优值近似不变且约束条件全部满足
    if(Iter > MaxIter - 1)
        v = v_opt(:,end);
        break;
    elseif(Iter > inf)
        if(abs(c_opt(end)-c_opt(end-10))<1e-5)&&(abs(c_opt(end-1)-c_opt(end-9))<1e-5)&&(abs(c_opt(end-2)-c_opt(end-8))<1e-5)&&(c_opt(end)<1)
            v = v_opt(:,end);
            break;
        end
    end
    
    %% output
    Iter = Iter + 1;  
    Fuel = -2000*log(1-c_opt(Iter))./sum(distance)*1000/10;       %% fuel consumption per 100 km 
    if verbose == 1 && (mod(Iter,dispIter) == 0 || Iter == 1)
        fprintf('%9d %9.3f %9.3f %9.3f \n', Iter, Fuel, t_opt(Iter), c_opt(Iter))
    end
end