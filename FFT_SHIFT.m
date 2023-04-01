function [ f, sf ] = FFT_SHIFT( t, st )
%FFT_SHIFT �����źŵĸ���Ҷ�任
% t: ����ʱ�䣬���ȱ������2
% st: �����ź�
% f: ����Ƶ��
% sf: Ƶ��
dt = t(2) - t(1);
T = t(end);
df = 1 / T;
N = length(t);
f = [-N/2:N/2-1]*df;
sf = fft(st);
sf = T / N * fftshift(sf);

end

