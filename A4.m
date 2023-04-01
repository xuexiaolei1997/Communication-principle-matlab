clear;
clc;
close all;
%% ============ 信号时域分析 ============
figure
[x, n] = impseq(-5, 5, 0);  % 单位冲激
subplot(121),stem(n, x);
[x, n] = stepseq(0, 30, 5);  % 单位阶跃
subplot(122),plot(n, x);
%% ============ matlab 信号函数 ============
%% sawtooth 产生锯齿波或三角波信号
% 产生一个周期为0.2、幅度在-1到+1之间的周期性三角波信号。
td = 1/100000;
t = 0:td:1;
x1 = sawtooth(2*pi*5*t, 0);
x2 = sawtooth(2*pi*5*t, 1);
x3 = sawtooth(2*pi*5*t, 0.5);
figure
subplot(311);plot(t, x1),title('sawtooth');
subplot(312);plot(t, x2);
subplot(313);plot(t, x3);
%% tripuls 非周期性三角波脉冲信号
% 产生一个最大幅度为1，宽度为width，斜率为skew的三角脉冲信号
% 横坐标由t决定，width/2以t=0为中心展开，skew为偏移度
figure
title('tripuls')
t = -3:0.001:3; x1 = tripuls(t, 4, 0);
subplot(131),plot(t, x1),axis([-4 4 0 1]),grid;
t = -6:0.01:6; x2 = tripuls(t, 4, 0.5);
subplot(132),plot(t, x2),axis([-4 4 0 1]),grid
x3 = tripuls(t+2, 4, 0.5);
subplot(133),plot(t, x3),axis([-4 4 0 1]),grid
%% square 周期性方波信号
% 产生一个周期为1/40，占空比为25 50 75 %的周期性方波
figure
td = 1/100000;
t = 0:td:1;
x1 = square(2*pi*40*t, 25);
x2 = square(2*pi*40*t, 50);
x3 = square(2*pi*40*t, 75);
subplot(311);plot(t, x1);
title('占空比25%');axis([0 0.2 -1.5 1.5]);
subplot(312);plot(t, x2);
title('占空比50%');axis([0 0.2 -1.5 1.5]);
subplot(313);plot(t, x3);
title('占空比75%');axis([0 0.2 -1.5 1.5]);
%% rectpuls 非周期性矩形脉冲信号
% 产生一个幅度为1、宽度为T、以t=0为中心左右对称的矩形波信号
figure
t = -4: 0.0001:4;
T = 4;
x1 = 2*rectpuls(t, T);
subplot(121),plot(t, x1);
title('x(t)'),axis([-4 6 0 2.2]);
x2 = 2*rectpuls(t-T/2, T);
subplot(122),plot(t, x2);
title('x(t-T/2)'),axis([-4 6 0 2.2]);
%% sinc 抽样信号
% x/sin(x)
figure
t = -1:0.001:1;
y = sinc(2*pi*t);
plot(t, y);
xlabel('时间t'),ylabel('幅值(y)'),title('抽样信号');
%% ============ 信号运算 ============
%% 信号加法乘法减法
%% 信号的移位及周期延拓
N = 24; M = 8; m = 3;
n = 0:N-1;
x1 = 0.8.^n;
x2 = (n>=0) & (n<=M);
x = x1.*x2;
xm = zeros(1, N);
for k = m+1:m+M
    xm(k) = x(k-m);
end
xc = x(mod(n, M) + 1);
xcm = x(mod(n-m, M) + 1);
figure
subplot(411),stem(n, x), ylabel('x(n)');
subplot(412),stem(n, xm), ylabel('x(n-1)');
subplot(413),stem(n, xc), ylabel('x(n)_8');
subplot(414),stem(n, xcm), ylabel('x(n-3)_8');
%% 信号翻褶
%% 信号的卷积
% 离散卷积
Nx = 20; Nh = 10;  % 序列x和h的长度
n = 0:Nx-1;
x = 0.9.^n;  % 产生序列x
nh = 0:Nh-1;
h = (nh==3); % 产生序列h
ny = -Nx+1:Nh-1;
y = conv(x, h);
figure
subplot(311), stem(n, x), xlabel('n'), ylabel('x(n)');
subplot(312), stem(nh, h), xlabel('n'), ylabel('h(n)');
subplot(313), stem(ny, y), xlabel('n'), ylabel('y(n)');
% 连续信号卷积
p = 0.01;
k1 = 0:p:2;
f1 = exp(-k1);
k2 = 0:p:3;
f2 = ones(1, length(k2));
[f, k] = sconv(f1, f2, k1, k2, p);
%% 信号相关运算
% xcorr(x1, x2) 相关序列
% cunsum 信号累加
% sum(abs(x).^2) 信号能量
% sum(abs(x).^2)/N 信号功率
%% ============ 线性系统LTI时域分析 ============
% 线性Linearity  时不变性Time-invariance
%% 系统模型转换函数：tf2ss ...
% 线性时（移）不变系统的时域相应

