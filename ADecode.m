function y = ADecode( code, n )
%ADECODE A律解码
%   此处显示详细说明
codesize = size(code);
cr_len = codesize(1);
cl_len = codesize(2);
cl = zeros(1, cl_len-1);
for i=1:cr_len
    cl = code(i, 2:n);
    s = 0;
    for j=1:n-1
        s=s+cl(j)*2^(n-1-j);
    end
    a = code(i, 1);
    y(i) = s*((-1)^(a+1));
end
y = y/(2^(n-1));
A = 87.6;
A1 = 1+log(A);
for j=1:length(y)
    if(y(j)>=0)
        if(y(j)<=1/A1)
            y(j)=y(j)*A1/A;
        else
            y(j) = exp(y(j)*A1-1)/A;
        end
    else
        temp = -y(j);
        if(temp<=1/A1)
            y(j) = -temp*A1/A;
        else
            y(j) = -exp(temp*A1-1)/A;
        end
    end
end
            
end

