# 数据预处理

- `EEG_128channels_resting_lanzhou_2015`存放原始采集的数据；

- `chan_info_egi_129.mat`是头皮定位信息的文件；

- `_EEG`另存了每个原始数据文件所使用的变量；

- `_ica`存放经过电极定位、重参考、去除无关电极、滤波以及ICA之后的数据；

- `_rm`存放`Adjust`插件手动去除伪迹之后的数据；

- `data`存放全脑平均重参考、选择数据、数据分段之后的数据，即预处理阶段完成后的数据。

## 另存每个原始数据文件所使用的变量

```matlab
original_directory_path = 'C:\Users\lijia\Desktop\BigProject\preprocess\EEG_128channels_resting_lanzhou_2015';
output_directory_path = 'C:\Users\lijia\Desktop\BigProject\preprocess\_EEG';
mat_files = dir(fullfile(original_directory_path, '*.mat'));
for i = 1:length(mat_files)
    original_file_path = fullfile(original_directory_path, mat_files(i).name);
    [~, original_file_name, ~] = fileparts(mat_files(i).name);
    variable_name = ['a' strrep(regexprep(original_file_name, {'\.', 'mat'}, ''), ' ', '_') 'mat'];
    load(original_file_path, variable_name);
    new_file_name = regexp(variable_name, 'a(.*?)_', 'tokens', 'once');
    if ~isempty(new_file_name)
        new_file_name = strrep(new_file_name{:}, 'rest', '');
        new_file_name = strrep(new_file_name, '_', '');
        new_file_name = strrep(new_file_name, 'new', '');
        new_file_name = [new_file_name '.mat'];
        new_file_path = fullfile(output_directory_path, new_file_name);
        save(new_file_path, variable_name);
        disp(['File ' mat_files(i).name ' processed and saved as ' new_file_path]);
    else
        disp(['Unable to extract name from file ' mat_files(i).name]);
    end
end
```

## 重参考、滤波、ICA

```matlab
rawDataDir = 'C:\Users\lijia\Desktop\BigProject\preprocess\_EEG';
processedDataDir = 'C:\Users\lijia\Desktop\BigProject\preprocess\_ica';
rawFiles = dir(fullfile(rawDataDir, '*.mat'));
for i = 1:length(rawFiles)
    % 导入数据
    rawFilePath = fullfile(rawDataDir, rawFiles(i).name);
    EEG = pop_importdata('dataformat','matlab','nbchan',129,'data',rawFilePath,'srate',250,'pnts',0,'xmin',0);
    EEG = eeg_checkset(EEG);
    % 重参考
    locFile = 'C:\Users\lijia\Desktop\BigProject\preprocess\chan_info_egi_129.mat';
    load(locFile);
    EEG.chanlocs = chanlocs;
    EEG = pop_reref( EEG, 129);
    EEG = eeg_checkset( EEG );
    % 滤波
    EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',40);
    EEG = eeg_checkset( EEG );
    % ica
    EEG = pop_runica(EEG, 'icatype', 'runica', 'pca',128,'interrupt','on');
    EEG = eeg_checkset( EEG );
    [~, fileName, ~] = fileparts(rawFiles(i).name);
    % 保存
    saveFilePath = fullfile(processedDataDir, [fileName '.set']);
    EEG = pop_saveset(EEG, 'filename', [fileName '.set'], 'filepath', processedDataDir);
end
disp('处理完成。');
```

## `Adjust`插件手动去伪迹

一系列体力活动

## 全脑平均重参考、选择数据、数据分段

```matlab
rawDataDir = 'C:\Users\lijia\Desktop\BigProject\preprocess\_rm';
processedDataDir = 'C:\Users\lijia\Desktop\BigProject\preprocess\data';
rawFiles = dir(fullfile(rawDataDir, '*.set'));
for i = 1:length(rawFiles)
    % 导入数据
    rawFilePath = fullfile(rawDataDir, rawFiles(i).name);
    EEG = pop_loadset('filename', rawFiles(i).name, 'filepath', rawDataDir);
    EEG = eeg_checkset( EEG );
    % 全脑平均重参考
    EEG = pop_reref(EEG, []);
    EEG = eeg_checkset(EEG);
    % 选择数据
    EEG = pop_select( EEG, 'point',[1 20000] );
    EEG = eeg_checkset( EEG );
    % 提取epochs
    EEG = eeg_regepochs(EEG, 'recurrence', 2, 'limits', [0,2], 'rmbase', NaN);
    EEG = eeg_checkset( EEG );
    % 保存
    saveFilePath = fullfile(processedDataDir, rawFiles(i).name);
    EEG = pop_saveset(EEG, 'filename', rawFiles(i).name, 'filepath', processedDataDir);
end
disp('处理完成。');
```