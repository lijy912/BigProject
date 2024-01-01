function Threebands
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%dir_in=('/home/uais_2/unfilterd eeg data/1/'); %���·��
% dir_out1=('/home/uais_2/unfilterd eeg data/');%���·��

dir_in=('/home/uais_2/unfilterd eeg data/Preprocessed/');
dir_out=('/home/uais_2/unfilterd eeg data/3-2/');
files=dir([dir_in '*.mat']);
n=length(files);
fs=250;
for j=1:n
    
    
    dirn=[dir_out '3_bands/' files(j).name];   %'D:\�Ե����\unfilterd EEG data\3_bands\1 20140107 1448.fil.seg.blc.mat'
    if ~isdir(dirn)
        mkdir(dirn);
    end
    paths=[dirn,'/'];%'D:\�Ե����\unfilterd EEG data\3_bands\1 20140107 1448.fil.seg.blc.mat\'
    
    path=[dir_in files(j).name,'/'];%[D:\�Ե����\unfilterd EEG data\pre_processed\1 20140107 1448.fil.seg.blc.mat\;]
    lists=dir([path,'*.mat']);
    m = length(lists);
    for k = 1:m
        load([path lists(k).name]);
        
        for i=1:128
            alpha(i,:)=directFFT(Temp(i,:),fs,8,13);
            beta(i,:)=directFFT(Temp(i,:),fs,13,30);
            theta(i,:)=directFFT(Temp(i,:),fs,4,8);
            
            
        end
        save([paths,'alpha_' lists(k).name],'alpha');
        save([paths,'beta_' lists(k).name],'beta');
        save([paths,'theta_' lists(k).name],'theta');
        
        clear alpha;
        clear beta;
        clear theta;
        
    end
    
    
    
end

