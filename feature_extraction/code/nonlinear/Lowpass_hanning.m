function output=Lowpass_hanning(x,fs,fc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �ļ����ܣ�������ͨFIR�˲����������������н�С���԰�ͽϴ��˥���ٶȣ����ǽ�ȡ�ź�ʱ�������ǰ�߽�����ʧ�档
% ���з�ʽ������output=Lowpass_hanning(x,fs,fc)��fcΪ�˲�������Ƶ�ʱ߽磬fsΪ����Ƶ�ʣ�xΪ�˲����������źţ����Ϊoutput��
%�˳���ǰ�����ݻ�����ʧ�棬�����0.05s���ҵ�ʧ�棬�����Ѿ����㣬���ݳ�����ԭʼ���ݱ���һ�¡�
%% @(#)$Id: Lowpass_hanning.m 2010.10.14 Yanbing Qi Exp $ 0.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check input signal
[a_1,b_1]=size(x);
if b_1==1 && b_1<a_1
    x=x';
end
if a_1~=1 && b_1~=1
    error('MATLAB:mark_EOG:Inputmatrixisnotreliable',...
              'Input matrix is not a one - dimensional array.  See mark_EOG.');
end
% tic
% b(n)�г�ΪM ԼΪ501���ź�Ϊx
seg_len = 256; %seg Ϊԭʼ�źŷֶγ���ӦΪ��λ�����Ӧһ���������� 
len = length(x);
wp=2*fc/fs;
N=500;    %ͨ���߽�Ƶ�ʣ���һ��Ƶ�ʣ����˲�������
b=fir1(N,wp,hanning(N+1));           %���FIR��ͨ�˲���
M = length(b);
flo = floor(len/seg_len)-1;
L = seg_len+M-1;
output = zeros(1,(flo+2)*seg_len);
t=zeros(1,M-1);
for i = 0:1:flo+1
    if i ~= flo+1
        y = x(seg_len*i+1:(i+1)*seg_len);
    else
        y_1 = x(seg_len*(flo+1):end);
        y =[y_1,zeros(1,seg_len-length(y_1))];
    end

%     y=[y,zeros(1,L-256)];
%     b=[b,zeros(1,L-M)];
    z = conv(b,y);
    z(1:M-1) = z(1:M-1) + t(1:M-1);
    t(1:M-1) = z(seg_len+1:L);
    output1(seg_len*i+1:(i+1)*seg_len) = z(1:seg_len);
end

start_t = floor((N)/2);
output2 = output1(start_t:end);

if len>length(output2)
    output= [output2,zeros(1,len-length(output2))];
else
    output=output2(1:len);
end
% toc





