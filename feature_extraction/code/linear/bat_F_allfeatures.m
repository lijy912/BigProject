function bat_F_allfeatures

dir_in=('C:\Users\lijia\Desktop\BigProject\feature\_mat');
dir_out=('C:\Users\lijia\Desktop\BigProject\feature\linear');
fs=250;
dirn=[dir_out];
dirn=dir_out;
if ~isdir(dirn)
    mkdir(dirn);
end
outPaths=dirn;
path=[dir_in,'\'];
dataLists=dir([path,'*.mat']);
lengthOfDataList = length(dataLists); 
finalFeatures = [];
for j = 1:lengthOfDataList % 53
    disp(j);
    alpha=importdata([path dataLists(j).name]);
    for tNum = 1:39 % 39
        x = alpha(:,:,tNum); % 128*500
        disp(['x size: ' num2str(size(x))]);
        x = x([9 22 24 33 36 45 52 58 70 83 92 96 104 108 122 124],1:500); % 16*500
        x_len=size(x,1);
        for k=1:x_len % 16
            features(k,:) = linefeatures(x(k,:)'); % 16*8
        end
        features_x=size(features,1); % 16
        features_y=size(features,2); % 8
        features1=reshape(features',1,features_x*features_y); % 1*128
        sum(tNum,:)= features1; % ++*128 % 39*128
    end
    name1 = dataLists(j).name(1:4);
    id1 = str2num(name1);
    id2 = repelem(id1, 39);
    id2 = id2'; % 39*1
    sum1 = [id2,sum]; % 39*129
    finalFeatures = [finalFeatures; sum1]; % ++*129 % 2067*129
    clear x;
end
save([outPaths '\finalFeatures'],'finalFeatures');
xlswrite([outPaths,'\finalFeatures','.xlsx'], finalFeatures);
disp('处理完成。 ');
