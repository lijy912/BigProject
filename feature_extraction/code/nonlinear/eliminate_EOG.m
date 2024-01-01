function de_noise_EEG=eliminate_EOG(x,fs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%文件功能： 根据选取相应EEG的被眨眼信号和幅值较大的眼电信号污染的区域，去除眼电。
% x-> input singal with EOG
% fs->为采样率
% n-> 选取阈值，取值为1,2,3. 分别代表阈值取值由小到大,默认为2
% p-> 可以选择是否画图，p∈[0,1];0（默认）表示不画图；1为画出原始信号和标记出的眼电污染区域；
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
mean_x=sum(abs(x))/length(x);  %信号的均值
std_variance=std(x);           %信号的标准差
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
