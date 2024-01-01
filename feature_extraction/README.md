# 特征提取

- `_mat`存放预处理步骤结束后所有的`.set`文件转化为`.mat`文件之后的数据；

- `code`存放进行特征提取的代码；

- `linear`存放提取线性特征之后的数据；

- `nonlinear`存放提取非线性特征之后的数据。

## 将预处理结束后所有的`.set`文件转化为`.mat`文件

```matlab
rawDataDir = 'C:\Users\lijia\Desktop\BigProject\preprocess\data';
processedDataDir = 'C:\Users\lijia\Desktop\BigProject\feature_extraction\_mat';
rawFiles = dir(fullfile(rawDataDir, '*.set'));
for i = 1:length(rawFiles)
    % 导入数据并转为.mat文件
    rawFilePath = fullfile(rawDataDir, rawFiles(i).name);
    EEG = pop_loadset('filename', rawFiles(i).name, 'filepath', rawDataDir);
    event = EEG.event;
    data = EEG.data;
    srate = EEG.srate;
    % 保存.mat文件
    saveFilePath = fullfile(processedDataDir, rawFiles(i).name);
    matFileName = strcat(rawFiles(i).name(1:end-4), '.mat'); 
    saveFilePath = fullfile(processedDataDir, matFileName);
    save(saveFilePath,'data');
end
disp('处理完成。');
```

## 线性特征

1. `ppMean`：表示 EEG 信号峰值与峰值之间的振幅；

2. `meanSquare`：表示 EEG 信号的均方差；

3. `Variance`：表示 EEG 信号的方差值；

4. `Activity`：脑电信号的平均功率的方差；

5. `Mobility`：脑电信号斜率均方根与振幅均方根的比率，用于估算均数频率；

6. `Complexity`：一种斜率变化与理想的曲线比率的均方根的测算方法，常用于估算信号的带宽，如果信号与理想信号极为相似，值将收敛为 1；

7. `maxp （Max Power Spectrum Density）`：采用自适应的 AR（Auto regressive）模型计算脑电信号的最大功率谱密度；

8. `Sumpower`：基于 AR 模型计算得来脑电信号的功率。

```matlab
function bat_F_allfeatures
dir_in=('C:\Users\lijia\Desktop\BigProject\feature_extraction\_mat\');
dir_out=('C:\Users\lijia\Desktop\BigProject\feature_extraction\linear\');
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
save([outPaths 'finalFeatures'],'finalFeatures');
xlswrite([outPaths,'finalFeatures','.xlsx'], finalFeatures);
disp('处理完成。');
```

## 非线性特征

1. `C0-complexity`：C0复杂度，C0复杂度是一种度量时间序列随机性的方法，表示序列的非规则程度；

2. `Singular-value deposition entropy(SVDen) `：单值分解熵，在 EEG 复杂性监测当中 Singular 是比较常见的一种方法，奇异熵反映信号能量在奇异频谱划分下的不确定性；

3. `Spectral entropy`：谱熵，是一种信息熵，信号功率谱中如果存在的谱峰越窄，谱熵越小，则表明信号复杂度越小；而如果功率谱中的谱峰越平坦，谱熵越大，则表明信号复杂度越大；

4. `Largest Lyapunov Exponent(LLE)`：最大李雅普诺夫指数，表征了系统在相空间中相邻轨道间收敛或发散的平均指数率，是判断一个动力学系统是否处于混沌状态的最重要的指标之一；

5. `Permutation entropy(Per_en)`：排列熵，是一种衡量一维时间序列的平均熵参数；

6. `Approximate Entropy(ApEn)`：近似熵，在 EEG 信号中，ApEn 值越大，表示信号的复杂度越高、越不规律。ApEn 常被当作一个诊断的依据应用在生理电信号、生物系统等许多领域。

```matlab
function bat_F_allfeatures
dir_in=('C:\Users\lijia\Desktop\BigProject\feature_extraction\_mat\');
dir_out=('C:\Users\lijia\Desktop\BigProject\feature_extraction\nonlinear\');
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
```