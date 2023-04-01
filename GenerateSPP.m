clc;
clear;
close all;
%%
typo_num = 10;
N=200;
delta = 0.001;
c=(-N/2:N/2)*delta;
r=(-N/2:N/2)*delta;
l=1;
[x,y]=meshgrid(c,r);
[theta,r]=cart2pol(x,y);
g=mod(typo_num*theta,2*pi);
figure;
imshow(g,[]);