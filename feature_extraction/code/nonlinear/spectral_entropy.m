%%%%%%%%%%%%%spectral entropy%%%%%%%%%%%%%%%%%%%%
%%������
%%2010.06.17
%&�������룺AΪ��Ҫ�������������ݣ���������FsΪ����Ĳ����ʣ�p�������1�򻭳�����������ʱ��仯������ͼ
%%���������PSen����������õ��Ĺ������ص�����ֵ��ÿ4s����õ�һ��ֵ������ʱÿ���ص�2s��AverageΪ
%����������ص�ƽ��ֵ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
function [PSen,Average_PSen]=spectral_entropy(A)
%A=load(input);
M=length(A);
Fs=250;
p=0;
window_t=10;
%N=Fs*window_t;%ÿ�μ�������г���
N=length(A);
m=Fs*(window_t/2);%ÿ�λ����ĵ���
t=((M-N)/m);
h=floor(t);
for j=0:h %�����Ĵ���
    Xt=A(1+j*m:N+j*m);
    Pxx = abs(fft(Xt,N)).^2/N;                 %��ȡ�������ܶ�
    Spxx=sum(Pxx(2:1+N/2));                    %��ȡʱ�����е��ܹ���
    Pf=(Pxx(2:1+N/2))./Spxx;                            %��ȡ����
    for i=1:N/2
        if Pf(i)~=0
           LPf(i)=log(Pf(i));                %��ȡ��������
        else
           LPf(i)=0;
        end
    end
 Hf=Pf.*LPf;
 PSen(j+1)=-(sum(Hf));
end
if p==1
plot(PSen);
end
Average_PSen=mean(PSen);


        