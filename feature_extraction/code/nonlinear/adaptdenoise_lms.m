function z=adaptdenoise_lms(d,fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 自适应噪声抵消器,消除脑电信号中的工频噪声,采用最小均方误差（LMS）算法
% d为要处理的含噪声信号
% fs为信号的采样率
% z函数的输出信号，是消除工频噪声后的信号
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% writed by SQX 2011.05.21 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check inputs
  
      if nargin < 2
        error('MATLAB:eliminate_EOG:NotEnoughInputs',...
              'Not enough input arguments.  See eliminate_EOG.');
      end  

  
u=0.00002; % 步长
c=2.8; % 参考信号的幅值系数
N=length(d);
n=1:N;
fai=pi/3;
v1=c*cos(2*pi*50*n/fs+fai);
v2=c*sin(2*pi*50*n/fs+fai); % v1、v2为LMS算法的参考输入
%k=100; % k为迭代次数
m=70; % m为滤波器长度
y=zeros(1,N); % 滤波器的输出
y(1:m-1)=d(1:m-1);
w1=zeros(m,1); % 第一路权系数
w2=zeros(m,1); % 第二路权系数
e=zeros(1,N); % 误差向量
e(1:m-1)=d(1:m-1);
%E=zeros(k,N); % 误差矩阵
% LMS迭代开始

for i=m:N
    y1(i)=v1((i-m+1):i)*w1;
    y2(i)=v2((i-m+1):i)*w2;
    y(i)=y1(i)+y2(i);
    e(i)=d(i)-y(i);
    w1=w1+(2*u*e(i)*v1((i-m+1):i))';
    w2=w2+(2*u*e(i)*v2((i-m+1):i))';
end

z=e; % 误差为混合信号减去工频噪声，即所要的纯净信号

% 画图
% subplot(311);plot(d);title('原始输入信号时域波形');
% subplot(312);plot(y);title('滤波器输出信号时域波形');
% subplot(313);plot(z);title('滤波后信号时域波形');
% figure;
% subplot(311);plot_fre(fs,d,'r');title('原始输入信号频域图');
% subplot(312);plot_fre(fs,y,'r');title('滤波器输出信号频域图');
% subplot(313);plot_fre(fs,z,'r');title('滤波后信号频域图');
% figure;
% subplot(321);plot(d);title('原始输入信号时域波形');subplot(322);plot_fre(fs,d,'r');title('原始输入信号频域图');
% subplot(323);plot(y);title('滤波器输出信号时域波形');subplot(324);plot_fre(fs,y,'r');title('滤波器输出信号频域图');
% subplot(325);plot(z);title('滤波后信号时域波形');subplot(326);plot_fre(fs,z,'r');title('滤波后信号频域图');
% figure;
% plot_fre(fs,d,'b'),hold on;plot_fre(fs,z,'r');title('滤波前后信号频域比较');legend('原始带工频噪声信号的频谱','消除工频噪声后信号的频谱');
