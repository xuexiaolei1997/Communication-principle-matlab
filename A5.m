clear;
%% ��׼���� AM
% Signal
dt = 0.001;  % ʱ��������
fmax = 1;  % ��Դ���Ƶ��
fc = 10;  % �ز�����Ƶ��
T = 5;  % �ź�ʱ��
N = T / dt;
t = [0: N-1] * dt;
mt = sqrt(2) * cos(2 * pi * fmax * t);  % ��Դ
% AM modulation
A = 2;
s_am = (A + mt) .* cos(2 * pi * fc * t);
% Power Spectrum Density
[f, Xf] = FFT_SHIFT(t, s_am);  % �����ź�Ƶ��
PSD = (abs(Xf).^2)/T;   % �����źŹ������ܶ�
figure(1)
subplot(211), plot(t, s_am), hold on, plot(t, A+mt, 'r--'), title('AM�����źż������'); xlabel('t');
subplot(212), plot(f, PSD), axis([-2*fc 2*fc 0 1.5*max(PSD)]), title('AM�źŹ�����'); xlabel('f');
%% �����ز�˫�ߴ����� DSB
%% ���ߴ����� SSB
%% �����ߴ����� VSB
dt = 0.001;  % ʱ��������
fmax = 5;  % ��Դ���Ƶ��
fc = 20;  % �ز�����Ƶ��
T = 5;  % �ź�ʱ��
N = T / dt;
t = [0: N-1] * dt;
mt = sqrt(2) * (cos(2 * pi * fmax * t) + sin( 2 * pi * fmax * 0.5 * t));  % ��Դ
% VSB modulation
s_vsb = mt.*cos(2*pi*fc*t);
B = 1.2*fmax;
[f, sf] = FFT_SHIFT(t, s_vsb);
[t, s_vsb] = vsbmd(f, sf, 0.2*fmax, 1.2 * fmax, fc);
% Power Spectrum Density
[f, sf] = FFT_SHIFT(t, s_vsb);
PSD = (abs(sf).^2)/T;
figure(1)
subplot(211), plot(t, s_vsb), hold on, plot(t, mt, 'r--'), title('VSB�����ź�'), xlabel('t');
subplot(212), plot(f, PSD), axis([-2*fc 2*fc 0 max(PSD)]), title('VSB�źŹ�����'), xlabel('f');

%% ��ɽ��
% AM���
% ��׼���
% ���ߴ����
% �����ߴ����
%% ����
% Signal
dt = 0.001;
fmax = 1;
fc = 10;
B = 2*fmax;
T = 5;
N = floor(T/dt);
t = [0:N-1]*dt;
mt = sqrt(2)*cos(2*pi*fmax*t);  % ��Դ

% AM modulation
A = 2;
am = (A+mt).*cos(2*pi*fc*t);  % ����
amd = am.*cos(2*pi*fc*t);  % ��ɽ��
amd = amd - mean(amd);
[f, AMf] = FFT_SHIFT(t, amd);
B = 2*fmax;
[t, am_t] = RECT_LPF(f, AMf, B);  % ��ͨ�˲�

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
subplot(511), plot(t, mt), title('��ɽ������ź��������źŵıȽ�'), ylabel('m(t)');axis([0 T -2 2]);
subplot(512), plot(t, am_t), ylabel('am(t)');axis([0 T -2 2]);
subplot(513), plot(t, dsb_t), ylabel('dsb(t)');axis([0 T -2 2]);
subplot(514), plot(t, ssb_t), ylabel('ssb(t)'); axis([0 T -2 2]);
subplot(515), plot(t, vsb_t), ylabel('vsb(t)'), xlabel('t');axis([0 T -2 2]);
%% ����ɽ��
%% �Ƕȵ��� FM PM
% խ����Ƶ->NBFM�������Ƶ->WBFM: 30��Ϊ����
% խ������->NBPM���������->WBPM: 30��Ϊ����
%% ���
% FM modulation and demodulation
Kf = 5;
fc = 10;
T = 5;
dt = 0.001;
t = 0:dt:T;
% ��Դ
fm = 1;
A = sqrt(2);
mt = A*cos(2*pi*fm*t);
% FM ����
mti = 1/2/pi/fm*sin(2*pi*fm*t);
FMt = A*cos(2*pi*fc*t+2*pi*Kf*mti);
figure(1);
subplot(311), plot(t, FMt); hold on; plot(t, mt, 'r--'); xlabel('t'); ylabel('�����ź�');
subplot(312);
[f, sf] = FFT_SHIFT(t, FMt);
plot(f, abs(sf)); axis([-25 25 0 3]); xlabel('f'); ylabel('��Ƶ�źŷ�����');
% FM ���
N = length(FMt);
dFMt = zeros(1, N);
for k=1:N-1
    dFMt(k) = (FMt(k+1)-FMt(k))/dt;
end
envlp = A*2*pi*Kf*mt+A*2*pi*fc;
subplot(313); plot(t, dFMt); hold on; plot(t, envlp, 'r--'); xlabel('t'); ylabel('��Ƶ�ź�΢�ֺ����');
%% ����
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
subplot(321), plot(t, amt); hold on; plot(t, A+mt, 'r--');title('AM�ź�');xlabel('t');
% AM demodulation
id_amt = amt.*cos(2*pi*fc*t);
id_amt = id_amt - mean(id_amt);
[f, AMf] = FFT_SHIFT(t, id_amt);
[t, id_amt] = RECT_LPF(f, AMf, B);
subplot(322); plot(t, id_amt); hold on; plot(t, mt/2, 'r--'); title('AM����ź�'); xlabel('t');
% DSB modulation
dsbt = mt.*C;
noise = GaussNB(fc, B, N0, t);
dsbt = dsbt + noise;
subplot(323), plot(t, dsbt); hold on; plot(t, mt, 'r--'); title('DSB�ź�'); xlabel('t');
% DSB demodulation
id_dsbt = dsbt.*C;
id_dsbt = id_dsbt - mean(id_dsbt);
[f, DSBF] = FFT_SHIFT(t, id_dsbt);
[t, idd_mt] = RECT_LPF(f, DSBF, B);
subplot(324), plot(t, idd_mt), hold on; plot(t, mt/2, 'r--'); title('DSB����ź�');xlabel('t');
% SSB modulation
ssbt = real(hilbert(mt).*exp(1i*C));
noise = GaussNB(fc, B, N0, t);
ssbt = ssbt + noise;
subplot(325), plot(t, ssbt); hold on; plot(t, mt, 'r--'); title('SSB�ź�'); xlabel('t');
% SSB demodulation
id_ssbt = ssbt.*C;
id_ssbt = id_ssbt - mean(id_ssbt);
[f, SSBF] = FFT_SHIFT(t, id_ssbt);
[t, ids_mt] = RECT_LPF(f, SSBF, B);
subplot(326), plot(t, ids_mt), hold on; plot(t, mt/2, 'r--'); title('SSB����ź�');xlabel('t');