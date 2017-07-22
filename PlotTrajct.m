function PlotTrajct(green,v,d)
%%
%画图，green为绿灯相位，v为各段车速，d为距离
%%
d=d(:);
v=v(:);
NumIntsct=length(v);  %交叉口数目
SumD=cumsum(d);
t=d./v;
SumT=cumsum(t);
hold on;
for i=1:NumIntsct
    G=green{i};
    for j=1:length(G(1,:))
        plot(G(:,j),[SumD(i);SumD(i)],'g','LineWidth',2);
    end
    if(i~=1)
        plot([SumT(i-1),SumT(i)],[SumD(i-1),SumD(i)],'y','LineWidth',2);
    else
        plot([0,SumT(i)],[0,SumD(i)],'y','LineWidth',2);
    end
end
xlabel('t[s]');
ylabel('d[m]');
xlim([0,max(SumT)+10]);