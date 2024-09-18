function [out] = richnoise(k,N)
% N=91;
N=N*2;

% out = sin(100*k)^2*cos(100*k)+sin(2*k)^2*cos(0.1*k)+...
%     sin(-1.2*k)^2*cos(0.5*k)+sin(k)^5+sin(1.12*k)^2+cos(2.4*k)*sin(2.4*k)^3;
out = 0;
for i=1:N
    bias = 0;
   out = out+sin(N*k+bias)^2*cos(N*k+bias)+sin(2*N*k+bias)^2*cos(0.1*N*k+bias)+...
       sin(-1.2*N*k+bias)^2*cos(0.5*N*k+bias)+sin(N*k+bias)^5+sin(N*1.12*k+bias)^2+cos(N*2.4*k+bias)*sin(N*2.4*k+bias)^3; 

%   out = out+sin(freq*k); 
end
out = out/(2.5*N);
end

