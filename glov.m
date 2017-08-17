function [v,t,f_opt,f_seg] = glov(N,v0,green,distance,v_initial,flag)
%  Consider N intersections at one time

NoI = length(green);
if(mod(NoI,N) ~= 0)
    fprintf('N must be divided by the total number of intersections');
end

v       = zeros(NoI,1);         % final optimal speed profile
f_seg   = zeros(NoI,1);         % fuel consumption for each segment
f_opt   = 0;                    % final optimal fuel consumption 
t       = 0;                    % final trip time

v0Seg  = v0;
greenSeg = cell(N,1);

for i = 1:NoI/N
    for j = 1:N
        greenSeg{j} = green{N*(i-1)+j} - t;  % green phase in this group of intersections
    end
    disSeg   = distance(N*(i-1)+1:N*i); 
    if ~isempty(v_initial)
        vIniSeg = v_initial(N*(i-1)+1:N*i,:);
    else
        vIniSeg = [];
    end
    
    [tempv,tempt,~,tempf_opt,tempf_seg] = GA(v0Seg,greenSeg,disSeg,vIniSeg,flag);
    v(N*(i-1)+1:N*i)     = tempv(:);
    t                    = t + tempt;
    f_opt                = f_opt + tempf_opt(end);
    f_seg(N*(i-1)+1:N*i) = tempf_seg;
    v0Seg                = tempv(end);
end

end

