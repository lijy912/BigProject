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


function feavalue = linefeatures(input)
fs=100;
feaname=[];
feavalue=[];
if isempty(input)
    return;
end
    [row,col]=size(input);

        PPmean = mean(abs(input));        %% PPmean�����ֵ��ƽ��ֵ
        meanSquare = mean(input.^2);      %% meanSquare: ����ֵ
        variance = var(input);            %% variance: ����
        [activity, mobility, complexity] = F_hjorth(input);

%%%%%%%%%%%%%%%%%%%%%%%%%   AR model   %%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%% ����Ӧ����� %%%%%%%%%%%%%%%%%%%
    maxs=zeros(1,col);
    f0=zeros(1,col);
    sumPower=zeros(1,col);
    order=zeros(1,col);
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
feaname{7}='f0';
feaname{8}='maxs';
feaname{9}='sumPower';
    feavalue(:,1) = PPmean;
    feavalue(:,2) = meanSquare;
    feavalue(:,3) = variance;
    feavalue(:,4) = activity;
    feavalue(:,5) = mobility;
    feavalue(:,6) = complexity;
    feavalue(:,7) = f0;
    feavalue(:,8) = maxs;
    feavalue(:,9) = sumPower;
    feavalue(:,10)=order;
    
     


% AR ģ�͹��ʵļ��㹫ʽ
function y=ppower(f,a,E,bestp)   %�Ӻ���

b=zeros(bestp,length(f));
for k = 1:bestp
    b(k,:) = a(k+1)*exp(-1i*2*pi*f*k);
end
y=E./(abs(1+sum(b)).^2);

       
    
    
    
    
    