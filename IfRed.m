function Cost=IfRed(t,green)
%%
%���ݳ����Ƿ�������Ƽ�����ʧ����һ����Cost(1*NumGen)�������������costΪ1������Ϊ0��tΪ����ʱ�䣨s��(1*NumGen),greenΪ�̵���λ(2*n)
%%
NumGen = length(t);%��Ⱥ��С
n      = length(green(1,:)); %�̵���λ��������
Green  = green(1,:);
Red    = green(2,:);
Cost   = ones(1,NumGen);
%parfor i = 1:NumGen
for i = 1:NumGen
    TempIndex = any(t(i)>Green & t(i)<=Red);
    if(TempIndex == 1)
        Cost(1,i) = 0;
    end
end