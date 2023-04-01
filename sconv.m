function [ f, k ] = sconv( f1, f2, k1, k2, p )
%SCONV 实现连续信号卷积运算的通用函数
%   此处显示详细说明
%f: 卷积积分f(t)对应的非零值向量
%k: f(t)的对应时间向量
%p: 取样时间间隔
f = conv(f1, f2);
f = f*p;
k0 = k1(1) + k2(1);
k3 = length(f1) + length(f2) - 2;
k = k0:p:k3*p;

figure
subplot(221);
plot(k1, f1); title('f1(t)'); xlabel('t'); ylabel('f1(t)');
subplot(222);
plot(k2, f2); title('f2(t)'); xlabel('t'); ylabel('f2(t)');
subplot(223);
plot(k, f); title('f1(t)*f2(t)'); xlabel('t'); ylabel('f(t)');
h = get(gca, 'position');
h(3) = 2.5*h(3);
set(gca, 'position', h);

end

