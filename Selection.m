function [v1,v_opt,c_opt]=Selection(v0,Cost,N)
%%
%根据概率进行选择,先根据Cost进行排序1~ri~NumGen，然后按照概率ri/NumGen(NumGen+1)进行选择得到选择的样本v1，最优的样本为v_opt，最优的值为c_opt,N为选择后种群数目
%%
[Cost,Index]=sort(Cost);  %升序排序
c_opt=Cost(1);
tempv=v0(:,Index);
v_opt=tempv(:,1);
NumGen=length(v0(1,:));
tempn=1:NumGen;
Pn=2*tempn/NumGen/(NumGen+1);  %排序中从1~NumGen的概率
P=cumsum(Pn);                %概率累积求和
v1=[];
%第一步，保留最优的4个种子
v1=[v1,tempv(:,1:4)];
%第一步，通过轮盘赌方法根据概率随机选择种子
while(true)
    p=rand();
    c=find(P<=p);
    if(~isempty(c))
        TempS=tempv(:,c(end)+1);
    else
        TempS=tempv(:,1);
    end
    if(isempty(v1))
        flag=0;
    else
        flag=ismember(TempS',v1','rows');
    end
    if(flag==0)
        v1=[v1,TempS];
    end
    if(length(v1(1,:))==ceil(N))
        break;
    end
end
