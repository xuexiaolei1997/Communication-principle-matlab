clear;
%% 标准调幅 AM
% Signal
dt = 0.001;  % 时间采样间隔
fmax = 1;  % 信源最高频率
fc = 10;  % 载波中心频率
T = 5;  % 信号时长
N = T / dt;
t = [0: N-1] * dt;
mt = sqrt(2) * cos(2 * pi * fmax * t);  % 信源
% AM modulation
A = 2;
s_am = (A + mt) .* cos(2 * pi * fc * t);
% Power Spectrum Density
[f, Xf] = FFT_SHIFT(t, s_am);  % 调制信号频谱
PSD = (abs(Xf).^2)/T;   % 调制信号功率谱密度
figure(1)
subplot(211), plot(t, s_am), hold on, plot(t, A+mt, 'r--'), title('AM调制信号及其包络'); xlabel('t');
subplot(212), plot(f, PSD), axis([-2*fc 2*fc 0 1.5*max(PSD)]), title('AM信号功率谱'); xlabel('f');
%% 抑制载波双边带调幅 DSB
%% 单边带调幅 SSB
%% 残留边带调幅 VSB
dt = 0.001;  % 时间采样间隔
fmax = 5;  % 信源最高频率
fc = 20;  % 载波中心频率
T = 5;  % 信号时长
N = T / dt;
t = [0: N-1] * dt;
mt = sqrt(2) * (cos(2 * pi * fmax * t) + sin( 2 * pi * fmax * 0.5 * t));  % 信源
% VSB modulation
s_vsb = mt.*cos(2*pi*fc*t);
B = 1.2*fmax;
[f, sf] = FFT_SHIFT(t, s_vsb);
[t, s_vsb] = vsbmd(f, sf, 0.2*fmax, 1.2 * fmax, fc);
% Power Spectrum Density
[f, sf] = FFT_SHIFT(t, s_vsb);
PSD = (abs(sf).^2)/T;
figure(1)
subplot(211), plot(t, s_vsb), hold on, plot(t, mt, 'r--'), title('VSB调制信号'), xlabel('t');
subplot(212), plot(f, PSD), axis([-2*fc 2*fc 0 max(PSD)]), title('VSB信号功率谱'), xlabel('f');

%% 相干解调
% AM解调
% 标准解调
% 单边带解调
% 残留边带解调
%% 案例
% Signal
dt = 0.001;
fmax = 1;
fc = 10;
B = 2*fmax;
T = 5;
N = floor(T/dt);
t = [0:N-1]*dt;
mt = sqrt(2)*cos(2*pi*fmax*t);  % 信源

% AM modulation
A = 2;
am = (A+mt).*cos(2*pi*fc*t);  % 调制
amd = am.*cos(2*pi*fc*t);  % 相干解调
amd = amd - mean(amd);
[f, AMf] = FFT_SHIFT(t, amd);
B = 2*fmax;
[t, am_t] = RECT_LPF(f, AMf, B);  % 低通滤波

% DSB Modulation
dsb  = mt .* cos(2*pi*fc*t);
dsbd =  dsb .* cos(2*pi*fc*t);
dsbd = dsbd - mean(dsbd);
[f, DSBF] = FFT_SHIFT(t, dsbd);
[t, dsb_t] = RECT_LPF(f, DSBF, B);

% SSB Modulation
ssb = real(hilbert(mt).*exp(1i*2*pi*fc*t));
ssbd =  dsb .* cos(2*pi*fc*t);
ssbd = ssbd - mean(ssbd);
[f, SSBF] = FFT_SHIFT(t, ssbd);
[t, ssb_t] = RECT_LPF(f, SSBF, B);

% VSB Modulation
vsb = mt .* cos(2*pi*fc*t);
[f, vsbf] = FFT_SHIFT(t, vsb);
[t, vsb] = vsbmd(f, vsbf, 0.2*fmax, 1.2 * fmax, fc);
vsbd = vsb .* cos(2*pi*fc*t);
vsbd = vsbd - mean(vsbd);
[f, VSBF] = FFT_SHIFT(t, vsbd);
[t, vsb_t] = RECT_LPF(f, VSBF, B);

