function [v,v_opt,c_opt] = GA(v_intial,green,distance)
%%
%�Ŵ��㷨�������ٶ�����v(m/s)��green{i}Ϊ�̵�����(2*n)����һ��Ϊ�̵ƿ�ʼʱ��(s)���ڶ���Ϊ�̵ƽ���ʱ��(s)��distanceΪ��������������·�ڵľ���(m)

%% Parameters of Genetic Algorithm
NumGen    = 200;      % Number of individuals in a generation
alpha     = 0.33;     % crossover opertor
PMutation = 0.1;      % Mutation probability
Pcross    = 0.95;     % Crossover probability

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
NumFesi   = zeros(MaxIter,1);                   % Number of feasible solutions

v0        = IntialGen(vmax,vmin,NumIntsct,NumGen,distance,green); % Initialization

%% Main function
Iter      = 1;                                                    %ѭ����Ŀ
fprintf('\n Iteration     Fuel     Time      Fitness      No. \n')

while(true)
    %% Selection + Crossover + Mutation
    [Cost,ArvTime,Time_seg] = CostFunction(v_intial,v0,green,distance);                    % Fitness evaluation
    [Cost_sort,Index] = sort(Cost);                                     % Individual with minimal cost
    v_opt(:,Iter)   = v0(:,Index(1));                                   % GA��ÿ����Ⱥ�����Ÿ���
    c_opt(Iter)     = Cost_sort(1);                                     % GA��ÿ����Ⱥ�����Ÿ������ʧ����
    t_opt(Iter)     = ArvTime(Index(1));
    NumFesi(Iter)   = length(find(Cost<1));
    
    vn                = zeros(NumIntsct,NumGen);
    vn(:,1:3)         = [v0(:,Index(1)),v0(:,Index(2)),v0(:,Index(3))]; % v1 is population after cross
    Selection_Num     = 3;    
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
    %% Stopping Conidtion��1. ������������һ��ֵN������2. ������������100������ֵ���Ʋ�����Լ������ȫ������
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