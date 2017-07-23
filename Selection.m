function v1=Selection(v0,Cost)
%%
%根据概率进行选择,采用轮盘赌的方法进行选择
%%
[~,Index] = sort(Cost);  %升序排序
tempv        = v0(:,Index);
NumGen       = length(v0(1,:));
tempn        = 1:NumGen;
Pn           = 2*tempn/NumGen/(NumGen+1);  %排序中从1~NumGen的概率
P            = cumsum(Pn);                %概率累积求和
v1           = [];
%通过轮盘赌方法根据概率随机选择种子
p = rand();
c = find(P <= p);
if(~isempty(c))
    v1 = tempv(:,c(end)+1);
else
    v1 = tempv(:,1);
end

