function [v1,v_opt,c_opt]=Selection(v0,Cost,N)
%%
%���ݸ��ʽ���ѡ��,�ȸ���Cost��������1~ri~NumGen��Ȼ���ո���ri/NumGen(NumGen+1)����ѡ��õ�ѡ�������v1�����ŵ�����Ϊv_opt�����ŵ�ֵΪc_opt,NΪѡ�����Ⱥ��Ŀ
%%
[Cost,Index]=sort(Cost);  %��������
c_opt=Cost(1);
tempv=v0(:,Index);
v_opt=tempv(:,1);
NumGen=length(v0(1,:));
tempn=1:NumGen;
Pn=2*tempn/NumGen/(NumGen+1);  %�����д�1~NumGen�ĸ���
P=cumsum(Pn);                %�����ۻ����
v1=[];
%��һ�����������ŵ�4������
v1=[v1,tempv(:,1:4)];
%��һ����ͨ�����̶ķ������ݸ������ѡ������
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
