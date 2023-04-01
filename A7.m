clear; close all;
%% ���ֻ���������
x = [1 0 1 1 0 0 1 0];
nrz(x, 's'); % �����Բ�������
nrz(x, 'd'); % ˫���Բ�������
rz(x, 's'); % �����Թ�����
rz(x, 'd'); % ˫���Թ�����
rz(x, 'm'); % manchester˫����
dmachester(x);
miller(x);
%% ���͹�����
f = 0:0.01:5;
Ts = 1;
x = f*Ts;
y = sinc(x);
y(1) = 1;
dnrz = y.*y;
dnrz = Ts*dnrz;

y = sin(pi*x/2);
y = y./(pi*x/2);
y(1)=1; 
drz = y.*y;
drz = Ts*drz/4;
figure
plot(x, dnrz, ':', x, drz, '-');
xlabel('f');
ylabel('˫����(P=1/2)');legend('dnrz', 'drz');
%% ��������������
%% ��䴮��
%% �����ҹ���ϵͳ
Ts = 1;
N = 17;
dt = Ts/N;
df = 1.0/(20.0*Ts);
t = -10*Ts:dt:10*Ts;
f = -2/Ts:df:2/Ts;
a = [0, 0.5, 1];
for n=1:length(a)
    for k=1:length(f)
        if abs(f(k))>0.5*(1+a(n))/Ts
            Xf(n, k)=0;
        elseif abs(f(k))<0.5*(1-a(n))/Ts
            Xf(n, k) = Ts;
        else
            Xf(n, k) = 0.5*Ts*(1+cos(pi*Ts/(a(n)+eps)*(abs(f(k))-0.5*(1-a(n))/Ts)));
        end
    end
    xt(n, :)=sinc(t/Ts).*(cos(a(n)*pi*t/Ts))./(1-4*a(n)^2*t.^2/Ts^2+eps);
end
figure
subplot(211); plot(f, Xf); axis([-1 1 0 1.2]); xlabel('f/Ts');ylabel('�����ҹ���Ƶ��');
subplot(212); plot(t, xt); axis([-10 10 -0.5 1.1]); xlabel('t');ylabel('�����ҹ�������');
%% ��ͼ
% Ts = 1;
% N = 17;
% eye_num = 6;
% a = 1;
% N_data = 1000;
% dt = Ts/N;
% t = -3*Ts:dt:3*Ts;
% % ����˫���������ź�
% d = sign(randn(1, N_data));
% % dd = sigexpand(f, N);
% % ����ϵͳ�����Ӧ
% ht = sinc(t/Ts).*(cos(a*pi*t/Ts))./(1-4*a^2*t.^2/Ts^2+eps);
% st = conv(d, ht);
% tt = -3*Ts:dt:(N_data+3)*N*dt-dt;
% figure
% subplot(211); plot(tt, st); axis([0 20 -1.2 1.2]); xlabel('t/Ts'); ylabel('�����ź�');
% subplot(212);
% % ����ͼ
% ss = zeros(1, eye_num*N);
% ttt = 0:dt:eye_num*N*dt-dt;
% for k=3:50
%     ss = st(k*N+1:(k+eye_num)*N);
%     drawnow;
%     plot(ttt, ss);
%     hold on
% end
% xlabel('t/Ts'); ylabel('�����ź���ͼ');
%% ���⼼��
%% ������Ӧ
%% ��������
sn = 0.1:0.01:100;  % �������������
snlg = 20*log10(sn);  % �������ת��ΪdB��ʾ
sdouble = sqrt(sn);
ssingle = sqrt(sn/2);
bdouble = erfc(sdouble)/sqrt(2);  % ��˫���Ե������������
bsingle = erfc(ssingle)/sqrt(2);  % �󵥼��Ե������������
semilogy(snlg, bdouble);
hold;
semilogy(snlg, bsingle, '--');
axis([-20 39 1e-7 1]);
% ͨ���۲����ߣ������жϳ�˫����С�ڸ���������ʵ������λ��
i = 1100;
while(i<length(sn))
    if(bdouble(i)<10^(-6))
        bsn=snlg(i);  % ���·��������������
        i=length(sn)+1;
    end
    i=i+1;
end
% ͨ���۲����ߣ������жϳ�������С�ڸ���������ʵ������λ��
i = 2300;
while(i<length(sn))
    if(bsingle(i)<10^(-6))
        ssn=snlg(i);  % ���·��������������
        i=length(sn)+1;
    end
    i=i+1;
end
disp('˫����NRZ������������Ϊ:(dB)');
bsn
disp('������NRZ������������Ϊ:(dB)');
ssn
%% ��������
EbN0dB = 0:0.5:10;
N0 = 10.^(-EbN0dB/10);
sigma = sqrt(N0/2);
% ���ۼ����������
Pb = 0.5*erfc(sqrt(1./N0));
% ����������
for n =1:length(EbN0dB)
    % �����ȸ���Դ
    a = sign(randn(1, 1e5));
    % ��ɢ��Ч����ģ��
    rk = a+sigma(n)*randn(1, 1e5);
    dec_a = sign(rk); %�о�
    % ����������
    ber(n) = sum(abs(a-dec_a)/2)/length(a);
end
semilogy(EbN0dB, Pb);
hold;
semilogy(EbN0dB, ber, 'rd-');
legend('����ֵ', '������');
xlabel('Eb/N0(dB)');
ylabel('Pb');