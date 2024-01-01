%%%%%%%%%%%%%%%%%%%%%%%%% F_allfeatures.m %%%%%%%%%%%%%%%%%%%%%%%%
%% ���ܣ�������ӦARģ�ͼ��������ʱ���Ƶ�������
%%
%% ������features = F_allfeatures(fs,input)
%%      fs��������
%%      input������ľ�������Ϊ�������
%% 
%%
%% ���λ�ȡ��������PPmean�����ֵ��ƽ��ֵ
%%                meanSquare��������
%%                variance������
%%                f0: ȡ��������ܶ�ʱ��Ƶ��
%%                MaxPower����������ܶ�
%%                SumPower���ܹ���
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function feavalue = linefeatures(input) %input��һ���缫��һ��ʱ��Ƭ���ڵ�����
fs=250;
feaname=[];
feavalue=[];
if isempty(input)
    return;
end
    [row,col]=size(input); %ʱ��Ƭ��X1��300X1�� row=300��col=1

        %PPmean = mean(abs(input));        %% PPmean�����ֵ��ƽ��ֵ
        maxSignalValue=max(max(input));         %input���е����ֵ
        minSignalValue=max(min(input));         %input���е���Сֵ
        PPmean=(max(input)-min(input))/2;  %% ���岨�ȵ�ƽ��ֵ
        meanSquare = mean(input.^2);      %% meanSquare: ����ֵ
        variance = var(input);            %% variance: ����
        [activity, mobility, complexity] = F_hjorth(input);
        [x,y]=find(input==maxSignalValue);    %���ֵ���ֵ�λ���ǵ�x�е�y�У�����y��Զ����1����Ϊֻ��һ��
        
%         LAT=(124+x)*4;           %Ǳ����,��ERPʱ�䴰�ڳ�������ź�ֵʱ��ʱ��
%         AMP=maxSignalValue; %ERPʱ�䴰������ź�ֵ
%         LAR=LAT/AMP; %Ǳ����/������ֵ
%         AAMP=abs(AMP);% �����ľ���ֵ
%         ALAR= abs(LAT/AMP); %Ǳ����/������ֵ�ľ���ֵ
%         
%         %�������
%         PAR=0;%�����,��P100��P300��ʱ�䴰�ڣ����з�ֵΪ��ʱֵ���ܺ�
%             for index=1:size(input,1)
%                 if input(index,1)>=0
%                    PAR=PAR+ input(index,1);
%                 end
%             end
%         %�����end
%         
%         %�����
%         NAR=0; %�����,��P100��P300��ʱ�䴰�ڣ����з�ֵΪ��ʱֵ���ܺͣ�
%             for index=1:size(input,1)
%                 if input(index,1)<0
%                    NAR=NAR+ input(index,1);
%                 end
%             end
%         %�����end
%         
%         %������������+�����
%         TAR=PAR+NAR;
%         %�����end
%%%%%%%%%%%%%%%%%%%%%%%%%   AR model   %%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%% ����Ӧ����� %%%%%%%%%%%%%%%%%%%
    maxs=zeros(1,col);%1X1�������zeros��ʾ����0����
    f0=zeros(1,col);%1X1�������zeros��ʾ����0����
    sumPower=zeros(1,col);%1X1�������zeros��ʾ����0����
    order=zeros(1,col);%1X1�������zeros��ʾ����0����
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
%         maxs = maxs_temp;         %% maxs����������ܶ�
%         f0 = fs*(kk-1)/row;        %% f0: ȡ��������ܶ�ʱ��Ƶ��
%        sumPower(ii+1) = sum(s);        %% sumPower���ܹ���
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
    
     


% AR ģ�͹��ʵļ��㹫ʽ
function y=ppower(f,a,E,bestp)   %�Ӻ���

b=zeros(bestp,length(f));
for k = 1:bestp
    b(k,:) = a(k+1)*exp(-1i*2*pi*f*k);
end
y=E./(abs(1+sum(b)).^2);

       
    
    
    
    
    