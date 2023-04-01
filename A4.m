clear;
clc;
close all;
%% ============ �ź�ʱ����� ============
figure
[x, n] = impseq(-5, 5, 0);  % ��λ�弤
subplot(121),stem(n, x);
[x, n] = stepseq(0, 30, 5);  % ��λ��Ծ
subplot(122),plot(n, x);
%% ============ matlab �źź��� ============
%% sawtooth ������ݲ������ǲ��ź�
% ����һ������Ϊ0.2��������-1��+1֮������������ǲ��źš�
td = 1/100000;
t = 0:td:1;
x1 = sawtooth(2*pi*5*t, 0);
x2 = sawtooth(2*pi*5*t, 1);
x3 = sawtooth(2*pi*5*t, 0.5);
figure
subplot(311);plot(t, x1),title('sawtooth');
subplot(312);plot(t, x2);
subplot(313);plot(t, x3);
%% tripuls �����������ǲ������ź�
% ����һ��������Ϊ1�����Ϊwidth��б��Ϊskew�����������ź�
% ��������t������width/2��t=0Ϊ����չ����skewΪƫ�ƶ�
figure
title('tripuls')
t = -3:0.001:3; x1 = tripuls(t, 4, 0);
subplot(131),plot(t, x1),axis([-4 4 0 1]),grid;
t = -6:0.01:6; x2 = tripuls(t, 4, 0.5);
subplot(132),plot(t, x2),axis([-4 4 0 1]),grid
x3 = tripuls(t+2, 4, 0.5);
subplot(133),plot(t, x3),axis([-4 4 0 1]),grid
%% square �����Է����ź�
% ����һ������Ϊ1/40��ռ�ձ�Ϊ25 50 75 %�������Է���
figure
td = 1/100000;
t = 0:td:1;
x1 = square(2*pi*40*t, 25);
x2 = square(2*pi*40*t, 50);
x3 = square(2*pi*40*t, 75);
subplot(311);plot(t, x1);
title('ռ�ձ�25%');axis([0 0.2 -1.5 1.5]);
subplot(312);plot(t, x2);
title('ռ�ձ�50%');axis([0 0.2 -1.5 1.5]);
subplot(313);plot(t, x3);
title('ռ�ձ�75%');axis([0 0.2 -1.5 1.5]);
%% rectpuls �������Ծ��������ź�
% ����һ������Ϊ1�����ΪT����t=0Ϊ�������ҶԳƵľ��β��ź�
figure
t = -4: 0.0001:4;
T = 4;
x1 = 2*rectpuls(t, T);
subplot(121),plot(t, x1);
title('x(t)'),axis([-4 6 0 2.2]);
x2 = 2*rectpuls(t-T/2, T);
subplot(122),plot(t, x2);
title('x(t-T/2)'),axis([-4 6 0 2.2]);
%% sinc �����ź�
% x/sin(x)
figure
t = -1:0.001:1;
y = sinc(2*pi*t);
plot(t, y);
xlabel('ʱ��t'),ylabel('��ֵ(y)'),title('�����ź�');
%% ============ �ź����� ============
%% �źżӷ��˷�����
%% �źŵ���λ����������
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
%% �źŷ���
%% �źŵľ��
% ��ɢ���
Nx = 20; Nh = 10;  % ����x��h�ĳ���
n = 0:Nx-1;
x = 0.9.^n;  % ��������x
nh = 0:Nh-1;
h = (nh==3); % ��������h
ny = -Nx+1:Nh-1;
y = conv(x, h);
figure
subplot(311), stem(n, x), xlabel('n'), ylabel('x(n)');
subplot(312), stem(nh, h), xlabel('n'), ylabel('h(n)');
subplot(313), stem(ny, y), xlabel('n'), ylabel('y(n)');
% �����źž��
p = 0.01;
k1 = 0:p:2;
f1 = exp(-k1);
k2 = 0:p:3;
f2 = ones(1, length(k2));
[f, k] = sconv(f1, f2, k1, k2, p);
%% �ź��������
% xcorr(x1, x2) �������
% cunsum �ź��ۼ�
% sum(abs(x).^2) �ź�����
% sum(abs(x).^2)/N �źŹ���
%% ============ ����ϵͳLTIʱ����� ============
% ����Linearity  ʱ������Time-invariance
%% ϵͳģ��ת��������tf2ss ...
% ����ʱ���ƣ�����ϵͳ��ʱ����Ӧ

