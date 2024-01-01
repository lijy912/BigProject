%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%������
%%2010.06.17
%�������룺�ó�����A���������󣨵�����ݣ���FsΪ����Ĳ����ʣ�p������1�򻭳�C0������ͼ
%�������?:CorrelationDimension���������õ��Ĺ���ά��D2������ֵ��ÿwindow_t s����õ�һ��C0ֵ������ʱÿ���ص�window_t/2 s��M_CΪ
%�������ά���ƽ��ֵ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [CorrelationDimension,M_C]=reC(A,Fs,p,window_t)
% filename='F:\data\12.12\DQX\DQX3_close\1.txt';
  % A=load(input);
   %filename = 'F:\data\biyeshuju\slp14\wake\reC.txt';
  Fs=250;
  p=0;
  % window_t=4;
   N=length(A);%采样�?
   G=length(A);
   g=N/2;%ÿ�λ����ĵ���
   t=((G-N)/g);
   h=floor(t);
   ss=50;
   %tau=6;
   m=15;
   C=zeros(1,ss);
   min_d=10000;
for ii=0:h %�����Ĵ���
    data=A(1+ii*g:N+ii*g);
    tau=tau_def(data);
    M=N-(m-1)*tau;%��ռ�ÿһά���еĳ���?
   %disp(['this is M:' int2str(M)]);
    d=zeros(M-1,M);
    Y=reconstitution(data,N,m,tau);%�ع���ռ�?
    for i=1:M-1
       for j=i+1:M
          d(i,j)=norm((Y(:,i)-Y(:,j)),2);
          if d(i,j)<min_d
              min_d=d(i,j);
          end
       end     %����״̬�ռ���ÿ����֮��ľ���?
    end
    max_d=max(max(d));% �õ����е�֮���������?
     %min_d=min(min(d));%�õ����е�����̾���?
    delt=(max_d-min_d)/(ss*2);% �õ�r�Ĳ���
    for k=1:ss
        r(k)=min_d+k*delt;
        H(k)=length(find(r(k)>d))';
        C(k)=2*H(k)/(M*(M-1))-1;
    %C(k)=correlation_integral(Y,M,r); %����������
       ln_C(m,k)=log2(C(k)); %lnC(r)
       ln_r(m,k)=log2(r(k)); %lnr
    end
    D=abs(C-0.1);
    kmax=find(D==min(D));
    rmax=min_d+kmax*delt;
    rmin=min_d+0.5*(rmax-min_d);
    kmin=floor((rmin-min_d)/delt);
    %figure(ii+1);
%     for k=1:ss
%        r(k)=min_d+k*delt;
%     end
%     slope = diff(ln_C(m,:))./diff(log(r));
    if p==1
    subplot(1,2,1);
    plot(log(r),ln_C(m,:),'+:'); grid; %����
    xlabel('log(r)'); ylabel('ln_C(m,:)'); 
    hold on;
    end
    % �����������?
    ln_Cr=ln_C(m,:);    
    ln_r=ln_r(m,:);
     if kmin<=0
       kmin=1;
       kmax=5;
       disp(['kmin=:' ,num2str(kmin)]);
    end
    LinearZone=[kmin:kmax];
   
    F = polyfit(ln_r(LinearZone),ln_Cr(LinearZone),1);
    
    CorrelationDimension(ii+1)= F(1);
   % disp(['this is ii:' int2str(ii)]);
end
    M_C=mean(CorrelationDimension);
    if p==1
      subplot(1,2,2);
      plot(CorrelationDimension);
      ylabel('CorrelationDimension'); 
      hold on;
    end

    
