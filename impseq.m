function [ x, n ] = impseq( n1, n2, k )
% 产生冲激序列 δ(n-k)，其中n1<=n<=n2，n1<=k<=n2
%   此处显示详细说明
if nargin ~= 3
    disp('输入不正确，输入参数要有三个！');
    return;
elseif ((k<n1) || (k>n2) || (n1>n2))
    error('输入不正确，输入参数应满足n1<=k<=n2');
end
n = n1:n2;
x = ((n-k)==0);

end

