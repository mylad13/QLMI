function [K,H] = lmiSolverMF(D,X,cost)
n=size(X,1);
m=size(D,1)-n;
l=n+m;


cvx_begin sdp
    variable H11(n,n) symmetric 
    variable H12T(m,n)
    variable H22(m,m) symmetric
    variable W(n,n) symmetric
    maximize ( trace(W) )
    subject to
        H=[H11 H12T' ; H12T H22];
        H >= 0;
        [H11-W H12T'; H12T H22] >= 0;
        [X'*H11*X-D'*(H)*D+cost X'*H12T';H12T*X H22] >=0;
cvx_end

K = -inv(H22)*H12T;
end

