function bat_all

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
        disp(['x size: ' num2str(size(x))]);
        x = x([9 22 24 33 36 45 52 58 70 83 92 96 104 108 122 124],1:500); % 16*500
        x_len=size(x,1); % 16
% ----------------------------------------------------------
        for k = 1:x_len
            C0(k, :) = c0complex(x(k, :)); % 1*16
            H_singu(k, :) = singular_entropy(x(k, :)); % 1*16
            PSen(k, :) = spectral_entropy(x(k, :)); % 1*16
            LE(k, :) = lyapunov_Rosentein(x(k, :)); % 1*16
            Per_en(k, :) = Permutation_entropy(x(k, :)); % 1*16
            Km(k, :) = kolmgolov_entropy(x(k, :)); % 1*16
            features(k, :) = [C0(:, k); H_singu(:, k); PSen(:, k); LE(:, k); Per_en(:, k); Km(:, k)]'; % 16*6
            % features(k, :) = [c0complex(x(k,:)), singular_entropy(x(k,:)), spectral_entropy(x(k,:)), lyapunov_Rosentein(x(k,:)), Permutation_entropy(x(k,:)), kolmgolov_entropy(x(k,:))];
            disp(['C0(:, k) size: ' num2str(size(C0(:, k)))]);
            disp(['features size: ' num2str(size(features))]);
        end % 16*6
% ----------------------------------------------------------
        features_x=size(features,1); % 16
        features_y=size(features,2); % 6
        features1=reshape(features',1,features_x*features_y); % 1*96
        sum(tNum,:)= features1; % ++*96 % 39*96
    end
    name1 = dataLists(j).name(1:4);
    id1 = str2num(name1);
    id2 = repelem(id1, 39);
    id2 = id2'; % 39*1
    sum1 = [id2,sum]; % 39*97
    finalFeatures = [finalFeatures; sum1]; % ++*97 % 2067*97
    clear x;
end
save([outPaths 'finalFeatures'],'finalFeatures');
xlswrite([outPaths,'finalFeatures','.xlsx'], finalFeatures);
disp('处理完成。 ');
