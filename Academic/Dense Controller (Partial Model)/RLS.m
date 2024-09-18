function [W,S] = RLS(Phi,r,W,S)

W = W + (S*Phi*(r-Phi'*W))/(1+Phi'*S*Phi);
S = S - (S*(Phi'*Phi)*S)/(1+Phi'*S*Phi);


end

