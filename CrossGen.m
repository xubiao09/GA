function v1 = CrossGen(v0,alpha)
%%
%���Խ������ӣ��õ��µ���Ⱥv1(NumIntsct*2NumGen)����ʼ��ȺΪv0(NumIntsct*NumGen)������ϵ��Ϊalpha,green{i}Ϊ�̵�,dΪ����
%%
NumIntsct = length(v0(:,1));  %�������Ŀ
NumGen    = length(v0(1,:));     %��Ⱥ��Ŀ
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
