function [ codeout ] = dltpcm( x, delta )
%DLTPCM ����������ƺ���
%   
xlen = length(x);
Dk = 0;  % Ԥ������ʼ״̬
codeout = zeros(1, xlen);
for k=1:xlen
    err = x(k)-Dk;  % ����ź�
    if(err>0)
        qout = delta;  % ���������
        codeout(k) = 1;  % �������
    else
        qout = -delta;
        codeout(k) = 0;
    end
    Dk = Dk+qout;  % �ӳ���״̬����
end

end