figure
subplot(511), plot(t, mt), title('相干解调后的信号与输入信号的比较'), ylabel('m(t)');axis([0 T -2 2]);
subplot(512), plot(t, am_t), ylabel('am(t)');axis([0 T -2 2]);
subplot(513), plot(t, dsb_t), ylabel('dsb(t)');axis([0 T -2 2]);
subplot(514), plot(t, ssb_t), ylabel('ssb(t)'); axis([0 T -2 2]);
subplot(515), plot(t, vsb_t), ylabel('vsb(t)'), xlabel('t');axis([0 T -2 2]);
%% 非相干解调
%% 角度调制 FM PM
% 窄带调频->NBFM，宽带调频->WBFM: 30°为界限
% 窄带调相->NBPM，宽带调相->WBPM: 30°为界限
%% 解调
% FM modulation and demodulation
Kf = 5;
fc = 10;
T = 5;
dt = 0.001;
t = 0:dt:T;
% 信源
fm = 1;
A = sqrt(2);
mt = A*cos(2*pi*fm*t);
% FM 调制
mti = 1/2/pi/fm*sin(2*pi*fm*t);
FMt = A*cos(2*pi*fc*t+2*pi*Kf*mti);
figure(1);
subplot(311), plot(t, FMt); hold on; plot(t, mt, 'r--'); xlabel('t'); ylabel('调制信号');
subplot(312);
[f, sf] = FFT_SHIFT(t, FMt);
plot(f, abs(sf)); axis([-25 25 0 3]); xlabel('f'); ylabel('调频信号幅度谱');
% FM 解调
N = length(FMt);
dFMt = zeros(1, N);
for k=1:N-1
    dFMt(k) = (FMt(k+1)-FMt(k))/dt;
end
envlp = A*2*pi*Kf*mt+A*2*pi*fc;
subplot(313); plot(t, dFMt); hold on; plot(t, envlp, 'r--'); xlabel('t'); ylabel('调频信号微分后包络');
%% 案例
dt = 0.001;
T = 5;

fm = 1;
fc = 10;
N = T/dt;
t = [0:N-1]*dt;
mt = sqrt(2)*cos(2*pi*fm*t);
C = cos(2*pi*fc*t);
N0 = 0.1;
% AM modulation
A = 2;
amt = (A+mt).*C;
B = 2*fm;
noise = GaussNB(fc, B, N0, t);
amt = amt+noise;
figure
subplot(321), plot(t, amt); hold on; plot(t, A+mt, 'r--');title('AM信号');xlabel('t');
% AM demodulation
id_amt = amt.*cos(2*pi*fc*t);
id_amt = id_amt - mean(id_amt);
[f, AMf] = FFT_SHIFT(t, id_amt);
[t, id_amt] = RECT_LPF(f, AMf, B);
subplot(322); plot(t, id_amt); hold on; plot(t, mt/2, 'r--'); title('AM解调信号'); xlabel('t');
% DSB modulation
dsbt = mt.*C;
noise = GaussNB(fc, B, N0, t);
dsbt = dsbt + noise;
subplot(323), plot(t, dsbt); hold on; plot(t, mt, 'r--'); title('DSB信号'); xlabel('t');
% DSB demodulation
id_dsbt = dsbt.*C;
id_dsbt = id_dsbt - mean(id_dsbt);
[f, DSBF] = FFT_SHIFT(t, id_dsbt);
[t, idd_mt] = RECT_LPF(f, DSBF, B);
subplot(324), plot(t, idd_mt), hold on; plot(t, mt/2, 'r--'); title('DSB解调信号');xlabel('t');
% SSB modulation
ssbt = real(hilbert(mt).*exp(1i*C));
noise = GaussNB(fc, B, N0, t);
ssbt = ssbt + noise;
subplot(325), plot(t, ssbt); hold on; plot(t, mt, 'r--'); title('SSB信号'); xlabel('t');
% SSB demodulation
id_ssbt = ssbt.*C;
id_ssbt = id_ssbt - mean(id_ssbt);
[f, SSBF] = FFT_SHIFT(t, id_ssbt);
[t, ids_mt] = RECT_LPF(f, SSBF, B);
subplot(326), plot(t, ids_mt), hold on; plot(t, mt/2, 'r--'); title('SSB解调信号');xlabel('t');