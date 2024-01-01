function  Pic_Preprocess
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dir_in=('D:\data\�Ե�����\unfilterd EEG data\2\');
dir_out1=('C:\Documents and Settings\Administrator\����\slor\');               %��������·��
list=dir([dir_in '*.mat']);              %���ļ�
n=length(list);

for j=1:n
    dir_out=dir_out1;
    str=[dir_in list(j).name];
    load(str);
    disp('Loading data');
    dirn=[dir_out 'Pic_Preprocessed\' list(j).name];
    if ~isdir(dirn)
        mkdir(dirn);
    end
    paths=[dirn,'\'];
    
    
    
    for i=1:15
        str_val = ['Exp_Image_Segment',num2str(i)];
        temp = eval(str_val);
        Temp=zeros(128,length(temp));
        disp('Processing:');
        disp(str_val);%������ע�͵���ֻ��Ϊ�˿�����ȡ�?
        
        for k=1:128
            x=temp(k,:);
            
            output=adaptdenoise_lms(x,250);
            
            z=FIR_hanning(output,250,1,40);
            
            de_noise_EEG=eliminate_EOG(z,250);
            
            % temp=[temp;de_noise_EEG];
            Temp(k,:)=de_noise_EEG;%
            
        end
        
        dir_out=[paths,str_val];
        save(dir_out,'Temp');
        save ()
        
        
        
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    %����Sil_Image_Segment
    %%%%%%%%%%%%%%%%%%%%%%%%
    
    for i=1:15
        str_val =['Sil_Image_Segment',num2str(i)];
        temp = eval(str_val);
        Temp=zeros(128,length(temp));
        disp('Processing:');
        disp(str_val);%������ע�͵���ֻ��Ϊ�˿�����ȡ�?
        
        for k=1:128
            x=temp(k,:);
            
            output=adaptdenoise_lms(x,250);
            
            z=FIR_hanning(output,250,1,40);
            
            de_noise_EEG=eliminate_EOG(z,250);
            
            % temp=[temp;de_noise_EEG];
            Temp(k,:)=de_noise_EEG;%
            
        end
        
        %dir_out=[paths,str_val];
        save(paths,[str_val,'.txt'],-ascii, 'Temp' );
        
        
        
    end
    
end
end

