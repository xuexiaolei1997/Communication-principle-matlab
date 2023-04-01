function [ t, st ] = RECT_LPF( f, Sf, B )
%RECT_LPF 低通滤波
%   此处显示详细说明
df = f(2) - f(1);
fN= length(f);
RectH = zeros(1, fN);
BN = floor(B/df);
BN_SHIFT = [-BN:BN-1]+floor(fN/2);
RectH(BN_SHIFT)=1;
Yf = RectH.*Sf;
[t, st] = IFFT_SHIFT(f, Yf);
end

