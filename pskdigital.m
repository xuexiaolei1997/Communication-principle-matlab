function [m1, psk] =  pskdigital( s, f )
%PSKDIGITAL �������һ�ζ����ƴ�����Ƴ���Ӧ��psk�ź����
%   �˴���ʾ��ϸ˵��
t = 0:2*pi/99:2*pi;
m1 = [];
c1 = [];
b1 = [];
for n=1:length(s)
    if s(n) == 0
        m = -ones(1, 100);
        b = zeros(1,100);
    else
        m = ones(1, 100);
        b = ones(1, 100);
    end
    c = sin(f*t);
    m1 = [m1 m];
    c1 = [c1 c];
    b1 = [b1 b];
end
psk = c1.*m1;

end

