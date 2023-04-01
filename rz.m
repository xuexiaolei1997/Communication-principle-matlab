function y = rz( x, tp )
%SRZ 将输入的一段二进制代码编为相应的码输出
% INPUT:
%   x:二进制码
%   tp: s -> 单极性归零码, d -> 双极性归零码, m -> manchester双相码
% OUTPUT:
%   y: 编好的码
t0 =200;
t = 0:1/t0:length(x);
for i=1:length(x)
    if x(i)==1
        for j=1:t0/2
            y((2*i-2)*t0/2+j)=1;
            y((2*i-1)*t0/2+j)=0;
        end
    else
        if tp=='s'  % 单极性归零码
            for j=1:t0
                y((i-1)*t0+j)=0;
            end
        elseif tp=='d'  % 双极性归零码
            for j=1:t0/2
                y((2*i-2)*t0/2+j)=-1;
                y((2*i-1)*t0/2+j)=0;
            end
        elseif tp=='m'  % manchester双相码
            for j=1:t0/2
                y((2*i-2)*t0/2+j)=0;
                y((2*i-1)*t0/2+j)=1;
            end
        end  
    end
end
y = [y, x(i)];
figure
plot(t, y);
grid on;
axis([0 i -1.1 1.1])
end

