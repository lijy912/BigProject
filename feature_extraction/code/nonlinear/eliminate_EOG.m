function de_noise_EEG=eliminate_EOG(x,fs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�ļ����ܣ� ����ѡȡ��ӦEEG�ı�գ���źźͷ�ֵ�ϴ���۵��ź���Ⱦ������ȥ���۵硣
% x-> input singal with EOG
% fs->Ϊ������
% n-> ѡȡ��ֵ��ȡֵΪ1,2,3. �ֱ������ֵȡֵ��С����,Ĭ��Ϊ2
% p-> ����ѡ���Ƿ�ͼ��p��[0,1];0��Ĭ�ϣ���ʾ����ͼ��1Ϊ����ԭʼ�źźͱ�ǳ����۵���Ⱦ����
%% @(#)$Id: eliminate_EOG.m 2010.6,18 Yanbing Qi Exp $
%% @(#)$Id: eliminate_EOG.m 2010.7,16 Yanbing Qi Exp $
%% @(#)$Id: eliminate_EOG.m 2010.12,23 11:52:23 Yanbing Qi Exp $
%$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Check inputs
  if nargin < 4
    p=0;
    if nargin < 3
      n=2;
      if nargin < 2
        error('MATLAB:eliminate_EOG:NotEnoughInputs',...
              'Not enough input arguments.  See eliminate_EOG.');
      end  
    end
  end


% check input signal
[a_1,b_1]=size(x);
if b_1==1 && b_1<a_1
    x=x';
end
if a_1~=1 && b_1~=1
    error('MATLAB:eliminate_EOG:Inputmatrixisnotreliable',...
              'Input matrix is not a one - dimensional array.  See eliminate_EOG.');
end
de_noise_EEG=x;
mean_x=sum(abs(x))/length(x);  %�źŵľ�ֵ
std_variance=std(x);           %�źŵı�׼��
% mark the OA zone
[OA_zone,count]=mark_EOG(x,fs);
if count==0
    return;
end
Con_EEG=OA_zone.*x;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%delect EOG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

threshold(1)=abs(std_variance-0.5*mean_x);
threshold(2)=abs(3.5*std_variance-0.5*mean_x);
threshold(3)=abs(2.5*std_variance-mean_x);
THTR=threshold(n);
N=0;
sum_1=0;
for i=1:length(Con_EEG)
    if Con_EEG(i)~=0
        N=N+1;
        sum_1=sum_1+abs(Con_EEG(1,i));
    end
end
mean_E=sum_1/N;  %The mean of contaminated EEG 

if mean_E < 3*mean_x
    XC=wdencmp('gbl',Con_EEG,'db7',7,THTR,'h',0);
else
    XC=wdencmp('gbl',Con_EEG,'db7',7,THTR,'s',0);
end
de_noise_EEG=x-XC;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot function
% if p==1
%     figure;plot(x);hold on;
%     plot(de_noise_EEG,'r');xlabel('point number'),ylabel('Amplitude');
%     legend('EEG with ocular artifacts','Corrected EEG');
%     hold off;
% end
