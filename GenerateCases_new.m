%%
%生成工况
%%
function [green, distance] = GenerateCases(fileName,N)
DisMax = 800;
DisMin = 400;

CycleMax = 80;
CycleMin = 50;

%N = 10;  %灯的数目
Cycle0 = CycleMin: round((CycleMax - CycleMin)/(N)) : CycleMax;
Distance0 = DisMin:  round((DisMax - DisMin)/(N)) : DisMax;

Cycle0    = Cycle0(1:N);
Distance0 = Distance0(1:N);
for i=1:N
    Index_C=randi([1,length(Cycle0)]);
    Cycle=Cycle0(Index_C);
    randnum=0.2+0.4*rand();
    GreenTime=ceil(Cycle*randnum);
    if(GreenTime>50)
        GreenTime = 50;
    elseif(GreenTime<15)
        GreenTime = 15;
    end
    PhaseTime0=randi([0,Cycle]);
    green{i}    = [(0:1:40)*Cycle-PhaseTime0;(0:1:40)*Cycle-PhaseTime0+GreenTime];
    Index_D     = randi([1,length(Distance0)]);
    distance(i) = Distance0(Index_D);
    C(i)=Cycle;
    G(i)=GreenTime;
    P(i)=PhaseTime0;
end
    [~,Index]=max(C(floor(N/3):floor(N/3*2)));
    Index=Index+floor(N/3)-1;
    Cycle=C(Index);
    GreenTime=G(Index+1);
    PhaseTime0=P(Index)-distance(Index+1)/80*3.6+GreenTime;
    green{Index+1}= [(0:1:40)*Cycle-PhaseTime0;(0:1:40)*Cycle-PhaseTime0+GreenTime];
    save(fileName, 'green', 'distance');
end
