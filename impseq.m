function [ x, n ] = impseq( n1, n2, k )
% �����弤���� ��(n-k)������n1<=n<=n2��n1<=k<=n2
%   �˴���ʾ��ϸ˵��
if nargin ~= 3
    disp('���벻��ȷ���������Ҫ��������');
    return;
elseif ((k<n1) || (k>n2) || (n1>n2))
    error('���벻��ȷ���������Ӧ����n1<=k<=n2');
end
n = n1:n2;
x = ((n-k)==0);

end

