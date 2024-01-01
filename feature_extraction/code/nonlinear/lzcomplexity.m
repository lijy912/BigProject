%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ��Ŀ��LZ���Ӷ��㷨
%   ���ߣ��Ծ�γ
%   ���ڣ�2010���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LZC=lzcomplexity(inputpath)
MChannel=1;
filenum=1;
%Window_point=1024;
Window_point=length(inputpath);
shift=round(Window_point/2);
CN=zeros(filenum,MChannel);
ifn=1;
%for ifn=1:filenum
   clear data N eegX eegC_01;
  % data_all = load(inputpath);
%     load(inputpath);
     data_all=inputpath;
    for part=0:(floor((length(data_all)-Window_point)/shift))
        data = data_all((part*shift+1):(part*shift+Window_point));
       % disp(['this is part:' int2str(part)]);
        [a,N]=size(data);
       % N=floor(N/MChannel);
        eegX=zeros(MChannel,N-2);
        %eegX��¼ԭʼ��ݣ�������ʾ��ͨ�����
        for i=1:N-2
            for j=1:MChannel
                eegX(j,i)=data((i-1)*MChannel+j);
            end;
        end;
        %һ�¿�ʼ��eegX�����������ӷ���
        %��eegX 0 1 ��������ƽ��ֵΪ1��С��ƽ��ֵΪ0
        for j=1:MChannel
            meanch=mean(eegX(j,:));
            for i=1:N-2
                if eegX(j,i)>=meanch
                    eegX_01(j,i)=1;
                else
                    eegX_01(j,i)=0;
                end
            end;
        end;
        for iCh=1:MChannel%��iCHͨ�����з���
            clear Rem_str C_str;
            C_str=eegX_01(iCh,:);
            Now_num=0;%�ַ����
            [X,length_str]=size(C_str);
            Rem_str=[0 0];
            begin=1;
            i=1;
            str_equal=0;
            while i<length_str
                %�������ַ��в����Ƿ��ظ�
                %Rem_strÿһ�б�ʾһ���ַ���һ�б�ʾ�ַ�ĸ���
                for j=1:Now_num
                    str_equal=1;
                   % disp(['this is Now_num:' int2str(Now_num)]);
                    %�Ƚ�C_str��Rem_str�е��ַ�ĳ��ȣ���������ñȽ�
                    if i-begin+1~=Rem_str(j,1)
                        str_equal=0;
                        break;
                    end
                    %�Ƚϳ�����ȵ�C_str��Rem_str�е��ַ�
                    for k=1:Rem_str(j,1)
                        if C_str(begin+k-1)~=Rem_str(j,k+1)%�������������һ���ַ�
                            str_equal=0;
                            break;
                        end
                    end
                    if str_equal==1%����ҵ�
                        break;
                    end
                end
                if str_equal==1%����ҵ�
                    i=i+1;
                else
                    %�����û���ҵ����ַ���뵽Rem_str�У��ȿ�����ַ��ǲ���SQpi���Ӽ�
                    for k=1:i-1-(i-begin+1)
                        str_equal=1;
                        for cmpk=1:i-begin+1
                            if C_str(k+cmpk-1)~=C_str(begin+cmpk-1)%�������������һ���ַ�
                                str_equal=0;
                                break;
                            end
                        end
                        if str_equal==1
                            break;
                        end
                    end
                    if str_equal==1%�������ַ���SQ���Ӽ�
                        i=i+1;
                    else
                        Now_num=Now_num+1;
                        Rem_str(Now_num,1)=i-begin+1;
                        for kk=begin:i
                            Rem_str(Now_num,kk-begin+2)=C_str(kk);
                        end
                        i=i+1;
                        begin=i;
                    end
                end
            end
            if begin<=length_str
                %�����û���ҵ����ַ���뵽Rem_str��
                Now_num=Now_num+1;
                Rem_str(Now_num,1)=i-begin+1;
                for kk=begin:i
                    Rem_str(Now_num,kk-begin+2)=C_str(kk);
                end
                i=i+1;
                begin=i;
            end
            %�ַ����Now_num���Ǹ��Ӷ�
            Num_all(ifn,iCh)=Now_num;%*log2(length_str)/length_str;
            %CN(ifn,iCh)=CN(ifn,iCh)+Now_num*log2(length_str)/length_str; 
            CN(ifn,iCh)=Now_num*log2(length_str)/length_str;
        end  
        LZC(part+1)=  CN(ifn,iCh);
    end
    
    
   % CN(ifn,iCh)=CN(ifn,iCh)/(floor((length(data_all)-Window_point)/shift));
%end
%disp(CN);end