% 1、连续系统的时域相应
% impulse step initial lsim
b = 1; a = [1 0 1];           % 系统的传递函数参数
[A, B, C, D] = tf2ss(b, a);     % 系统模型转换
sys = ss(A, B, C, D);           % 系统的状态空间
t = 0:0.1:30;                   % 相应的时间区间
f = cos(t);                     % 系统的输入
zi = [-1, 0];                   % 系统的初始状态
y1 = step(sys, t);              % 系统的单位阶跃响应
y2 = initial(sys, zi, t);       % 系统的零输入响应
y3 = lsim(sys, f, t);           % 系统的零状态响应
y4 = lsim(sys, f, t, zi);       % 系统的全响应
figure
subplot(141), plot(t, y1);
xlabel('时间t'), title('系统的单位阶跃响应'); line([0, 30], [0, 0]);
subplot(142), plot(t, y2);
xlabel('时间t'), title('系统的零输入响应'); line([0, 30], [0, 0]);
subplot(143), plot(t, y3);
xlabel('时间t'), title('系统的零状态响应'); line([0, 30], [0, 0]);
subplot(144), plot(t, y4);
xlabel('时间t'), title('系统的全响应'); line([0, 30], [0, 0]);
% 2、离散时间系统的时域响应
% impz stepz dinitial dlsim
B = 1; A = [1, -0.8];
N = 0:31; x = 0.8.^n;
y = filter(B, A, x);
figure
subplot(2, 1, 1), stem(x)
subplot(2, 1, 2), stem(y)
%% 信号与系统的频域分析
% 傅里叶 fourier ifourier
% 非周期连续信号的频域分析-傅里叶变换
% syms t w f
% f = exp(-2*t);
% F = fourier(f);
% subplot(311), ezplot(f, [0:2, 0:1.2]);
% subplot(312), ezplot(abs(F), [-10, 10]);
% subplot(313), ezplot(angle(F), [-10, 10]);
% 逆傅里叶
% syms t w
% F = 1/(1+w^2);
% f = ifourier(F, w, t);
% ezplot(f);
% 周期连续信号的频域分析-傅里叶级数
% 序列傅里叶变换
% 离散傅里叶级数
% 离散傅里叶变换
% 快速傅里叶变换

% 连续时间系统的S域分析
% laplace
% 系统稳定性分析
a = [1, 2, -3, 2, 1];
b = [1, 0, -4];
p = roots(a);
q = roots(b);
figure
hold on
plot(real(p), imag(p), 'x');
plot(real(q), imag(q), 'o');
title('H(s)的零极点图');
grid on;
ylabel('虚部');xlabel('实部');
% 系统频率特性分析
a = [1, 2, 3, 2, 1];
b = [1, 0, -4];
p = roots(a);
pxm = max(real(p));
if pxm >=0
    disp('系统不稳定');
else
    figure
    freqs(b, a);
end

% 离散时间系统的Z域分析  ztrans iztrans
b = [0 1 0.6];
a = [1 -1.2 0.4];
[fn, n] = impz(b, a, 40);
figure
stem(n, fn, 'filled');

% 零极点图的绘制 [z, p, C] = tf2zp(b, a);
figure
a = [1 3 2];
b = [1 -0.7 0.1];
zplane(b,a);
% 离散系统的频率响应分析
%% 案例分析
R = 0.005; t = -2:R:2;
f = (t+1>=0)-((t-1)>=0);
f1 = f.*cos(10*pi*t);
figure
subplot(221), plot(t, f), xlabel('t'), ylabel('f(t)');
subplot(222), plot(t, f1), xlabel('t'), ylabel('f_1(t)=f(t)*cos(10*pi*t)');
W1 = 40;
N = 1000;
k = -N:N;
W = k*W1/N;
F = f*exp(-1i*t'*W)*R;
F = real(F);
F1 = f1*exp(-1i*t'*W)*R;
F1 = real(F1);
subplot(223), plot(W, F), xlabel('w'), ylabel('F(jw)');
subplot(224), plot(W, F1), xlabel('w'), ylabel('F_1(jw)');