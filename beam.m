%% 模拟参数
N = 256;                % 屏大小
lamda = 1.550e-6;       % 波长
delta = 0.001;          % 网格间距
deltaz = 100;           % 传输间距
%% 光学几何结构
L = 3000;               % 传输距离
hh = 0;                 % 接收高度
npl = L / deltaz + 1;   % 传输段数
nRe = 10;               % 几次
%% 需要推导的参数
k = 2 * pi / lamda;       % 波数
z = linspace(0, L, npl);  % 每段传输距离
%% 湍流参数
l0 = 0.001;              % 内尺度
L0 = 10;                 % 外尺度
cn2 = 1e-17;             % 湍流强度
%%  横截面的采样，相位屏的大小，横截面的频率采样间隔
x0 = (-N / 2 : N / 2 - 1) * delta;
y0 = (-N / 2 : N / 2 - 1) * delta;
% 坐标设置
[x, y] = meshgrid(x0, y0);
[theta, r] = cart2pol(x, y);  % 极坐标
%% 涡旋光束参数
m = 3;                              % 拓扑荷数
p = 10;                              % 波形指数
w0 = 0.05;                          % 束腰半径
k = 2 * pi / lamda;                 % 波数
F = inf;                            % 聚焦参数
w = 1 / (k * w0 ^ 2) + i / (F);
%% 光束
% 高斯光束
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

