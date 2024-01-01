function y=directFFT(s,fs,fc1,fc2)

[row,col]=size(s);
if col>row
    s=s';
    [row,col]=size(s);
end
yf=fft(s);

n=0:row-1;
f=n*fs/row;
% subplot(2,1,1);plot(n*fs,s);
% subplot(2,1,2);plot(f,abs(yf)*2/row);
% xlim([0,fs/2]);
yfx=zeros(1,length(yf));

for i=1:row
    if ((i*fs)/row)>fc1 && (i*fs/row)<fc2 ||  ((i*fs)/row)>fs-fc2 && (i*fs/row)<fs-fc1  
        yfx(i)=yf(i);
    else
        yfx(i)=0;
    end
end
y=real(ifft(yfx));
end
% figure;
% subplot(2,1,1);plot(n*fs,real(y));
% subplot(2,1,2);plot(f,abs(yfx)*2/row);
