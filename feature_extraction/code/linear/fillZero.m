outPaths=('C:\Users\lijia\Desktop\BigProject\feature\linear\');

load('C:\Users\lijia\Desktop\BigProject\feature\linear\finalfeatures.mat');
a = isnan(finalFeatures);
for l = 1:1200
    for c = 1:81
        if a(l,c)
            finalFeatures(l,c)=0;
            fprintf("fill\n");
        end
    end
end
save([outPaths,'finalFeatures.mat'],'finalFeatures');
xlswrite([outPaths,'finalFeatures','.xlsx'], finalFeatures);
disp('Program End!');
