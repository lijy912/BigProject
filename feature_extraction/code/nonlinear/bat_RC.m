function bat_RC
% %UNTITLED Summary of this function goes here
% %   Detailed explanation goes here
% dir_in=('F:\513情绪面孔预处理\预处理后\');
% dir_out=('F:\513情绪面孔预处理\非线性\');
% files=dir([dir_in '*.mat']);
% n=length(files);
% fs=6;
% for j=1:n
%     %[Data,DataText]=xlsread([dir_in files(j).name]);
%     Data=importdata([dir_in files(j).name])
%     DateLen=size(Data,1);%y=ALL([9,22,24,33,36,45,52,58,70,83,92,96,104,108,122,124],:);  
%     for i=1:DateLen
%         disp(i);
%         for seg=1:6
%             CorrelationDimension(i,:) = reC(Data(i,(1+(seg-1)*100):seg*100));   
%         end
%     end
%     paths = sprintf('%sbat_RC',dir_out);
%     if ~isdir(paths)
%         mkdir(paths);
%     end
%     files(j).name=[files(j).name '.mat']
%     save([paths,files(j).name],'CorrelationDimension');
%     clear CorrelationDimension;
% end

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dir_in=('E:\脑电特征提取\分波段\alpha\');
dir_out=('E:\脑电特征提取\分波段\alpha_fea\');
files=dir([dir_in '*.mat']);
n=length(files);
fs=250;
finalFeatures = [];
for j=1:n
     disp(j);
    Data=importdata([dir_in files(j).name]);
    Data = Data([1:128],:,:); 
  for trial=1:30
       channel=size(Data,1);
    for i=1:channel
         CorrelationDimension(trial,i) = reC(Data(i,:,trial));
       
    end
  end
        name1 = files(j).name(1:4);
        id1 = str2num(name1);
        id2 = repelem(id1, 30);
        id2 = id2';
        CorrelationDimension1 = [id2,CorrelationDimension];
   finalFeatures = [finalFeatures;CorrelationDimension1];
end
 save([dir_out 'CD'],'finalFeatures');
  xlswrite([dir_out,'CD','.xlsx'], finalFeatures);

   disp('Program End!');