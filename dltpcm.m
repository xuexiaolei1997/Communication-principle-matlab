function [ codeout ] = dltpcm( x, delta )
%DLTPCM 增量编码调制函数
%   
xlen = length(x);
Dk = 0;  % 预测器初始状态
codeout = zeros(1, xlen);
for k=1:xlen
    err = x(k)-Dk;  % 误差信号
    if(err>0)
        qout = delta;  % 量化器输出
        codeout(k) = 1;  % 编码输出
    else
        qout = -delta;
        codeout(k) = 0;
    end
    Dk = Dk+qout;  % 延迟期状态更新
end

end

