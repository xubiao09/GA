function v1 = CrossGen(v0,alpha)
%%
%线性交叉算子，得到新的种群v1(NumIntsct*2NumGen)，初始种群为v0(NumIntsct*NumGen)，交叉系数为alpha,green{i}为绿灯,d为距离
%%
NumIntsct = length(v0(:,1));  %交叉口数目
NumGen    = length(v0(1,:));     %种群数目
v         = v0(:,randperm(NumGen));
v1        = v;
for i = 1:NumGen/2
    %v1 = v(:,2*i-1);
    %v2 = v(:,2*i);
%    t1 = cumsum(d./v1);
%    t2 = cumsum(d./v2);
%     for j=1:length(t1)
%         
%     end
    
     v_new1 = alpha*v(:,2*i-1)+(1-alpha)*v(:,2*i);
     v_new2 = (1-alpha)*v(:,2*i-1)+alpha*v(:,2*i);
     v1     = [v1,v_new1,v_new2];
end
