function [ t, out ] = BPF( f, Sf, fc, B )
%BPF �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
df = f(2) - f(1);
N = length(f);
NC = floor(N/2);
Nfc = floor(fc/df);
NB2 = floor(B/df/2);
bpfH = zeros(1, N);
N1 = [NC-Nfc+[-NB2:NB2], NC+Nfc+[-NB2:NB2]];
bpfH(N1) = 1;
Yf = bpfH.*Sf;
[t, out] = IFFT_SHIFT(f, Yf);
end
