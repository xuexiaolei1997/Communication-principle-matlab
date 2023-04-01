clear; clc; close all;
% =================OFDM�������˵����================
% f_delta=15e3;                 ---���ز����
% ���ز��� carrier_count        ---128 Ҳ����FFT������ͨ��Ϊ2�Ĵ���
% ���ز���� f_delta             ---15e3
% �ܷ����� symbol_count          ---1000
% IFFT���� ifft_length           ---128
% ѭ��ǰ׺ cp_length             ---16
% ���Ʒ�ʽ                       ---QPSK 
% �ŵ������㷨 ce_method         ---1��������С���˷�LS��0������mse�㷨
% ���뵼Ƶ��� pilot_interval    ---5
% ÿ�������ű����� M             ---2
% �ŵ�ģ��ѡ����� awgn_en       ---0:��ʾETU�ŵ���1��AWGN�ŵ�
% ����������չ fd              ---300��ͨ��������0-300hz֮�������
% ����ͳ�ƴ��� sta_num           ---10
% ����ȴ�СSNR                  ---������
% ====================�������=======================
% ����0-1������� => ����ת�� => ӳ�� => ȡ����
% => IFFT => ��ѭ��ǰ׺�ͺ�׺ => ����ת�� => 
% �ྶ�ŵ���ETU�ŵ� =>  ��AWGN => ����ת�� => ȥǰ׺
%  => FFT =>��ӳ�� => �������� 
carrier_count = 128;         % ���ز���
f_delta=15e3;                %���ز����
symbol_count = 1000;         %һ�η��͵��ܷ�����
ifft_length = carrier_count; %ifft����Ϊ���ز���Ŀ
cp_length = 16;              %ѭ��ǰ׺
ce_method=1;                 %�ŵ������㷨����1��������С���˷�LS��0������mse�㷨
pilot_interval=5;            %��Ƶ���
awgn_en=0;                   %�ŵ�ѡ����� 0:��ʾETU�ŵ���1��AWGN�ŵ�
M=2;                         %ÿ�������ű�����
fd=300;                      %����������չ
sta_num=20;                  % ����ͳ�ƴ���
num_bit=carrier_count*symbol_count*M;      %��Ӧ�������ݸ�������128*1000*2
pilot_bit_l=randi([0 1],1,M*carrier_count);%���ɵ�Ƶ���У�����ΪM*carrier_count
OFDM_SNR_BER=zeros(1,31);                  %�洢ֱ�ӽ��OFDM������
OFDM_LS_SNR_BER=zeros(1,31);               %�洢�����ŵ����ƺ�OFDM������
i=1;
% ================�ྶ�ŵ�����=======================
fs=(carrier_count)*f_delta;                %�ŵ�����Ϊ���ز�����������ز�����
ts=1/fs;                                   %ÿ��bit���ų�����ʱ��
tau=[0,50,120,200,230,500,1600,2300,5000]/(10^9); 
pdb=[-1.0,-1.0,-1.0,0,0,0,-3.0,-5.0,-7.0];
chan=rayleighchan(ts,fd,tau,pdb);
chan.ResetBeforefiltering=0;
% ================�����������=======================
OFDM_sigbits =sourcebits(num_bit) ;        % 1*256000�����͵�OFDM����
[moddata_outI,moddata_outQ]=qpsk_modulation(OFDM_sigbits);   %����ӳ��
OFDMmoddata_in_temp=moddata_outI+1i*moddata_outQ; 
OFDMmoddata_in=reshape(OFDMmoddata_in_temp,carrier_count,length(OFDMmoddata_in_temp)/carrier_count); %�����任
% ================�ӵ�Ƶ========================
[Insertpilot_out,count,pilot_seq]=insert_pilot_f(OFDMmoddata_in,pilot_bit_l,pilot_interval);  %���뵼Ƶ��ľ���ΪInsertpilot_out����СΪ128*1200
% ===================IFFT===========================
OFDMmoddata_out=ifft(Insertpilot_out,ifft_length)*sqrt(ifft_length);
% ==================��ѭ��ǰ׺==================
InsertCPdata_out=Insert_CP(OFDMmoddata_out,cp_length);
% =================����ת��==========================
[m,n] = size(InsertCPdata_out)
Channel_data=reshape(InsertCPdata_out,1,m*n);
% ===================�����źţ��ྶ�ŵ�====================
for SNR=0:1:30
    be1=0;
    be2=0;
    
    frm_cnt=0;
    while(frm_cnt<sta_num)
        frm_cnt=frm_cnt+1;
        %�����ྶ�ŵ�
        if(awgn_en==1)
             Add_Multipath_data=Channel_data;                    %awgn�ŵ�
        elseif(fd~=0)
             Add_Multipath_data=filter(chan,Channel_data);       %ETU�ŵ�
        end
        
        Add_noise_data=awgn(Add_Multipath_data,SNR,'measured'); %��Ӹ�˹������
        % =======================�����任===========================
        Add_noise_data_temp=reshape(Add_noise_data,m,n);
        % =======================ȥѭ��ǰ׺==========================
        DeleteCPdata_out=Delete_CP(Add_noise_data_temp,cp_length);
        % =======================ȡ����ƵH==========================
        [Deletepilot_Data,H]=Get_pilot(DeleteCPdata_out,pilot_interval);
        % =========================FFT==============================
        OFDM_Demodulationdata_out_iter1=fft(Deletepilot_Data,ifft_length)/sqrt(ifft_length);
        % ===============���ŵ������²���ת���Լ���ӳ��===============
        OFDMdemodulationdata_out_1=reshape(OFDM_Demodulationdata_out_iter1,1,num_bit/2);
        [demodulationdata_outI_1,demodulationdata_outQ_1]=qpsk_demodulation(OFDMdemodulationdata_out_1);%��������ӳ��
        P2Sdata_out_1=P2SConverter(demodulationdata_outI_1,demodulationdata_outQ_1);
        % =====================���ŵ�������==========================
        estimation_output=Channel_estimation(ce_method,Deletepilot_Data,pilot_seq,H);
        OFDMdemodulationdata_out_2=reshape(estimation_output,1,num_bit/2);
        [demodulationdata_outI_2,demodulationdata_outQ_2]=qpsk_demodulation(OFDMdemodulationdata_out_2);%��������ӳ��
        P2Sdata_out_2=P2SConverter(demodulationdata_outI_2,demodulationdata_outQ_2);
        % =========================�������==========================
        be1=be1+length(find(P2Sdata_out_1~=OFDM_sigbits));
        be2=be2+length(find(P2Sdata_out_2~=OFDM_sigbits));
        ber1=be1/(frm_cnt*num_bit);
        ber2=be2/(frm_cnt*num_bit);
        if(mod(frm_cnt,20)==0)
            fprintf('SNR=%.1f,frm_cnt=%d,ber_de=%.8f,ber_ls=%.8f\n',SNR,frm_cnt,ber1,ber2);
        end
    end
    %  fprintf('SNR=%.1f,frm_cnt=%d,ber_de=%.8f,ber_ls=%.8f\n',SNR,frm_cnt,ber1,ber2);
    % =========================������==========================
OFDM_SNR_BER(i)=ber1;
OFDM_LS_SNR_BER(i)=ber2;
i=i+1;
end