function [v,v_opt,c_opt]=GA(v_intial,green,distance)
%%
%�Ŵ��㷨�������ٶ�����v(m/s)��green{i}Ϊ�̵�����(2*n)����һ��Ϊ�̵ƿ�ʼʱ��(s)���ڶ���Ϊ�̵ƽ���ʱ��(s)��distanceΪ��������������·�ڵľ���(m)

%% Parameters of Genetic Algorithm
NumGen    = 100;      % Number of individuals in a generation
alpha     = 0.33;    % crossover opertor
PMutation = 0.2;     % Mutation probability
MaxIter   = 2000;     % Maximum number of iteration
verbose   = 1;       % output or not
dispIter  = 20;

%% Initialization
vmax      = 60/3.6;
vmin      = 20/3.6;
NumIntsct = length(distance);
v0        = IntialGen(vmax,vmin,NumIntsct,NumGen,distance,green); %% Initialization
Cost      = CostFunction(v_intial,v0,green,distance);     %% cost for initialization
[Cos,Ind] = sort(Cost);  %��������
c_opt     = Cos(1);
tempv     = v0(:,Ind);
v_opt     = tempv(:,1);
Iter      = 1;  %ѭ����Ŀ

%% Main function
fprintf('\n Iteration    Fuel    Fitness\n')
fprintf('%9d %9.3f %9.3f \n', Iter, -2000*log(1-c_opt)./sum(distance)*1000/10, c_opt)

while(true)
    %% Selection + Crossover + Mutation
    Cost = CostFunction(v_intial,v0,green,distance);                 %% Fitness evaluation
    [Cost_sort,Index]=sort(Cost);                                      %% Individual with minimal cost
    v_opt = [v_opt,v0(:,Index(1))];                     %% GA��ÿ����Ⱥ�����Ÿ���
    c_opt = [c_opt,Cost_sort(1)];                              %%GA��ÿ����Ⱥ�����Ÿ������ʧ����
    v1=[v0(:,Index(1)),v0(:,Index(2)),v0(:,Index(3))];          %v1 is population after cross
    Selection_Num=length(v1(1,:));
    while(Selection_Num<=NumGen)
        %% Selection
        tempv1 = Selection(v0,Cost);       %% Select an individual to cross
        tempv2 = Selection(v0,Cost);       %% Select another individual to cross
        while(tempv1==tempv2)
            tempv2 = Selection(v0,Cost);       %% Select another individual to cross
        end
       %% cross over
        [tempv3,tempv4]   = CrossGen(tempv1,tempv2,alpha);
        Selection_Num=Selection_Num+2;
        v1=[v1, tempv3, tempv4];
    end
    v2   = MutationGen_new(v1,PMutation,vmax,vmin);         %% Mutation
    v0    = v2;
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
    Fuel = -2000*log(1-c_opt(end))./sum(distance)*1000/10;       %% fuel consumption per 100 km 
    if verbose == 1 && (mod(Iter,dispIter) == 0 || Iter == 1)
        fprintf('%9d %9.3f %9.3f \n', Iter, Fuel, c_opt(end))
    end
    Iter   = Iter + 1;    
end