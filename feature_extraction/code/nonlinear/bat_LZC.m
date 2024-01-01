% function bat_LZC
% %UNTITLED Summary of this function goes here
% %   Detailed explanation goes here
% dir_in=('G:\研究生相关\眼动\');
% dir_out=('G:\研究生相关\眼动\交叉结果\');
% files=dir([dir_in '*.xlsx']);
% n=length(files);
% fs=100;
% for j=1:n    
%     [Data,DataText]=xlsread([dir_in files(j).name]);
%     DateLen=size(Data,1);%y=ALL([9,22,24,33,36,45,52,58,70,83,92,96,104,108,122,124],:);  
%     DateDim=size(Data,2);
%     for i=1:DateLen
%         disp(i);
%         wlen=100;
%         overlap=50;
%         fn=floor((DateDim-wlen+overlap)/overlap);
%         for seg=1:fn
%             A=mean(Data(i,(1+overlap*(seg-1)):(overlap*(seg-1)+wlen)));
%             B=std(Data(i,(1+overlap*(seg-1)):(overlap*(seg-1)+wlen)));
%             Mean(i,seg)=A;
%             Std(i,seg)=B;
%             LZC(i,seg) = lzcomplexity(Data(i,(1+overlap*(seg-1)):(overlap*(seg-1)+wlen)));
%         end
%     end
%     paths = sprintf('%sbat_LZC\\',dir_out);
%     if ~isdir(paths)
%         mkdir(paths);
%     end
%     files(j).name(end-4:end)=[];
%     Fname=[files(j).name '.mat'];
%     Mname=[files(j).name,'Mean.mat'];
%     Sname=[files(j).name,'Std.mat'];
%     save([paths,Fname],'LZC');
%     save([paths,Mname],'Mean');
%     save([paths,Sname],'Std');
%     clear LZC;
%     clear Mean;
%     clear Std;
% end
function bat_LZC
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dir_in=('E:\脑电特征提取\分波段\alpha\');
dir_out=('E:\脑电特征提取\分波段\alpha_fea\');
% dir_in=('F:\WSQ_脑电与眼动\王颖师姐数据\EEG\EGG-ALL\抑郁\');
% dir_out=('F:\WSQ_脑电与眼动\王颖师姐数据\EEG\EEG-feature\抑郁\');
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
      LZC(trial,i) = lzcomplexity(Data(i,:,trial));
    end
  end
        name1 = files(j).name(1:4);
        id1 = str2num(name1);
        id2 = repelem(id1, 30);
        id2 = id2';
         LZC1 = [id2, LZC];
   finalFeatures = [finalFeatures; LZC1];
end
 save([dir_out 'LZC'],'finalFeatures');
  xlswrite([dir_out,'LZC','.xlsx'], finalFeatures);

   disp('Program End!');