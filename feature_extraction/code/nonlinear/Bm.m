function Phi=Bm(data,R,m,N)

M=N-m+1;
discount=zeros(M,1);
d=zeros(M,M);
Y=reconstitution(data,N,m,1);%�ع���ռ�
for i=1:M
    for j=1:M
        d(i,j)=max(abs(Y(:,i)-Y(:,j)));%���㲻ͬ���������
    end
end
H=abs(d)-R;%�Ƚ������������R�Ĵ�С
for i=1:M
discount(i)=length(find((H(i,:)<0)));
end
disc=discount-1;%ͳ������i���������������С��R����������
Lpm=disc./(N-m);
for i=1:M
if Lpm(i)~=0
Dm(i)=log(Lpm(i));
else
Dm(i)=0;
end
end
Phi=sum(Dm)/(N-m+1);