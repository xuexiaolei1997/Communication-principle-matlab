clear; close all;
%% 抽样定理
% 低通抽样定理
dt = 0.01;
t = 0 : dt : 10;
xt = 0.1 * sin(2 * pi * t) + 0.5 * cos(4 * pi * t);
[f, xf] = FFT_SHIFT(t, xt);
% 抽样信号
fs = 4;
sdt = 1 / fs;
t1 = 0 : sdt : 10;
st = 0.1 * sin(2 * pi * t1) + 0.5 * cos(4 * pi * t1);
[f1, sf] = FFT_SHIFT(t1, st);
% 恢复原始信号
t2 = -50 : dt : 50;
gt = sinc(fs * t2);
stt = INSERT0(st, sdt / dt);
xt_t = conv(stt, gt);
figure
subplot(311); plot(t, xt); title('原始信号');
subplot(312); stem(t1, st); title('抽样信号');
subplot(313);
t3 = -50 : dt : 60 + sdt - dt;
plot(t3, xt_t); title('抽样信号恢复'); axis([0 10 -1 1]);

% 带通抽样  Fs = 2B
%%  量化
t = [0 : 0.1 : 2 * pi];
s = sin(t);
[sqnr16, xqtz16, code16] = UniPcm(s, 16);
plot(t, s, t, xqtz16, '*');
%% 案例
% PCM encode and decode
t = 0 : 0.01 : 1;
x = sin(2 * pi * t);
code = APCM(x, 7);
y = ADecode(code, 7);
figure
subplot(211), plot(t, x); title('原函数图形');
subplot(212), plot(t, y); title('解码后函数图形');
%% PCM 抗噪声性能
%% 差分脉冲编码调制 DPCM
predictor = [0 1]; % 量化器 y(k) = x(k-1)
partition = [-1 : .1 : .9]; % 量化区间
codebook = [-1 : .1 : 1]; % 编码表
t = [0 : pi / 50 : 2 * pi]; % 采样时间
x = sawtooth(3 * t); % 锯齿波
% 对x进行dpcm编码
encodex = dpcmenco(x, codebook, partition, predictor);
% 解调恢复
decodex = dpcmdeco(encodex, codebook, predictor);
plot(t, x, t, decodex, '--');
% 计算均方误差
distor = sum((x - decodex) .^ 2) / length(x);
%% 增量调制 DM
Ts = 1e-3; % 采样间隔
N = 50; % 采样点数
t = [0 : N] * Ts; % 时间序列
x = sin(100 * pi * t) + 0.4 * sin(200 * pi * t); % 信号
delta = 0.3; % 量化间距
code1 = dltpcm(x, delta); % 编码
xe = depcm(code1, delta); % 解码
subplot(311); plot(t, x, '-o'); axis([0 N * Ts -2 2]); hold on;
subplot(312); stairs(t, code1); axis([0 N * Ts -2 2]);
subplot(313); stairs(t, xe); hold on; plot(t, x);
%% 案例
Ts = 1e-3;
N = 50;
t = [0 : N] * Ts;
x = sin(100 * pi * t) + 0.4 * sin(200 * pi * t);
delta = 0.3;
Kup = 1.3;
Kdown = 0.8;
codeout = dltpcm_adp(x, delta, Kup, Kdown);
xe = depcm_adp(codeout, delta, Kup, Kdown);
figure
subplot(211); stairs(t, codeout); axis([min(t), max(t), -1, 2]);
subplot(212); stairs(t, xe); hold on; plot(t, x); axis([min(t), max(t), -4, 4]); hold off;
