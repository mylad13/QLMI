function [K,H] = lmiSolver(A,B,Lambda)
n=size(A,1);
m=size(B,2);
l=n+m;


cvx_begin sdp
    variable H11(n,n) symmetric 
    variable H12T(m,n)
    variable H22(m,m) symmetric
    variable W(n,n) symmetric
    maximize ( trace(W) )
    subject to
        H=[H11 H12T' ; H12T H22];
        H22 >= 0;
        [H11-W H12T'; H12T H22] >= 0;
        [[A B]'*H11*[A B]-H+Lambda [A B]'*H12T';H12T*[A B] H22] >=0;
cvx_end

K = -inv(H22)*H12T;

end

