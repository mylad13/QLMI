function [K,H] = lmiSolverCMF(D,X,cost,strc)
m=length(strc);
n=size(X,1);
l=n+m;
for i =1:m
    excl{i}=setdiff(1:n,strc{i});
end

cvx_begin sdp
    variable H11(n,n) symmetric 
    variable H12T(m,n)
    variable H22(m,m) diagonal
    variable W(n,n) symmetric
    maximize ( trace(W) )
    subject to
        for i = 1:m
            H12T(i,excl{i})==0;
        end
        H=[H11 H12T' ; H12T H22];
        H22 >= 0;
        [H11-W H12T'; H12T H22] >= 0;
        [X'*H11*X-D'*(H)*D+cost X'*H12T';H12T*X H22] >=0;
cvx_end

K = -inv(H22)*H12T;
end

