%% ģ�����
N = 256;                % ����С
lamda = 1.550e-6;       % ����
delta = 0.001;          % ������
deltaz = 100;           % ������
%% ��ѧ���νṹ
L = 3000;               % �������
hh = 0;                 % ���ո߶�
npl = L / deltaz + 1;   % �������
nRe = 10;               % ����
%% ��Ҫ�Ƶ��Ĳ���
k = 2 * pi / lamda;       % ����
z = linspace(0, L, npl);  % ÿ�δ������
%% ��������
l0 = 0.001;              % �ڳ߶�
L0 = 10;                 % ��߶�
cn2 = 1e-17;             % ����ǿ��
%%  �����Ĳ�������λ���Ĵ�С��������Ƶ�ʲ������
x0 = (-N / 2 : N / 2 - 1) * delta;
y0 = (-N / 2 : N / 2 - 1) * delta;
% ��������
[x, y] = meshgrid(x0, y0);
[theta, r] = cart2pol(x, y);  % ������
%% ������������
m = 3;                              % ���˺���
p = 10;                              % ����ָ��
w0 = 0.05;                          % �����뾶
k = 2 * pi / lamda;                 % ����
F = inf;                            % �۽�����
w = 1 / (k * w0 ^ 2) + i / (F);
%% ����
% ��˹����
u0_G = exp(-r.^2 / w0 ^ 2);
% LG
A0 = sqrt(2 * factorial(p) / factorial(m + p) / pi) / w0;
u0_LG = A0 .* (sqrt(2) * r ./ w0) .^ m .* exp(-(r./w0).^2) .* exp(1i * m * theta);
% u0_LG = A0 .* (sqrt(2) * r ./ w0) .^ m .* exp(-(r./w0).^2) .* (cos(m*theta)+1i*sin(m*theta));
% BG
u0_BG = besselj(m, p * r) .* exp(-1 * k * r .^ 2 * w) .* exp(1i * m * theta);
figure
colormap hot;
subplot(231); imagesc(abs(u0_G) .^ 2);subplot(234);imagesc(angle(u0_G));
subplot(232); imagesc(abs(u0_LG) .^ 2);subplot(235); imagesc(angle(u0_LG));
subplot(233); imagesc(abs(u0_BG) .^ 2);subplot(236); imagesc(angle(u0_BG));

