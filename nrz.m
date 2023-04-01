function y = nrz( x, tp )
%SNRZ 将输入的一段二进制代码编为相应的码输出
% INPUT:
%   x:二进制码
%   tp: s -> 单极性不归零码 , d -> 双极性不归零码
% OUTPUT:
%   y: 编好的码
t0 = 200;
t = 0:1/t0:length(x);
for i=1:length(x)
    if x(i)==1
        for j=1:t0
            y((i-1)*t0+j)=1;
        end
    else
        for j=1:t0
            if tp=='s'
                y((i-1)*t0+j)=0;  % 单极性不归零码输出
            elseif tp == 'd'
                y((i-1)*t0+j)=-1;  % 双极性不归零码
            end
        end
    end
end
y = [y, x(i)];
figure
plot(t, y);
grid on;
axis([0,i,-1.1,1.1]);
end

