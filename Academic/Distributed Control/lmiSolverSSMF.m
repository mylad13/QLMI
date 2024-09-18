function [K,H] = lmiSolverSSMF(D,X,cost,states,inputs)
n=length(states);
m=length(inputs);
l=length(D);
% excludes=setdiff(1:l,[states,inputs]);
% J=eye(l+n);
% F=J([states,inputs,l+1:l+n],:);
% sLambda=Lambda([states,inputs],[states,inputs]);

cvx_begin sdp
    variable H11(n,n) symmetric
    variable H12(n,m)
    variable H22(m,m) symmetric
    variable W(n,n) symmetric
%     variable H(l,l) symmetric
    maximize ( trace(W) )
    subject to
%         H(excludes,:)==0;    H(:,excludes)==0;
%         H(states,states)==H11;
%         H(states,inputs)==H12;
%         H(inputs,states)==H12';
%         H(inputs,inputs)==H22;
        H=[H11 H12 ; H12' H22];
        [H11 H12;H12' H22] >= 0;
        [H11-W H12; H12' H22] >= 0;
        [(X'*H11*X-D'*(H)*D+cost) X'*H12;H12'*X H22] >=0;
cvx_end

K = -inv(H22)*H12';
end

