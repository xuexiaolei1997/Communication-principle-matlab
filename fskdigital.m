function [m1, fsk] =  fskdigital( s, f1, f2 )
%FSKDIGITAL �������һ�ζ����ƴ�����Ƴ���Ӧ��fsk�ź����
%   �˴���ʾ��ϸ˵��
t = 0:2*pi/99:2*pi;
m1 = [];
c1 = [];
b1 = [];
for n=1:length(s)
    if s(n) == 0
        m = ones(1, 100);
        c = sin(f2*t);
        b = zeros(1,100);
    else
        m = ones(1, 100);
        c = sin(f1*t);
        b = ones(1, 100);
    end
    m1 = [m1 m];
    c1 = [c1 c];
    b1 = [b1 b];
end
fsk = c1.*m1;
end

