function code = APCM( x, n )
%APCM A律编码
%   此处显示详细说明
xmax = max(abs(x));
x = x/xmax;
xlen = length(x);
y = zeros(1, xlen);
A = 87.6;
A1 = 1+log(A);
for i=1:xlen
    if x(i)>=0
        if x(i)<=1/A
            y(i)=(A*x(i))/A1;
        else
            y(i)=(1+log(A*x(i)))/A1;
        end
    else
        x1 = -x(i);
        if x1<=1/A
            y(i)=-(A*x1)/A1;
        else
            y(i)=-(1+log(A*x1))/A1;
        end
    end
end
y1 = y*(2^(n-1)-1);
y1 = round(y1);
code = zeros(length(y1), n);
c2 = zeros(1, n-1);
for i=1:length(y1)
    if(y1(i)>0)
        c1 = 1;
    else
        c1 = 0;
        y1(i) = -y1(i);
    end
    for j=1:n-1
        r = rem(y1(i), 2);
        y1(i) = (y1(i)-r)/2;
        c2(j) = r;
    end
    c2 = fliplr(c2);
    code(i,:)=[c1,c2];
end
end

