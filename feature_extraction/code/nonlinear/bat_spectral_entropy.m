function bat_spectral_entropy
dir_in=('C:\Users\lijia\Desktop\BigProject\feature\_mat\');
dir_out=('C:\Users\lijia\Desktop\BigProject\feature\nonlinear\');
files=dir([dir_in '*.mat']);
n=length(files);
fs=250;
finalFeatures = [];
for j=1:n % 53
    disp(j);
    Data=importdata([dir_in files(j).name]);
    Data = Data([9 22 24 33 36 45 52 58 70 83 92 96 104 108 122 124],1:500); % 16*500
  for trial=1:39 % 39
       channel=size(Data,1);
    for i=1:channel % 16
        PSen(trial, i) = spectral_entropy(Data(i, :));% 39*16
        disp(['PSen size: ' num2str(size(PSen))]);
    end
  end
        name1 = files(j).name(1:4);
        id1 = str2num(name1);
        id2 = repelem(id1, 39);
        id2 = id2';
        PSen1 = [id2,PSen];
   finalFeatures = [finalFeatures;PSen1];
end
save([dir_out 'Spectral Entropy'],'finalFeatures');
xlswrite([dir_out,'Spectral Entropy','.xlsx'], finalFeatures);

   disp('Program End!');