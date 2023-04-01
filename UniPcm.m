function [ sqnr, x_qtz, code ] = UniPcm( x, n )
%UNIPCM 均匀量化函数与量化噪声计算
% sqnr 量化信噪比
% x_qtz 量化结果
% code 量化编码
xmax = max(abs(x));
x_qtz = x/xmax;
b_qtz = x_qtz;
delta = 2/n;
q = delta*[0:n-1]-(n-1)/2*delta;
for i=1:n
    index = find((q(i)-delta/2<=x_qtz)&(x_qtz<=q(i)+delta/2));
    x_qtz(index) = q(i)*ones(1, length(index));
    b_qtz(x_qtz==q(i))=(i-1)*ones(1, length(find(x_qtz==q(i))));
end
x_qtz = x_qtz*xmax;
nu = ceil(log2(n));
code = zeros(length(x), nu);
for i=1:length(x)
    for j=nu:-1:0
        if(fix(b_qtz(i)/(2^j))==1)
            code(i, nu-j)=1;
            b_qtz(i)=b_qtz(i)-2^j;
        end
    end
end
sqnr = 20*log10(norm(x)./norm(x-x_qtz));  % 量化信噪比
end

