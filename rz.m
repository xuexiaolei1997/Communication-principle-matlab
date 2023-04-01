function y = rz( x, tp )
%SRZ �������һ�ζ����ƴ����Ϊ��Ӧ�������
% INPUT:
%   x:��������
%   tp: s -> �����Թ�����, d -> ˫���Թ�����, m -> manchester˫����
% OUTPUT:
%   y: ��õ���
t0 =200;
t = 0:1/t0:length(x);
for i=1:length(x)
    if x(i)==1
        for j=1:t0/2
            y((2*i-2)*t0/2+j)=1;
            y((2*i-1)*t0/2+j)=0;
        end
    else
        if tp=='s'  % �����Թ�����
            for j=1:t0
                y((i-1)*t0+j)=0;
            end
        elseif tp=='d'  % ˫���Թ�����
            for j=1:t0/2
                y((2*i-2)*t0/2+j)=-1;
                y((2*i-1)*t0/2+j)=0;
            end
        elseif tp=='m'  % manchester˫����
            for j=1:t0/2
                y((2*i-2)*t0/2+j)=0;
                y((2*i-1)*t0/2+j)=1;
            end
        end  
    end
end
y = [y, x(i)];
figure
plot(t, y);
grid on;
axis([0 i -1.1 1.1])
end

