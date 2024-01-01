function z=adaptdenoise_lms(d,fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����Ӧ����������,�����Ե��ź��еĹ�Ƶ����,������С������LMS���㷨
% dΪҪ����ĺ������ź�
% fsΪ�źŵĲ�����
% z����������źţ���������Ƶ��������ź�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% writed by SQX 2011.05.21 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check inputs
  
      if nargin < 2
        error('MATLAB:eliminate_EOG:NotEnoughInputs',...
              'Not enough input arguments.  See eliminate_EOG.');
      end  

  
u=0.00002; % ����
c=2.8; % �ο��źŵķ�ֵϵ��
N=length(d);
n=1:N;
fai=pi/3;
v1=c*cos(2*pi*50*n/fs+fai);
v2=c*sin(2*pi*50*n/fs+fai); % v1��v2ΪLMS�㷨�Ĳο�����
%k=100; % kΪ��������
m=70; % mΪ�˲�������
y=zeros(1,N); % �˲��������
y(1:m-1)=d(1:m-1);
w1=zeros(m,1); % ��һ·Ȩϵ��
w2=zeros(m,1); % �ڶ�·Ȩϵ��
e=zeros(1,N); % �������
e(1:m-1)=d(1:m-1);
%E=zeros(k,N); % ������
% LMS������ʼ

for i=m:N
    y1(i)=v1((i-m+1):i)*w1;
    y2(i)=v2((i-m+1):i)*w2;
    y(i)=y1(i)+y2(i);
    e(i)=d(i)-y(i);
    w1=w1+(2*u*e(i)*v1((i-m+1):i))';
    w2=w2+(2*u*e(i)*v2((i-m+1):i))';
end

z=e; % ���Ϊ����źż�ȥ��Ƶ����������Ҫ�Ĵ����ź�

% ��ͼ
% subplot(311);plot(d);title('ԭʼ�����ź�ʱ����');
% subplot(312);plot(y);title('�˲�������ź�ʱ����');
% subplot(313);plot(z);title('�˲����ź�ʱ����');
% figure;
% subplot(311);plot_fre(fs,d,'r');title('ԭʼ�����ź�Ƶ��ͼ');
% subplot(312);plot_fre(fs,y,'r');title('�˲�������ź�Ƶ��ͼ');
% subplot(313);plot_fre(fs,z,'r');title('�˲����ź�Ƶ��ͼ');
% figure;
% subplot(321);plot(d);title('ԭʼ�����ź�ʱ����');subplot(322);plot_fre(fs,d,'r');title('ԭʼ�����ź�Ƶ��ͼ');
% subplot(323);plot(y);title('�˲�������ź�ʱ����');subplot(324);plot_fre(fs,y,'r');title('�˲�������ź�Ƶ��ͼ');
% subplot(325);plot(z);title('�˲����ź�ʱ����');subplot(326);plot_fre(fs,z,'r');title('�˲����ź�Ƶ��ͼ');
% figure;
% plot_fre(fs,d,'b'),hold on;plot_fre(fs,z,'r');title('�˲�ǰ���ź�Ƶ��Ƚ�');legend('ԭʼ����Ƶ�����źŵ�Ƶ��','������Ƶ�������źŵ�Ƶ��');
