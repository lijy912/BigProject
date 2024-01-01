clear all

dir_in = ('G:\\visual search\\VS\ERP\\');
dir_out1 = ('G:\\visual search\\VS\\DATA\\');
dir_out2 = ('G:\\visual search\\VS\\Result\\');

files=dir([dir_in ]);
n=length(files);

markList = {'GE4','RE4','GH4','RH4','GE8','RE8','GH8','RH8'};

ERP = pop_loaderp( 'filename', '020100021150.erp', 'filepath', dir_in + '\\' + markList{k} );


for k=1:n 
    name=files(k).name;
    i=1;
    name1='';
    while(name(i) ~= '.')
        name1=[name1,name(i)];
        i=i+1;
    end
    name=name1;
    
    %%载入数据 
    EEG = pop_loadbv('G:\\visual search-LXB\\', files(k).name, [], [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64]);
    EEG.setname = strcat(name);
    EEG = eeg_checkset( EEG );
    
    %%电极定位
    EEG=pop_chanedit(EEG, 'lookup','G:\\visual search\\standard-10-5-cap385.elp');
    EEG = eeg_checkset( EEG );
    
    
    %%去心电
    EEG = pop_select( EEG,'nochannel',{'ECG'});
    EEG = eeg_checkset( EEG );
    

    %%滤波
    highPass = 0.1 ;
    lowPass = 30 ;
    EEG = pop_eegfiltnew(EEG, [], highPass, 33000, 1, [], 1); %高通
    EEG = pop_eegfiltnew(EEG, [], lowPass, 440, 0, [], 1); %低通
    EEG = eeg_checkset( EEG );
    
    %%ICA
    EEG = pop_runica(EEG, 'pca',30,'interupt','on');
    EEG = eeg_checkset( EEG );
    
    %%保存
    savename = strcat(name,'_ICA','.set');
    EEG = pop_saveset( EEG, 'filename',savename,'filepath','G:\\ICA\\');%设置一个保存位置
    EEG = eeg_checkset( EEG );
end