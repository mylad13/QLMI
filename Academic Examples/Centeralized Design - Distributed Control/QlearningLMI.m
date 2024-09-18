function [K] = QlearningLMI(A,B,Q,R,x,strc)
Lambda = [Q zeros(4);zeros(4) R];

sol = dare(A,B,Q,R);
H_sol=[Q+A'*sol*A A'*sol*B; B'*sol*A R+B'*sol*B];
W_sol=WfromH(H_sol);
K_sol = -inv(R+B'*sol*B)*B'*sol*A;


xxx=[];
uuu=[];
xx=[];
uu=[];

l=8;
j=0;
noise=1;

K=zeros(4);
x=3*randn(4,1);

for i=1:l+1
    x0=x;
    u0= K*x0 + noise*0.1*randn(4,1);
    x = A*x0 + B*u0;
    xxx=[xxx x0];
    uuu=[uuu u0]; 
end
D=[xxx(:,1:l);uuu(:,1:l)];
X=[xxx(:,2:l+1)];
cost = D'*Lambda*D;
[K,H]=lmiSolverCMF(D,X,cost,strc);
end

