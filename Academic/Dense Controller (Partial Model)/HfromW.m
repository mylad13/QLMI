function [H] = HfromW(W)
len = length(W);
size = (-1+sqrt(1+8*len))/2;
H = zeros(size);
counter = 1;
for i = 1:size
    for j = i:size
        if i==j
            H(i,j)=W(counter);
            counter = counter + 1;
        else
            H(i,j)=W(counter)/2;
            H(j,i)=H(i,j);
            counter = counter + 1;
        end
    end
end
end