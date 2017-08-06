function [v1,v_opt,c_opt]=Selection_new(v0,Cost,NumGen)
%%
%根据概率进行选择,先根据Cost进行排序1~ri~NumGen，然后按照概率ri/NumGen(NumGen+1)进行选择得到选择的样本v1，最优的样本为v_opt，最优的值为c_opt
%%
[Cost,Index]=sort(Cost);  %升序排序
c_opt=Cost(1);
tempv=v0(:,Index);
v_opt=tempv(:,1);
v1=tempv(:,1:NumGen);
