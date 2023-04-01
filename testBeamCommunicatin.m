clear
clc
close all;
%% Parameters 
% 激光器参数
roll_off = 0.25;
F = 8; % oversampling factor
nTaps = 6;  % 
M = 64;
k = log2(M);

nSyms = 6000000;
nBits = nSyms * log2(M);
EbN0 = 1:20; 
SNR = EbN0 + 10*log10(k) - 10*log10(F);
% nSpS = 4; 
BER = zeros(1,length(SNR));
%% TX
for nEn = 1 : numel(EbN0)
txBits = randi([0,1],1,nBits);
mod_Bit = reshape(txBits,log2(M),nBits/log2(M));
mod_sig = qammod(mod_Bit,M,'InputType','bit');
% scatterplot(mod_sig);
% title('发射星座图')
 
% up_sig = upsample(mod_sig,F);
 
pulse = rcosdesign(roll_off,nTaps,F);  % 输出长度为nTaps * F + 1 = 81； 
 
% fvtool(pulse,'impulse')
 
pulse_out = upfirdn(mod_sig,pulse,F);  % 它的输出长度 = nSyms * 81 -（F-1） F-1个0 
 
% scatterplot(pulse_out)
% title('成形滤波后的星座图')
 
% RX
 
    rx_sig = awgn(pulse_out,SNR(nEn),'measured');
    %匹配滤波 and 降采样
    match_sig = upfirdn(rx_sig,pulse,1,F); 
    rxFilt =  match_sig(nTaps +1:end-nTaps );  %去除掉多的数据
    demod_sig = qamdemod(rxFilt,M,'OutputType','bit');
    
    rx_Bits = reshape(demod_sig,1,[]);
    BER(nEn) = sum(rx_Bits ~= txBits)/numel(rx_Bits);
end
 
 
semilogy(EbN0,BER,'*-')
hold on 
EbN0_bushiDb = 10.^(EbN0/10); % db转化
 
semilogy(EbN0, 7/24 .* erfc( sqrt( EbN0_bushiDb ./ 42 ) ) ,'s-');