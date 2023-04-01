function [ x, n ] = stepseq( n1, n2, n0 )
%产生序列 u(n-n0)，其中n1<=n<=n2，n1<=n0<=n2
%   此处显示详细说明
if nargin ~= 3
    disp('输入不正确，输入参数要有三个！');
    return;
elseif ((n0<n1) || (n0>n2) || (n1>n2))
    error('输入不正确，输入参数应满足n1<=k<=n2');
end
n = n1:n2;
x = ((n-n0)>=0);
end

