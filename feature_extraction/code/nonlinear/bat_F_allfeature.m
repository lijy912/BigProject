function bat_F_allfeatures
dir_in=('C:\Users\lijia\Desktop\BigProject\feature\_mat\');
dir_out=('C:\Users\lijia\Desktop\BigProject\feature\nonlinear\');
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
        %disp(['x size: ' num2str(size(x))]);
        x = x([9 22 24 33 36 45 52 58 70 83 92 96 104 108 122 124],1:500); % 16*500
        x_len=size(x,1);
        for k=1:x_len % 16
            C0(k,:) = c0complex(x(k,:))'; % 16*1
            %disp(['C0 size:' num2str(size(C0))]);
            H_singu(k,:) = singular_entropy(x(k, :))'; % 16*1
            %disp(['H_singu size:' num2str(size(H_singu))]);
            PSen(k,:) = spectral_entropy(x(k, :))'; % 16*1
            %disp(['PSen size:' num2str(size(PSen))]);
            LE(k,:) = lyapunov_Rosentein(x(k, :))'; % 16*1
            %disp(['LE size:' num2str(size(LE))]);
            Per_en(k,:) = Permutation_entropy(x(k, :))'; % 16*1
            %disp(['Per_en size:' num2str(size(Per_en))]);
            Em(k,:) = ApEn(x(k,:))'; % 16*1
            %disp(['Em size:' num2str(size(Em))]);
            features(k,:) = [C0(k,:), H_singu(k,:),   PSen(k,:), LE(k,:), Per_en(k,:), Em(k,:)]; % 16*6
        end
        features_x=size(features,1); % 16
        features_y=size(features,2); % 6
        features1=reshape(features',1,features_x*features_y); % 1*96
        sum(tNum,:)= features1; % ++*96  % 39*96
        disp(['sum size:' num2str(size(sum))]);
    end
    name1 = dataLists(j).name(1:4);
    id1 = str2num(name1);
    id2 = repelem(id1, 39);
    id2 = id2'; % 39*1
    sum1 = [id2,sum]; % 39*97
    %disp(['sum1 size:' num2str(size(sum1))]);
    finalFeatures = [finalFeatures; sum1]; % ++*97 % 2067*97

    clear x;
end
save([outPaths 'finalFeatures'],'finalFeatures');
xlswrite([outPaths,'finalFeatures','.xlsx'], finalFeatures);
disp('处理完成。');