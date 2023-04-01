clear; clc; close all;
% =================OFDM仿真参数说明：================
% f_delta=15e3;                 ---子载波间隔
% 子载波数 carrier_count        ---128 也就是FFT点数，通常为2的次幂
% 子载波间隔 f_delta             ---15e3
% 总符号数 symbol_count          ---1000
% IFFT长度 ifft_length           ---128
% 循环前缀 cp_length             ---16
% 调制方式                       ---QPSK 
% 信道估计算法 ce_method         ---1：采用最小二乘法LS；0：采用mse算法
% 插入导频间隔 pilot_interval    ---5
% 每星座符号比特数 M             ---2
% 信道模型选择参数 awgn_en       ---0:表示ETU信道；1：AWGN信道
% 最大多普勒扩展 fd              ---300；通常可配置0-300hz之间的数据
% 仿真统计次数 sta_num           ---10
% 信噪比大小SNR                  ---可设置
% ====================仿真过程=======================
% 产生0-1随机序列 => 串并转换 => 映射 => 取共轭
% => IFFT => 加循环前缀和后缀 => 并串转换 => 
% 多径信道即ETU信道 =>  加AWGN => 串并转换 => 去前缀
%  => FFT =>解映射 => 求误码率 
carrier_count = 128;         % 子载波数
f_delta=15e3;                %子载波间隔
symbol_count = 1000;         %一次发送的总符号数
ifft_length = carrier_count; %ifft点数为子载波数目
cp_length = 16;              %循环前缀
ce_method=1;                 %信道估计算法参数1：采用最小二乘法LS；0：采用mse算法
pilot_interval=5;            %导频间隔
awgn_en=0;                   %信道选择参数 0:表示ETU信道；1：AWGN信道
M=2;                         %每星座符号比特数
fd=300;                      %最大多普勒扩展
sta_num=20;                  % 仿真统计次数
num_bit=carrier_count*symbol_count*M;      %对应比特数据个数，即128*1000*2
pilot_bit_l=randi([0 1],1,M*carrier_count);%生成导频序列，长度为M*carrier_count
OFDM_SNR_BER=zeros(1,31);                  %存储直接解调OFDM误码率
OFDM_LS_SNR_BER=zeros(1,31);               %存储基于信道估计后OFDM误码率
i=1;
% ================多径信道参数=======================
fs=(carrier_count)*f_delta;                %信道带宽，为子载波间隔乘以子载波个数
ts=1/fs;                                   %每个bit符号持续的时间
tau=[0,50,120,200,230,500,1600,2300,5000]/(10^9); 
pdb=[-1.0,-1.0,-1.0,0,0,0,-3.0,-5.0,-7.0];
chan=rayleighchan(ts,fd,tau,pdb);
chan.ResetBeforefiltering=0;
% ================产生随机序列=======================
OFDM_sigbits =sourcebits(num_bit) ;        % 1*256000，发送的OFDM数据
[moddata_outI,moddata_outQ]=qpsk_modulation(OFDM_sigbits);   %进行映射
OFDMmoddata_in_temp=moddata_outI+1i*moddata_outQ; 
OFDMmoddata_in=reshape(OFDMmoddata_in_temp,carrier_count,length(OFDMmoddata_in_temp)/carrier_count); %串并变换
% ================加导频========================
[Insertpilot_out,count,pilot_seq]=insert_pilot_f(OFDMmoddata_in,pilot_bit_l,pilot_interval);  %加入导频后的矩阵为Insertpilot_out，大小为128*1200
% ===================IFFT===========================
OFDMmoddata_out=ifft(Insertpilot_out,ifft_length)*sqrt(ifft_length);
% ==================加循环前缀==================
InsertCPdata_out=Insert_CP(OFDMmoddata_out,cp_length);
% =================并串转换==========================
[m,n] = size(InsertCPdata_out)
Channel_data=reshape(InsertCPdata_out,1,m*n);
% ===================发送信号，多径信道====================
for SNR=0:1:30
    be1=0;
    be2=0;
    
    frm_cnt=0;
    while(frm_cnt<sta_num)
        frm_cnt=frm_cnt+1;
        %经过多径信道
        if(awgn_en==1)
             Add_Multipath_data=Channel_data;                    %awgn信道
        elseif(fd~=0)
             Add_Multipath_data=filter(chan,Channel_data);       %ETU信道
        end
        
        Add_noise_data=awgn(Add_Multipath_data,SNR,'measured'); %添加高斯白噪声
        % =======================串并变换===========================
        Add_noise_data_temp=reshape(Add_noise_data,m,n);
        % =======================去循环前缀==========================
        DeleteCPdata_out=Delete_CP(Add_noise_data_temp,cp_length);
        % =======================取出导频H==========================
        [Deletepilot_Data,H]=Get_pilot(DeleteCPdata_out,pilot_interval);
        % =========================FFT==============================
        OFDM_Demodulationdata_out_iter1=fft(Deletepilot_Data,ifft_length)/sqrt(ifft_length);
        % ===============无信道估计下并串转换以及逆映射===============
        OFDMdemodulationdata_out_1=reshape(OFDM_Demodulationdata_out_iter1,1,num_bit/2);
        [demodulationdata_outI_1,demodulationdata_outQ_1]=qpsk_demodulation(OFDMdemodulationdata_out_1);%星座的逆映射
        P2Sdata_out_1=P2SConverter(demodulationdata_outI_1,demodulationdata_outQ_1);
        % =====================有信道估计下==========================
        estimation_output=Channel_estimation(ce_method,Deletepilot_Data,pilot_seq,H);
        OFDMdemodulationdata_out_2=reshape(estimation_output,1,num_bit/2);
        [demodulationdata_outI_2,demodulationdata_outQ_2]=qpsk_demodulation(OFDMdemodulationdata_out_2);%星座的逆映射
        P2Sdata_out_2=P2SConverter(demodulationdata_outI_2,demodulationdata_outQ_2);
        % =========================误比特率==========================
        be1=be1+length(find(P2Sdata_out_1~=OFDM_sigbits));
        be2=be2+length(find(P2Sdata_out_2~=OFDM_sigbits));
        ber1=be1/(frm_cnt*num_bit);
        ber2=be2/(frm_cnt*num_bit);
        if(mod(frm_cnt,20)==0)
            fprintf('SNR=%.1f,frm_cnt=%d,ber_de=%.8f,ber_ls=%.8f\n',SNR,frm_cnt,ber1,ber2);
        end
    end
    %  fprintf('SNR=%.1f,frm_cnt=%d,ber_de=%.8f,ber_ls=%.8f\n',SNR,frm_cnt,ber1,ber2);
    % =========================误码率==========================
OFDM_SNR_BER(i)=ber1;
OFDM_LS_SNR_BER(i)=ber2;
i=i+1;
end