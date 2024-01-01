function bat_ApEn
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dir_in=('E:\脑电特征提取\pupil\');
dir_out=('E:\脑电特征提取\pupil_fea\');
files=dir([dir_in '*.mat']);
n=length(files);
fs=1000;
finalFeatures = [];
for j=1:n
    disp(j);
    Data=importdata([dir_in files(j).name]);
    Data = Data([1:1],:,:); 
  for trial=1:30
      disp(trial)
      channel=size(Data,1);
      for i=1:channel
          Em(trial,i) = ApEn(Data(i,:,trial)); 
      end
  end
  name1 = files(j).name(1:4);
  id1 = str2num(name1);
  id2 = repelem(id1, 30);
  id2 = id2';
  Em1 = [id2,Em];
  finalFeatures = [finalFeatures;Em1];
end
save([dir_out 'ApEn'],'finalFeatures');
xlswrite([dir_out,'ApEn','.xlsx'], finalFeatures);
disp('Program End!');