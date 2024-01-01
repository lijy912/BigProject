%%%%%%%%%%%%%%%%Permutation entropy%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%author:lanlanli
%%%%%%%date:2010.09
%�ó�����������ʱ�����е�Permutation_entropy
%&�������룺AΪ��Ҫ������������ݣ���������FsΪ����Ĳ�����?
%%���������Per_en���������õ���Permutation�ص�����ֵ��ÿwindow_t s����õ�һ��ֵ������ʱÿ���ص�window_t/2 s��M_PΪ
%���Permutation�ص�ƽ��ֵ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Per_en,M_P]=Permutation_entropy(A)
%A=load(input);
Fs=250;
window_t=10;
%N=Fs*window_t;
N=length(A);
G=length(A);
g=Fs*(window_t/2);%ÿ�λ����ĵ���
t=((G-N)/g);
h=floor(t);
tau=2;
m=6;
M=N-(m-1)*tau;%��ռ�ÿһά���еĳ���?
for ii=0:h %�����Ĵ���
    data=A(1+ii*g:N+ii*g);
    Y=reconstitution(data,N,m,tau)';%�ع���ռ�?
    [X,I]=sort(Y,2);%���ع���ռ�����������?
    B=unique(I,'rows');%�ҳ�I�е�ÿһ�����ظ���ģʽ
    [Point,K]=size(B);
    C=zeros(Point,1);
    for i=1:Point
        for j=1:M
            if B(i,:)==I(j,:)
                C(i)=C(i)+1;%����ÿ��ģʽ���ֵĴ���
            end
        end
    end
    P_pi=C./M;%����ÿ��ģʽ���ֵĸ���
    Log_pi=log(P_pi);
    H_m=-sum(P_pi.*Log_pi);
    Per_en(ii+1)=H_m/(m-1);%����Permutation_entropy
end
%          PeRn=Per_en./log
M_P=mean(Per_en);








