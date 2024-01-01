%%%%%%%%%%%%%%%%%%%   singular_entropy.m    %%%%%%%%%%%%%%%%%
%% 功能：用于计算奇异谱熵
%% 作者：李兰兰
%% 时间：2010.07.10
%&关于输入：A为需要计算特征的数据（单导），Fs为输入的采样率
%%关于输出：H_singu代表程序计算得到的奇异谱熵的特征值，每window_t s个点得到一个值，计算时每次重叠window_t/2 s，M_H为
%输出奇异谱熵的平均值
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [H_singu,M_H]=singular_entropy(A)
% clc;clear;
fs=250;
window_t=10;
%N = fs*window_t;   %截取的一次计算的点数
N=length(A);
%fs = 512;   %采样率

% filename = 'F:\data\2009.01.14\DQX\DQX1\1.txt';  %导入文件
data1 = A;
%N = length(data);
% filename = 'F:\singular1.txt';  %导出文件
% str = 'singular1~singular16:';

%n = [1:N];
%subplot(2,1,1);
%plot(n,data,'r');title('the first N of data.txt');
%xlabel('n');ylabel('y1');

Len =length(data1);
w=fs*(window_t/2);%每次滑动的点数
t=((Len-N)/w);
h=floor(t);
for ii=0:h
    data = data1(1+ii*w:N+ii*w);
% 重构相空间
% m为嵌入空间维数
% tau为时间延迟
% data为输入时间序列
% N为时间序列长度
% X为输出,是m*M维矩阵
tau = 6;    
m = 16;     
M = N-(m-1)*tau;%相空间中点的个数
for  j=1:M       %相空间重构
    for i=1:m
        X(i,j) = data((i-1)*tau+j);
    end
end

C = (X*X')./m;  % 自协方差矩阵
[V,S] = eig(C); % 求特征值，特征向量
for i=1:m
    a(i) = S(i,i);
end
amax = max(a);
singu = log(a./amax);

for i=1:m       % singu排序
    for j=(i+1):m
        if singu(j)>singu(i)
            temp = singu(j);
            singu(j) = singu(i);
            singu(i) = temp;            
        end
    end
    p(i)=singu(i)./sum(singu);
    if p(i)~=0
       lp(i)=log(p(i));
    else
        lp(i)=0;
    end
end
 H_singu(ii+1)=-sum(p*lp');
% hold on;
% k = [1:m];
%subplot(2,1,2);
% plot(k,singu,'-b*');title('singular spectrum');
% xlabel('k');ylabel('singular(k)');

% fprintf(fid,'%s\r\n',str);
end
M_H=mean(H_singu);

