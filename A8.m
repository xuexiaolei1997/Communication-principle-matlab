clear; close all; clc;
%%
s = [1 0 1 1 0 0 1 0];
f1 = 2; f2 = 1;
f = 100;
[m, ask] = askdigital(s, f);
[m, fsk] = fskdigital(s, f1, f2);
[m, psk] = pskdigital(s, f);
figure
subplot(411); plot(m); title('ԭʼ�ź�'); axis([0 100 * length(s) -0.1 1.1]);
subplot(412); plot(ask); title('ASK�ź�');
subplot(413); plot(fsk); title('2FSK�ź�');
subplot(414); plot(psk); title('PSK�ź�');
%% QPSK
N = 200;
signal = rand(1, N);
Lt = length(signal); qpsk = zeros(1, Lt / 2);
for i = 1 : Lt / 2
    if signal(2 * i - 1) < 0.5
        if signal(2 * i) < 0.5
            qpsk(i) = 1;
        else
            qpsk(i) = 1i;
        end
    else
        if signal(2 * i) < 0.5
            qpsk(i) = -1;
        else
            qpsk(i) = -1i;
        end
    end
end
figure
plot(qpsk)
%% ��������
% 2ASK,2FSK,2PSK
A = 1; fc = 2;
N_sample = 8;
N = 500; % ��Ԫ��
Ts = 1; % 1Band/s

dt = Ts / fc / N_sample; % ���β������
t = 0 : dt : N * Ts - dt;
Lt = length(t);
T = t(end);

%������������Դ
d = sign(randn(1, N));
dd = INSERT0((d + 1) / 2, fc * N_sample);
gt = ones(1, fc * N_sample); % NRZ����

figure

% ����NRZ�źŲ��� - ������
d_NRZ = conv(dd, gt);
subplot(421); plot(t, d_NRZ(1 : length(t))); axis([0 10 0 1.2]); xlabel('t'); ylabel('�����ź�');

[f, d_NRZf] = FFT_SHIFT(t, d_NRZ(1 : length(t)));
subplot(422); plot(f, 10 * log10(abs(d_NRZf) .^ 2 / T)); axis([-2 2 -50 10]); xlabel('f'); ylabel('�����źŹ������ܶ�(dB/Hz)');

% 2ASK�ź�
ht = A * cos(2 * pi * fc * t);
s_2ask = d_NRZ(1 : Lt) .* ht;
subplot(423); plot(t, s_2ask); axis([0 10 -1.2 1.2]); xlabel('t'); ylabel('2ask');

[f, s_2askf] = FFT_SHIFT(t, s_2ask);
subplot(424); plot(f, 10 * log10(abs(s_2askf) .^ 2 / T)); axis([-fc - 4 fc + 4 -50 10]); xlabel('f'); ylabel('2ask�������ܶ�(dB/Hz)');

% 2FSK
d_2fsk = 2 * d_NRZ - 1;
s_2fsk = A * cos(2 * pi * fc * t + 2 * pi * d_2fsk(1 : length(t)) .* t);
subplot(425); plot(t, s_2fsk); axis([0 10 -1.2 1.2]); xlabel('t'); ylabel('2fsk');

[f, s_2fskf] = FFT_SHIFT(t, s_2fsk);
subplot(426); plot(f, 10 * log10(abs(s_2fskf) .^ 2 / T)); axis([-fc - 4 fc + 4 -50 10]); xlabel('f'); ylabel('2fsk�������ܶ�(dB/Hz)');

% 2PSK�ź�
d_2psk = 2 * d_NRZ - 1;
s_2psk = d_2psk(1 : Lt) .* ht;
subplot(427); plot(t, s_2psk); axis([0 10 -1.2 1.2]); xlabel('t'); ylabel('2psk');

[f, s_2pkf] = FFT_SHIFT(t, s_2psk);
subplot(428); plot(f, 10 * log10(abs(s_2pkf) .^ 2 / T)); axis([-fc - 4 fc + 4 -50 10]); xlabel('f'); ylabel('2psk�������ܶ�(dB/Hz)');