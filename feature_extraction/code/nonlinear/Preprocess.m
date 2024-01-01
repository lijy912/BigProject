function  Preprocess
%PREPROCESS Summary of this function goes here
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %dir_in=('D:\Documents\MATLAB\'); %�������޸���ݴ�ŵ�·��
    dir_in=('/home/uais_2/unfilterd eeg data/2/');
    dir_out1=('/home/uais_2/unfilterd eeg data/');               %��������·��
    list=dir([dir_in '*.mat']);              %���ļ�
    n=length(list);

for j=1:n
   dir_out=dir_out1;
    str=[dir_in list(j).name];
    load(str);
    disp('Loading data');
    dirn=[dir_out 'Preprocessed/' list(j).name];
   if ~isdir(dirn)
     mkdir(dirn);
    end
      paths=[dirn,'/'];
      
 %%%%%%%%%%%%%%%%%%%%%%%
%����Text_Segment
 %%%%%%%%%%%%%%%%%%%%%%%     
      
for i=1:4
    str_val = ['Text_Segment',num2str(i)];
    temp = eval(str_val);                       %����Text_Segment(i)
  Temp=zeros(128,length(temp));                  %��ʼ��Temp
  disp('Processing ');
    
    for k=1:128                               %���д���ÿһ�������?
        x=temp(k,:);
        
        output=adaptdenoise_lms(x,250);         %ȥ50hz��Ƶ
    
      z=FIR_hanning(output,250,1,40);           %�����˲�1hz��40hz
     
     de_noise_EEG=eliminate_EOG(z,250);         %ȥ�۵�
     
       
         Temp(k,:)=de_noise_EEG;   %��һ�д���������д��Temp��
    
    end
    
  dir_out=[paths,str_val];                      %������ļ�?��D:\Documents\MATLAB\Preprocessed\list(j).name\Text_Segment(i).mat
    save(dir_out,'Temp');
   
   
     
end



%%%%%%%%%%%%%%%%%%%%%%%
%����Exp_Image_Segment
%%%%%%%%%%%%%%%%%%%%%%%

for i=1:15
    str_val = ['Exp_Image_Segment',num2str(i)];
    temp = eval(str_val);
  Temp=zeros(128,length(temp));
  disp('Processing:');
  disp(str_val);%������ע�͵���ֻ��Ϊ�˿�����ȡ�?
    
    for k=1:128
        x=temp(k,[1:1500]);
        
        output=adaptdenoise_lms(x,250);
    
      z=FIR_hanning(output,250,1,40);
     
     de_noise_EEG=eliminate_EOG(z,250);
     
        % temp=[temp;de_noise_EEG];
         Temp(k,:)=de_noise_EEG;%
    
    end
    
  dir_out=[paths,str_val];
    save(dir_out,'Temp');
   
     
     
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
    
  dir_out=[paths,str_val];
    save(dir_out,'Temp');
   
     
     
end
%%%%%%%%%%%%%%%%%%%%%%%%
%����Video_Image_Segment
%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:1:6
    str_val = ['Video_Segment',num2str(i)];%ѭ������ÿ��Video_Segment,1-6
    temp = eval(str_val);
  Temp=zeros(128,length(temp));
  disp('Processing:');
  disp(str_val);%������ע�͵���ֻ��Ϊ�˿�����ȡ�?
    
    for k=1:1:128
        x=temp(k,:);%���д��?д��Temp������
        
        output=adaptdenoise_lms(x,250);
    
      z=FIR_hanning(output,250,1,40);
     
     de_noise_EEG=eliminate_EOG(z,250);
     
        % temp=[temp;de_noise_EEG];
         Temp(k,:)=de_noise_EEG;%
    
    end
    
  dir_out=[paths,str_val];%д���ļ���·��Ϊ D:\Documents\MATLAB\Preprocessed\list.name(ÿ���˵���ݵ�����?\
  
    save(dir_out,'Temp');
   
    
     
end

end
