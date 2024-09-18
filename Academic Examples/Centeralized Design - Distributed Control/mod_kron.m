function [phi] = mod_kron(x)
len= length(x);
phi = zeros(len*(len+1)/2,1);
counter = 1;
kr = kron(x',x);
for i = 1:len
    for j = i:len
        phi(counter) = kr(i,j);
        counter = counter + 1;
    end
end
end

