function y = nrz( x, tp )
%SNRZ �������һ�ζ����ƴ����Ϊ��Ӧ�������
% INPUT:
%   x:��������
%   tp: s -> �����Բ������� , d -> ˫���Բ�������
% OUTPUT:
%   y: ��õ���
t0 = 200;
t = 0:1/t0:length(x);
for i=1:length(x)
    if x(i)==1
        for j=1:t0
            y((i-1)*t0+j)=1;
        end
    else
        for j=1:t0
            if tp=='s'
                y((i-1)*t0+j)=0;  % �����Բ����������
            elseif tp == 'd'
                y((i-1)*t0+j)=-1;  % ˫���Բ�������
            end
        end
    end
end
y = [y, x(i)];
figure
plot(t, y);
grid on;
axis([0,i,-1.1,1.1]);
end

