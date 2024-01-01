function  restPreprocess
dir_in=('E:\静息态数据\静息态数据（.mat格式）\restjing\');
dir_out=('E:\静息态数据\');

list=dir([dir_in '*.mat']);              
n=length(list);

for j=1:n
    disp(['sub' num2str(j)]);
    str=[dir_in list(j).name];
    load(str)
    Data=load(str);         %Data为结构体
    disp('Loading data');
    dirn=[dir_out 'Preprocessed\'];
    if ~isdir(dirn)
        mkdir(dirn);
    end
    paths=dirn;
    
    %%%%%%%%%%%%%%%%%%%%%%%
    %Rest Data
    %%%%%%%%%%%%%%%%%%%%%%%
        Data1=fieldnames(Data);  %获取结构体字段名称
        temp=eval(Data1{1});     %获取静息态脑电数据
        Temp=zeros(128,70000);
        disp('Processing:');
        disp(str);
        
        for k=1:128
            disp(['electrode' num2str(k)]);
            x=temp(k,:);
            
            output=adaptdenoise_lms(x,250); 
            z=FIR_hanning(output,250,1,40);
            z=z(:,[5000:74999]);
            de_noise_EEG=eliminate_EOG(z,250);
            
            % temp=[temp;de_noise_EEG];
            Temp(k,:)=de_noise_EEG;
            
        end
        
        dir_out1=[paths,list(j).name];
        save(dir_out1,'Temp'); 
end
