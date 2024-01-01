%%%%%%%%%%%%%%%%%%%%%%shannon_entropy%%%%%%%%%%%%%%%%%%%%%
%%���ߣ�������
%%���ڣ�2010.07.02
%%�ó������ڼ���ʱ�����е�Renyi���ף���������ũ�ص�һ����ʽ��ͬʱ�������źŵķ�ֵ��Ƶ����Ϣ�������Է�����ƽ�ȹ��̻��߷Ǹ�˹���̵�ʱ�����У��㷺
%%�������������⣬�����Ǿ��з��νṹ��������غͳ�ʱ������ϵͳ�����ڴ�����һ�����ӵķ�����ϵͳ����Renyi���׿�����Ϊ�����Ե��ź��׵�һ��ǡ����
%%���ߡ�
%%Renyi����һ�ֽϺõ�ʱƵ�������ߣ�һ����˵�źŵĻ�����ɳɷ�Խ��һ��RenyiֵԽС���෴�ź�Խ���ӣ���ɳɷ�Խ�࣬Renyi��ֵԽ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�������룺�ó�����A����������󣨵������ݣ���FsΪ����Ĳ����ʣ�p�������1�򻭳�Renyi���׵�����ͼ
%���������D_infÿһ�μ���õ���q���������ʱ��Renyiֵ��D_neinf����ÿһ�μ���õ���q��������Сʱ�õ���Renyiֵ��D_q�������ÿ�μ���õ���Renyi����ֵ��q��ʱΪһ��ȡֵ���䣩��
%ÿ4s�������һ�Σ�����ʱÿ���ص�2s������qΪ����Renyiֵ�Ľ���
%average_D_inf,average_D_neginf,Renyi_entropy�ֱ�Ϊÿ�������D_inf,D_neginf,D_q��ƽ��ֵ
function [D_inf_all,D_q_0all,D_q_1all,average_D_inf,average_D_q_0,average_D_q_1]=Renyi_spectral(A,Fs,p)
%A=load(input);
Len_signal=length(A);
%Fs=256;
window_t=10;
M=length(A);
%M=Fs*window_t;                            %ÿ�μ�������г���
%slide_point=Fs*(window_t/2);  %ÿ�λ����ĵ���
slide_point=length(A);
h=0;
%h=floor((Len_signal-M)/slide_point);
for j=0:h
    Xt=A(1+j*slide_point:M+j*slide_point);
    delta_V=0.01;                      %�Ե�����豸�ľ�׼��
    X_max=max(Xt);                     %���������е�����ֵ�����������Ե��źŵ�����ѹֵ��
    X_min=min(Xt);                     %���������е���С��ֵ
    N=fix((X_max-X_min)/delta_V);           %�����źű����ֵ������� 
    Xt_axis=fix((Xt-X_min)/delta_V)+1; %�����ź���ÿ�������������ֵ
    histograms=unique(Xt_axis);
    [K,Point]=size(histograms);%%%
    P_Xt=zeros(Point,1);
    for i=1:Point
        for k=1:M
            if histograms(i)==Xt_axis(k)
               P_Xt(i)=P_Xt(i)+1;     %����ÿ����������ĵ���
            end
        end
    end
    Pxt=P_Xt./M;                      %��������еĸ��ʷֲ�
    P_max=max(Pxt);                   %����������ֵ
    P_min=min(Pxt);                   %���������Сֵ
    D_inf=log(P_max)./log(delta_V);   %���㵱q���������ʱ���õ���Renyi��ֵ
    D_neginf=log(P_min)./log(delta_V);%��q��������Сʱ���õ���Renyi��ֵ
    delta_D=D_neginf-D_inf;
    D_inf_all(j+1)=D_inf;
    D_neginf_all(j+1)=D_neginf;
    delta_D_all(j+1)=delta_D;
    q=-50:1:50;                       %����һ��q��ȡֵ��
    q_num=length(q);
    D_q=zeros(q_num,1);
    for i=1:q_num
            for k=1:Point
                %if ((q(i)~=1)&(q(i)~=0))
                   %sum_pi_q(i)=log(sum(Pxt(k).^q(i)));
                   sum_pi_q(i,k)=(Pxt(k).^q(i));
            end
                   sum_q(i)=sum(sum_pi_q(i,:));
                   if q(i)~=1
                      D_q(i)=(1./(q(i)-1))*(log(sum_q(i))./log(delta_V)); %�õ���q������1ʱ��Renyi����ֵ
                      D_q_0=D_q(51);
                   else 
                          D_q(i)=-sum(Pxt.*log(Pxt))./(log(1/delta_V));           %�õ���q����1ʱ��Renyi����ֵ�������е���ũ�� 
                          D_q_1=D_q(i);
                   end
    end
    M_D(:,j+1)=D_q;
    D_q_0all(j+1)=D_q_0;
    D_q_1all(j+1)=D_q_1;
    if p==1
    plot(q,D_q,'k-');
    xlabel('q'); ylabel('D_q'); 
    hold on;
    end
end
    average_D_inf=mean(D_inf_all);
    %average_D_neginf=mean(D_neginf_all);
    %average_delta_D=mean(delta_D_all);
    average_D_q_0=mean(D_q_0all);
    average_D_q_1=mean(D_q_1all);
    Renyi_entropy=mean(M_D');
    if p==1
    plot(q,Renyi_entropy,'r-');
    end
 
    
