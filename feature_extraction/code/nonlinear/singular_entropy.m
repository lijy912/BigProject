%%%%%%%%%%%%%%%%%%%   singular_entropy.m    %%%%%%%%%%%%%%%%%
%% ���ܣ����ڼ�����������
%% ���ߣ�������
%% ʱ�䣺2010.07.10
%&�������룺AΪ��Ҫ�������������ݣ���������FsΪ����Ĳ�����
%%���������H_singu����������õ����������ص�����ֵ��ÿwindow_t s����õ�һ��ֵ������ʱÿ���ص�window_t/2 s��M_HΪ
%����������ص�ƽ��ֵ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [H_singu,M_H]=singular_entropy(A)
% clc;clear;
fs=250;
window_t=10;
%N = fs*window_t;   %��ȡ��һ�μ���ĵ���
N=length(A);
%fs = 512;   %������

% filename = 'F:\data\2009.01.14\DQX\DQX1\1.txt';  %�����ļ�
data1 = A;
%N = length(data);
% filename = 'F:\singular1.txt';  %�����ļ�
% str = 'singular1~singular16:';

%n = [1:N];
%subplot(2,1,1);
%plot(n,data,'r');title('the first N of data.txt');
%xlabel('n');ylabel('y1');

Len =length(data1);
w=fs*(window_t/2);%ÿ�λ����ĵ���
t=((Len-N)/w);
h=floor(t);
for ii=0:h
    data = data1(1+ii*w:N+ii*w);
% �ع���ռ�
% mΪǶ��ռ�ά��
% tauΪʱ���ӳ�
% dataΪ����ʱ������
% NΪʱ�����г���
% XΪ���,��m*Mά����
tau = 6;    
m = 16;     
M = N-(m-1)*tau;%��ռ��е�ĸ���
for  j=1:M       %��ռ��ع�
    for i=1:m
        X(i,j) = data((i-1)*tau+j);
    end
end

C = (X*X')./m;  % ��Э�������
[V,S] = eig(C); % ������ֵ����������
for i=1:m
    a(i) = S(i,i);
end
amax = max(a);
singu = log(a./amax);

for i=1:m       % singu����
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

