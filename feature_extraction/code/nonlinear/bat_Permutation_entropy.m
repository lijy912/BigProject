function bat_Permutation_entropy
dir_in=('C:\Users\lijia\Desktop\BigProject\feature\_mat\');
dir_out=('C:\Users\lijia\Desktop\BigProject\feature\nonlinear\');
files=dir([dir_in '*.mat']);
n=length(files);
fs=250;
finalFeatures = [];
for j=1:n
    disp(j);
    Data=importdata([dir_in files(j).name]);
    Data = Data([9 22 24 33 36 45 52 58 70 83 92 96 104 108 122 124],1:500); % 16*500 
  for trial=1:39
       channel=size(Data,1);
    for i=1:channel
        Per_en(trial,i)=Permutation_entropy(Data(i,:));
    end
  end
        name1 = files(j).name(1:4);
        id1 = str2num(name1);
        id2 = repelem(id1, 39);
        id2 = id2';
        Per_en1 = [id2,Per_en];
   finalFeatures = [finalFeatures;Per_en1];
end
 save([dir_out 'Per_en'],'finalFeatures');
  xlswrite([dir_out,'Per_en','.xlsx'], finalFeatures);

   disp('Program End!');
