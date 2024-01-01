function bat_singular_entropy
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
        H_singu(trial,i)=singular_entropy(Data(i,:));
        disp(['H_singu size: ' num2str(size(H_singu))]);
    end
  end
        name1 = files(j).name(1:4);
        id1 = str2num(name1);
        id2 = repelem(id1, 39);
        id2 = id2';
        H_singu1 = [id2,H_singu];
   finalFeatures = [finalFeatures;H_singu1];
end
 save([dir_out 'SVDen'],'finalFeatures');
  xlswrite([dir_out,'SVDen','.xlsx'], finalFeatures);

   disp('Program End!');
