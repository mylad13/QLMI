function [K] = reducedLMI(A,B,Q,R,x,strc)
Lambda = [Q zeros(4);zeros(4) R];

sol = dare(A,B,Q,R);
H_sol=[Q+A'*sol*A A'*sol*B; B'*sol*A R+B'*sol*B];
W_sol=WfromH(H_sol);
K_sol = -inv(R+B'*sol*B)*B'*sol*A;


xxx=[];
uuu=[];
xx=[];
uu=[];

[K,H]=lmiSolverC(A,B,Lambda,strc);
end

