clc;
fm=100;     %信号频率
fc=500;     %载波频率
fs=5000;    %抽样频率
Am=1;
A=2;
N=512;
K=N-1;
n=0:N-1;
t=(0:1/fs:K/fs);
yt=Am*cos(2*pi*fm*t);
figure(1)
subplot(1,1,1);plot(t,yt);title('频率为100HZ信号时域波形');

y0=A+yt;
y2=y0.*cos(2*pi*fc*n/fs);
y3=fft(y2,N);
q1=(0:N/2-1)*fs/N;
mx1=abs(y3(1:N/2));
figure(2)
subplot(2,1,1);
plot(t,y2);
title('已调信号时域波形');
subplot(2,1,2);
plot(q1,mx1);
title('已调信号频谱');
yc=cos(2*pi*fc*t);
figure(3);
subplot(2,1,1),plot(t,yc),title('载波fc时域')
n=0:N-1;
yc1 = Am*cos(2*pi*fc*n/fs);
y3=fft(yc1,N);
q=(0:N/2-1)*fs/N;
mx=abs(y3(1:N/2));
figure(3)
subplot(2,1,2),plot(q,mx),title('载波fc频谱')
N=512;
n=0:N-1;
y4=0.01*randn(1,length(t)); %产生高斯噪声
w=y4.^2;                    %噪声功率
figure(4);
subplot(2,1,1);
plot(t,y4);
title('高斯白噪声时域波形');
y5=fft(y4,N);
q2=(0:N/2-1)*fs/N;
mx2=abs(y5(1:N/2));
figure(4);
subplot(2,1,2);
plot(q2,mx2);
title('高斯白噪声频域波形');
y6=y2+y4;
figure(5);
subplot(2,1,1);
plot(t,y6);
title('加噪声后时域信号')
q3=q1;
mx3=mx1+mx2;
subplot(2,1,2);
plot(q3,mx3);
title('加噪声后频谱')


yv=y6.*yc;   %乘以载波想干解调
Ws=yv.^2;
p1=fc-fm;
[k,Wn,beta,ftype]=kaiserord([p1 fc],[1 0],[0.05 0.01],fs);%数字低通过滤波器
window=kaiser(k+1,beta);%使用kaiser窗函数
b=fir1(k,Wn,ftype,window,'noscale');%
yt=filter(b,1,yv);
yssdb=yt.*2-2;
figure(6)
subplot(2,1,1);
plot(t,yssdb);
title('经过低通已调信号时域波形')    ;%解调

y9=fft(yssdb,N);
mx=abs(y9(1:N/2));
subplot(2,1,2);
plot(q,mx);
title('已调信号频域波形')