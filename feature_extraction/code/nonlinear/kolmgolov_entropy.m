%%%%%%%%%%%%%%%%%%%%%%kolmgolov entropy%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%���ߣ�������
%%%%���ڣ�2010.07.08
%&�������룺AΪ��Ҫ������������ݣ���������FsΪ����Ĳ����ʣ�p������1�򻭳�kolmogolov����ʱ��仯�������?
%%���������Km���������õ���kolmogolov�ص�����ֵ��ÿwindow_t s����õ�һ��ֵ������ʱÿ���ص�window_t/2 s��AverageΪ
%���kolmogolov�ص�ƽ��ֵ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [Km,Kmean]=kolmgolov_entropy(A)
%filename='F:\data\2009.01.14\QYB\QYB1\1.txt';
%A=load(input);
Fs=250;
p=0;
%window_t=10;
%N=Fs*window_t;%ÿ�μ�������г���?
N=length(A);
m=15;
G=length(A);
g=N/2;%ÿ�λ����ĵ���
t=((G-N)/g);
h=floor(t);
LKm=zeros(h,1);
for i=0:h %�����Ĵ���
    data=A(1+i*g:N+i*g);
    tau=tau_def(data);
    LKm(i+1)=log((CK(data,m,N,tau))./(CK(data,m+13,N,tau)));
    Km=(1/(tau*13))*LKm;
    %Ke=Km(3);
end
if p==1
    plot(Km);
end
Kmean=mean(Km);

