% function Ckm=CK(data,m,N,tau)
% ss=20;
% C=zeros(1,ss);
% M=N-(m-1)*tau;%��ռ�ÿһά���еĳ���
% d=zeros(M-1,M);
% Y=reconstitution(data,N,m,tau);%�ع���ռ�
%     for i=1:M-1
%        for j=i+1:M
%          d(i,j)=norm((Y(:,i)-Y(:,j)),2);
%        end     %����״̬�ռ���ÿ����֮��ľ���
%     end
%     max_d=max(max(d));% �õ����е�֮���������
%     min_d=min(min(d));%�õ����е�����̾���
%     delt=(max_d-min_d)/ss;% �õ�r�Ĳ���
%     %for k=1:ss
%         r=min_d+7*delt;
%         H=length(find(r>d))';
%         C=2*H/(M*(M-1));
%         Ckm=C-1;
%     %end

function Ckm = CK(data, m, N, tau)
    ss = 20;
    C = zeros(1, ss);
    M = N - (m - 1) * tau; % ��ռ�ÿһά���еĳ���
    d = zeros(M - 1, M);
    Y = reconstitution(data, N, m, tau); % �ع���ռ�
    max_d = max(max(d)); % �õ����е�֮���������
    min_d = min(min(d)); % �õ����е�����̾���
    delt = (max_d - min_d) / ss; % �õ�r�Ĳ���
    
    for k = 1:ss
        r = min_d + 7 * delt;
        H = length(find(d > r))';
        C(k) = 2 * H / (M * (M - 1));
    end

    Ckm = C - 1;
end
