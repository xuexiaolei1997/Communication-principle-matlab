function y = miller( x )
%MILER 将输入的一段二进制代码编为相应的Miller码输出
%   此处显示详细说明
t0 =200;
t = 0:1/t0:length(x);
i=1;
if x(i)==1
    for j=1:t0/2
        y((2*i-2)*t0/2+j)=0;
        y((2*i-1)*t0/2+j)=1;
    end
else
    for j=1:t0
        y((i-1)*t0+j)=1;
    end
end
for i=2:length(x)
    if x(i)==1
        for j=1:t0/2
            y((2*i-2)*t0/2+j)=y((2*i-3)*t0/2+t0/4);
            y((2*i-1)*t0/2+j)=1-y((2*i-2)*t0/2+j);
        end
    else
        if(x(i-1)==1)
            for j=1:t0
                y((i-1)*t0+j)=y((2*i-3)*t0/2+t0/4);
            end
        else
            for j=1:t0
                y((i-1)*t0+j)=1-y((2*i-3)*t0/2+t0/4);
            end
        end
    end
end
y = [y, y(i*t0)];
figure
plot(t, y);
grid on;
axis([0, i, -1.1, 1.1]);
end

