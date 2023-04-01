function [ f, sf ] = FFT_SHIFT( t, st )
%FFT_SHIFT 计算信号的傅里叶变换
% t: 采样时间，长度必须大于2
% st: 数字信号
% f: 采样频率
% sf: 频谱
dt = t(2) - t(1);
T = t(end);
df = 1 / T;
N = length(t);
f = [-N/2:N/2-1]*df;
sf = fft(st);
sf = T / N * fftshift(sf);

end

