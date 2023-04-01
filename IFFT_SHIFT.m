function [ t, st ] = IFFT_SHIFT( f, Sf )
%IFFT_SHIFT 此处显示有关此函数的摘要
%   此处显示详细说明
df = f(2) - f(1);
fmax = (f(end)-f(1)+df);
dt = 1/fmax;
N = length(f);
t = [0:N-1]*dt;
Sf = fftshift(Sf);
st = fmax*ifft(Sf);
st = real(st);
end

