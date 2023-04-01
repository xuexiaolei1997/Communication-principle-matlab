clear; close all;
%% 数字基带的码型
x = [1 0 1 1 0 0 1 0];
nrz(x, 's'); % 单极性不归零码
nrz(x, 'd'); % 双极性不归零码
rz(x, 's'); % 单极性归零码
rz(x, 'd'); % 双极性归零码
rz(x, 'm'); % manchester双相码
dmachester(x);
miller(x);
%% 码型功率谱
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
ylabel('双极性(P=1/2)');legend('dnrz', 'drz');
%% 基带传输误码率
%% 码间串扰
%% 升余弦滚降系统
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
subplot(211); plot(f, Xf); axis([-1 1 0 1.2]); xlabel('f/Ts');ylabel('升余弦滚降频谱');
subplot(212); plot(t, xt); axis([-10 10 -0.5 1.1]); xlabel('t');ylabel('升余弦滚降波形');
%% 眼图
% Ts = 1;
% N = 17;
% eye_num = 6;
% a = 1;
% N_data = 1000;
% dt = Ts/N;
% t = -3*Ts:dt:3*Ts;
% % 产生双极性数字信号
% d = sign(randn(1, N_data));
% % dd = sigexpand(f, N);
% % 基带系统冲击响应
% ht = sinc(t/Ts).*(cos(a*pi*t/Ts))./(1-4*a^2*t.^2/Ts^2+eps);
% st = conv(d, ht);
% tt = -3*Ts:dt:(N_data+3)*N*dt-dt;
% figure
% subplot(211); plot(tt, st); axis([0 20 -1.2 1.2]); xlabel('t/Ts'); ylabel('基带信号');
% subplot(212);
% % 画眼图
% ss = zeros(1, eye_num*N);
% ttt = 0:dt:eye_num*N*dt-dt;
% for k=3:50
%     ss = st(k*N+1:(k+eye_num)*N);
%     drawnow;
%     plot(ttt, ss);
%     hold on
% end
% xlabel('t/Ts'); ylabel('基带信号眼图');
%% 均衡技术
%% 部分响应
%% 案例分析
sn = 0.1:0.01:100;  % 定义信噪比序列
snlg = 20*log10(sn);  % 将信噪比转化为dB表示
sdouble = sqrt(sn);
ssingle = sqrt(sn/2);
bdouble = erfc(sdouble)/sqrt(2);  % 求双极性的误比特率序列
bsingle = erfc(ssingle)/sqrt(2);  % 求单极性的误比特率序列
semilogy(snlg, bdouble);
hold;
semilogy(snlg, bsingle, '--');
axis([-20 39 1e-7 1]);
% 通过观察曲线，大致判断出双极性小于给定误比特率的信噪比位置
i = 1100;
while(i<length(sn))
    if(bdouble(i)<10^(-6))
        bsn=snlg(i);  % 记下符合条件的信噪比
        i=length(sn)+1;
    end
    i=i+1;
end
% 通过观察曲线，大致判断出单极性小于给定误比特率的信噪比位置
i = 2300;
while(i<length(sn))
    if(bsingle(i)<10^(-6))
        ssn=snlg(i);  % 记下符合条件的信噪比
        i=length(sn)+1;
    end
    i=i+1;
end
disp('双极性NRZ码所需的信噪比为:(dB)');
bsn
disp('单极性NRZ码所需的信噪比为:(dB)');
ssn
%% 案例分析
EbN0dB = 0:0.5:10;
N0 = 10.^(-EbN0dB/10);
sigma = sqrt(N0/2);
% 理论计算的误码率
Pb = 0.5*erfc(sqrt(1./N0));
% 仿真误码率
for n =1:length(EbN0dB)
    % 产生等概信源
    a = sign(randn(1, 1e5));
    % 离散等效接收模型
    rk = a+sigma(n)*randn(1, 1e5);
    dec_a = sign(rk); %判决
    % 计算误码率
    ber(n) = sum(abs(a-dec_a)/2)/length(a);
end
semilogy(EbN0dB, Pb);
hold;
semilogy(EbN0dB, ber, 'rd-');
legend('理论值', '仿真结果');
xlabel('Eb/N0(dB)');
ylabel('Pb');