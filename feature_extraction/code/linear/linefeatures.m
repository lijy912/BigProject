%%%%%%%%%%%%%%%%%%%%%%%%% F_allfeatures.m %%%%%%%%%%%%%%%%%%%%%%%%
%% 功能：用自适应AR模型计算出所有时域和频域的特征
%%
%% 函数：features = F_allfeatures(fs,input)
%%      fs：采样率
%%      input：输入的矩阵，以列为处理对象
%% 
%%
%% 依次获取的特征：PPmean：峰峰值的平均值
%%                meanSquare：均方差
%%                variance：方差
%%                f0: 取得最大功率密度时的频率
%%                MaxPower：最大功率谱密度
%%                SumPower：总功率
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function feavalue = linefeatures(input) %input是一个电极在一个时间片段内的数据
fs=250;
feaname=[];
feavalue=[];
if isempty(input)
    return;
end
    [row,col]=size(input); %时间片数X1（300X1） row=300，col=1

        %PPmean = mean(abs(input));        %% PPmean：峰峰值的平均值
        maxSignalValue=max(max(input));         %input列中的最大值
        minSignalValue=max(min(input));         %input列中的最小值
        PPmean=(max(input)-min(input))/2;  %% 波峰波谷的平均值
        meanSquare = mean(input.^2);      %% meanSquare: 均方值
        variance = var(input);            %% variance: 方差
        [activity, mobility, complexity] = F_hjorth(input);
        [x,y]=find(input==maxSignalValue);    %最大值出现的位置是第x行第y列，其中y永远等于1，因为只有一列
        
%         LAT=(124+x)*4;           %潜伏期,在ERP时间窗内出现最大信号值时的时间
%         AMP=maxSignalValue; %ERP时间窗内最大信号值
%         LAR=LAT/AMP; %潜伏期/波幅比值
%         AAMP=abs(AMP);% 波幅的绝对值
%         ALAR= abs(LAT/AMP); %潜伏期/波幅比值的绝对值
%         
%         %求正面积
%         PAR=0;%正面积,在P100和P300的时间窗内，所有幅值为正时值的总和
%             for index=1:size(input,1)
%                 if input(index,1)>=0
%                    PAR=PAR+ input(index,1);
%                 end
%             end
%         %正面积end
%         
%         %求负面积
%         NAR=0; %负面积,在P100和P300的时间窗内，所有幅值为负时值的总和：
%             for index=1:size(input,1)
%                 if input(index,1)<0
%                    NAR=NAR+ input(index,1);
%                 end
%             end
%         %负面积end
%         
%         %总面积，正面积+负面积
%         TAR=PAR+NAR;
%         %总面积end
%%%%%%%%%%%%%%%%%%%%%%%%%   AR model   %%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%% 自适应求阶数 %%%%%%%%%%%%%%%%%%%
    maxs=zeros(1,col);%1X1的零矩阵，zeros表示生成0矩阵
    f0=zeros(1,col);%1X1的零矩阵，zeros表示生成0矩阵
    sumPower=zeros(1,col);%1X1的零矩阵，zeros表示生成0矩阵
    order=zeros(1,col);%1X1的零矩阵，zeros表示生成0矩阵
     for i=1:col
         AIC=zeros(1,floor(sqrt(row)));
        for p = 1:sqrt(row)
            [~,E] = aryule(input(:,i),p);
            %  FPE(p) = E*( (N+p+1)/(N-p+1) );
            AIC(p) = log(E)+2*p/row;
            %  BIC(p) = log(E)+p*(log(N)/N);
        end
        [~, bestp] = min(AIC);
%        disp(num2str(bestp));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [a,E] = aryule(input(:,i),bestp);
        f=0:0.01/fs:0.5;
        power=ppower(f,a,E,bestp);
        [v,ff]=max(power);
%        [ff,v]=fminbnd(@(f) -ppower(f,a,E,bestp),0,0.5);
        maxs(i)=v;
        f0(i)=(ff-1)*0.01;
        sumPower(i)=(sum(power)-power(1)/2-power(length(power))/2)*0.01/fs;
        order(i)=bestp;
%        sumPower(i)=quad(@(f) ppower(f,a,E,bestp),0,0.5);
%         f=linspace(0,0.5,row);
%         ft=fs*f;
%         y=ppower(f,a,E,bestp);
%         plot(ft,y)
     end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%%%%  FFT  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         s = abs(fft(input)).^2/row;
%         [maxs_temp,kk]=max(s);
%         maxs = maxs_temp;         %% maxs：最大功率谱密度
%         f0 = fs*(kk-1)/row;        %% f0: 取得最大功率密度时的频率
%        sumPower(ii+1) = sum(s);        %% sumPower：总功率
%        f=fs*(0:255)/row;
%        figure(2);
%        plot(f,s(1:256));
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% feavalue=0;
feaname{1}='PPmean';
feaname{2}='meanSquare';
feaname{3}='variance';
feaname{4}='activity';
feaname{5}='mobility';
feaname{6}='complexity';
% feaname{7}='f0';
feaname{7}='maxs';
feaname{8}='sumPower';


% feaname{9}='LAT';
% feaname{10}='AMP';
% feaname{11}='LAR';
% feaname{12}='AAMP';
% feaname{13}='ALAR';
% feaname{14}='PAR';
% feaname{15}='NAR';
% feaname{16}='TAR';

    feavalue(:,1) = PPmean;
    feavalue(:,2) = meanSquare;
    feavalue(:,3) = variance;
    feavalue(:,4) = activity;
    feavalue(:,5) = mobility;
    feavalue(:,6) = complexity;
%     feavalue(:,7) = f0;
    feavalue(:,7) = maxs;
    feavalue(:,8) = sumPower;
%     feavalue(:,9) =LAT;
%     feavalue(:,10) =AMP;
%     feavalue(:,11) =LAR;
%     feavalue(:,12) =AAMP;
%     feavalue(:,13) =ALAR;
%     feavalue(:,14) =PAR;
%     feavalue(:,15) =NAR;
%     feavalue(:,16) =TAR;
%     feavalue(:,10)=order;
    
     


% AR 模型功率的计算公式
function y=ppower(f,a,E,bestp)   %子函数

b=zeros(bestp,length(f));
for k = 1:bestp
    b(k,:) = a(k+1)*exp(-1i*2*pi*f*k);
end
y=E./(abs(1+sum(b)).^2);

       
    
    
    
    
    