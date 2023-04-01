function [ x, n ] = stepseq( n1, n2, n0 )
%�������� u(n-n0)������n1<=n<=n2��n1<=n0<=n2
%   �˴���ʾ��ϸ˵��
if nargin ~= 3
    disp('���벻��ȷ���������Ҫ��������');
    return;
elseif ((n0<n1) || (n0>n2) || (n1>n2))
    error('���벻��ȷ���������Ӧ����n1<=k<=n2');
end
n = n1:n2;
x = ((n-n0)>=0);
end

