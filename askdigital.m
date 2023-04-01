function [m1, ask] = askdigital( s, f )
%ASKDIGITAL 将输入的一段二进制代码调制成相应的ASK信号输出
%   此处显示详细说明
t = 0 : 2 * pi / 99 : 2 * pi;
m1 = [];
c1 = [];
for n = 1 : length(s)
    if s(n) == 0
        m = zeros(1, 100);
    else
        m = ones(1, 100);
    end
    c = sin(f * t);
    m1 = [m1 m];
    c1 = [c1 c];
end
ask = c1 .* m1;

end

