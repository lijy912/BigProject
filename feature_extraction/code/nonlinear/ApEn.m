%%%%%%%%%%%%%spectral entropy%%%%%%%%%%%%%%%%%%%%
%%������
%%2009.11.17
%&�������룺AΪ��Ҫ�������������ݣ���������FsΪ����Ĳ�����
%%���������Em����������õ��Ľ����ص�����ֵ��ÿwindow_t s����õ�һ��ֵ������ʱÿ���ص�window_t/2 s��AmeanΪ
%��������ص�ƽ��ֵ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Em,Amean]=ApEn(A)
%filename='F:\data\2010.06.06\jiequ\1.txt';
%A=load(input);
Fs=250;
m=2;
r=0.2;
%A=load(input);
G=length(A);
window_t=10;
%N=Fs*window_t;%ÿ�μ�������г���
N=length(A);
g=Fs*(window_t/2);%ÿ�λ����ĵ���
t=((G-N)/g);
h=floor(t);
Em=zeros(h,1);
for i=0:h %�����Ĵ���
    data=A(1+i*g:N+i*g);%���ݻ�����ȡ
    R=r*std(data,1);  %����R
   Em(i+1)=Bm(data,R,m,N)-Bm(data,R,m+1,N);%���������
end
Amean=mean(Em);