% 1������ϵͳ��ʱ����Ӧ
% impulse step initial lsim
b = 1; a = [1 0 1];           % ϵͳ�Ĵ��ݺ�������
[A, B, C, D] = tf2ss(b, a);     % ϵͳģ��ת��
sys = ss(A, B, C, D);           % ϵͳ��״̬�ռ�
t = 0:0.1:30;                   % ��Ӧ��ʱ������
f = cos(t);                     % ϵͳ������
zi = [-1, 0];                   % ϵͳ�ĳ�ʼ״̬
y1 = step(sys, t);              % ϵͳ�ĵ�λ��Ծ��Ӧ
y2 = initial(sys, zi, t);       % ϵͳ����������Ӧ
y3 = lsim(sys, f, t);           % ϵͳ����״̬��Ӧ
y4 = lsim(sys, f, t, zi);       % ϵͳ��ȫ��Ӧ
figure
subplot(141), plot(t, y1);
xlabel('ʱ��t'), title('ϵͳ�ĵ�λ��Ծ��Ӧ'); line([0, 30], [0, 0]);
subplot(142), plot(t, y2);
xlabel('ʱ��t'), title('ϵͳ����������Ӧ'); line([0, 30], [0, 0]);
subplot(143), plot(t, y3);
xlabel('ʱ��t'), title('ϵͳ����״̬��Ӧ'); line([0, 30], [0, 0]);
subplot(144), plot(t, y4);
xlabel('ʱ��t'), title('ϵͳ��ȫ��Ӧ'); line([0, 30], [0, 0]);
% 2����ɢʱ��ϵͳ��ʱ����Ӧ
% impz stepz dinitial dlsim
B = 1; A = [1, -0.8];
N = 0:31; x = 0.8.^n;
y = filter(B, A, x);
figure
subplot(2, 1, 1), stem(x)
subplot(2, 1, 2), stem(y)
%% �ź���ϵͳ��Ƶ�����
% ����Ҷ fourier ifourier
% �����������źŵ�Ƶ�����-����Ҷ�任
% syms t w f
% f = exp(-2*t);
% F = fourier(f);
% subplot(311), ezplot(f, [0:2, 0:1.2]);
% subplot(312), ezplot(abs(F), [-10, 10]);
% subplot(313), ezplot(angle(F), [-10, 10]);
% �渵��Ҷ
% syms t w
% F = 1/(1+w^2);
% f = ifourier(F, w, t);
% ezplot(f);
% ���������źŵ�Ƶ�����-����Ҷ����
% ���и���Ҷ�任
% ��ɢ����Ҷ����
% ��ɢ����Ҷ�任
% ���ٸ���Ҷ�任

% ����ʱ��ϵͳ��S�����
% laplace
% ϵͳ�ȶ��Է���
a = [1, 2, -3, 2, 1];
b = [1, 0, -4];
p = roots(a);
q = roots(b);
figure
hold on
plot(real(p), imag(p), 'x');
plot(real(q), imag(q), 'o');
title('H(s)���㼫��ͼ');
grid on;
ylabel('�鲿');xlabel('ʵ��');
% ϵͳƵ�����Է���
a = [1, 2, 3, 2, 1];
b = [1, 0, -4];
p = roots(a);
pxm = max(real(p));
if pxm >=0
    disp('ϵͳ���ȶ�');
else
    figure
    freqs(b, a);
end

% ��ɢʱ��ϵͳ��Z�����  ztrans iztrans
b = [0 1 0.6];
a = [1 -1.2 0.4];
[fn, n] = impz(b, a, 40);
figure
stem(n, fn, 'filled');

% �㼫��ͼ�Ļ��� [z, p, C] = tf2zp(b, a);
figure
a = [1 3 2];
b = [1 -0.7 0.1];
zplane(b,a);
% ��ɢϵͳ��Ƶ����Ӧ����
%% ��������
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