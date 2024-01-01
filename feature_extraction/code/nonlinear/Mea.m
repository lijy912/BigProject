A=[1 2 3;3 3 6;4 6 8;4 7 7];
DataLen=size(A,1);
for i=1:DataLen
    B=std(A(i,:))
end