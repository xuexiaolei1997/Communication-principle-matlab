function [ out ] = INSERT0( d, M )
%INSERT0 信号恢复函数
% 将输入的序列扩展成间隔M-1个0的序列
%d: 采样信号
%M: 
N = length(d);
out = zeros(1, M*N);
for i=0:N-1
    out(i*M+1) = d(i+1);
end

end

