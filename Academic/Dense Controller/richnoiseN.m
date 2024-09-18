function [out] = richnoiseN(k,N,bias)
% size of bias is (N,1)
% N=1;
out=zeros(N,1);


% out(1) = sin(0.2*k)^5+sin(k)^5+sin(5*k)^5+sin(25*k)^5;
% out(2) = sin(15*k)+sin(-27*k)+sin(39*k)+sin(4*k)+sin(23*k)+sin(7*k)+sin(81*k);
% out(3) = sin(5*k)+sin(-11*k)+sin(23*k)+sin(15*k)+sin(37*k)+sin(59*k)+sin(71*k);
% out(4) = cos(k)+sin(-13*k)+cos(25*k)+sin(37*k)+cos(-49*k)+cos(54*k)+cos(63*k);
for i = 1:N
    out(i) = sin(0.01*(k+bias(i)))^5+sin(0.2*(k+bias(i)))^5+sin(k+bias(i))^5+sin(5*(k+bias(i)))^5+sin(25*(k+bias(i)))^5;
end

