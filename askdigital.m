function [m1, ask] = askdigital( s, f )
%ASKDIGITAL �������һ�ζ����ƴ�����Ƴ���Ӧ��ASK�ź����
%   �˴���ʾ��ϸ˵��
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

