%%%%%%%%%%%%%%%%%%%%%%%%% F_allfeatures.m %%%%%%%%%%%%%%%%%%%%%%%%
%% ���ܣ�������ӦARģ�ͼ��������ʱ���Ƶ�������
%%
%% ����features = F_allfeatures(fs,input,onetime,overlap)
%%      fs��������
%%      input��output����������ļ���·��
%%      onetime:һ�μ��������һ��ȡ1~4s
%%
%% ���λ�ȡ��������PPmean�����ֵ��ƽ��ֵ
%%                meanSquare�����
%%                variance������
%%                f0: ȡ��������ܶ�ʱ��Ƶ��
%%                Max Power����������ܶ�
%%                Sum Power���ܹ���
%%
%% ���ߣ���ȪӰ
%% ����޸�ʱ�䣺2010.07.23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function features = F_allfeatures(input)
fs = 250;   %������
%N = fs*onetime;   %��ȡ��һ�μ���ĵ���
onetime=0;
overlap=0;
N=length(input);
Xt = input;
Len = length(Xt);
ii = 0;
flag=0;
while flag+N <= Len
    Xt_ii = Xt( (flag+1):(flag+N) );
    PPmean(ii+1) = mean(abs(Xt_ii));        %% PPmean�����ֵ��ƽ��ֵ
    meanSquare(ii+1) = mean((Xt_ii)'*(Xt_ii)); %% meanSquare: ��ֵ
    variance(ii+1) = var(Xt_ii);            %% variance: ����
    [activity(ii+1), mobility(ii+1), complexity(ii+1)] = F_hjorth(Xt_ii);
    %%%%%%%%%%%%%%%%%%%%%%%%%   AR model   %%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%% ����Ӧ����� %%%%%%%%%%%%%%%%%%%
    temp = 0;
    for p = [1:sqrt(N)]
        [a,E] = aryule(Xt_ii,p);
        %  FPE(p) = E*( (N+p+1)/(N-p+1) );
        AIC(p) = log(E)+2*p/N;
        %  BIC(p) = log(E)+p*(log(N)/N);
    end
    [minA bestp] = min(AIC);
    % disp(num2str(bestp));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [a,E] = aryule(Xt_ii,bestp);
    
    f = 0:pi/N:0.5;
    b = 0;
    for k = [1:bestp]
        b = b+a(k+1)*exp(-j*2*pi*f*k);
    end;
    s = E./( ( abs(1+b) ).^2 );
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    maxs_temp = s(1);
    kk = 0;
    for k = [1:length(s)]
        if s(k)>maxs_temp
            maxs_temp = s(k);
            kk = k;
        end
    end
    if kk==0
        kk=1;
    end
    maxs(ii+1) = maxs_temp;         %% maxs����������ܶ�
    f0(ii+1) = fs*(kk-1)*pi/N;        %% f0: ȡ��������ܶ�ʱ��Ƶ��
    sumPower(ii+1) = sum(s);        %% sumPower���ܹ���
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % %%%%%%%%%%%%%%%%%%%%%%%  FFT  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %         s = abs(fft(Xt_ii)).^2/N;
    %         maxs_temp = s(1);
    %         kk = 0;
    %         for k = [1:N/2]
    %             if s(k)>maxs_temp
    %                 maxs_temp = s(k);
    %                 kk = k;
    %             end
    %         end
    %         if kk==0
    %             kk=1;
    %         end
    %         maxs(ii+1) = maxs_temp;         %% maxs����������ܶ�
    %         f0(ii+1) = fs*(kk-1)/(N);        %% f0: ȡ��������ܶ�ʱ��Ƶ��
    %         sumPower(ii+1) = sum(s);        %% sumPower���ܹ���
    %
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ii = ii+1;
    flag = flag+(onetime-overlap)*fs;
    Num_feature = ii;
end

features(:,1) = PPmean;
features(:,2) = meanSquare;
features(:,3) = variance;
features(:,4) = activity;
features(:,5) = mobility;
features(:,6) = complexity;
features(:,7) = f0;
features(:,8) = maxs;
features(:,9) = sumPower;









