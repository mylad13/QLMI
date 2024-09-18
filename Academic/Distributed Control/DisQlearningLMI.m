function [K] = QlearningLMI(A,B,Q,R,x,strc)
Lambda = [Q zeros(4);zeros(4) R];

sol = dare(A,B,Q,R);
H_sol=[Q+A'*sol*A A'*sol*B; B'*sol*A R+B'*sol*B];
W_sol=WfromH(H_sol);
K_sol = -inv(R+B'*sol*B)*B'*sol*A;

states1=strc{1};    inputs1=states1+4;
states2=strc{2};    inputs2=states2+4;
states3=strc{3};    inputs3=states3+4;
states4=strc{4};    inputs4=states4+4;

xxx=[];
uuu=[];
xx=[];
uu=[];

l=4;
j=0;
noise=1;

K=zeros(4);
x=3*randn(4,1);
bias=round(1000*rand(4,1));

for i=1:l+1
    x0=x;
    u0= K*x0 + noise*0.5*richnoiseN(i,4,bias);
%     u0= K*x0 + noise*0.5*randn(4,1);
    x = A*x0 + B*u0;
    xxx=[xxx x0];
    uuu=[uuu u0]; 
end
D=[xxx(:,1:l);uuu(:,1:l)];
X=[xxx(:,2:l+1)];

D1=D([states1,inputs1],:);
D2=D([states2,inputs2],:);
D3=D([states3,inputs3],:);
D4=D([states4,inputs4],:);
X1=X(states1,:);
X2=X(states2,:);
X3=X(states3,:);
X4=X(states4,:);
costN1=D1'*Lambda([states1,inputs1],[states1,inputs1])*D1;
costN2=D2'*Lambda([states2,inputs2],[states2,inputs2])*D2;
costN3=D3'*Lambda([states3,inputs3],[states3,inputs3])*D3;
costN4=D4'*Lambda([states4,inputs4],[states4,inputs4])*D4;


K1 = lmiSolverSSMF(D1,X1,costN1,states1,inputs1);
K2 = lmiSolverSSMF(D2,X2,costN2,states2,inputs2);
K3 = lmiSolverSSMF(D3,X3,costN3,states3,inputs3);
K4 = lmiSolverSSMF(D4,X4,costN4,states4,inputs4);

K1 = K1(1,:);
K2 = K2(1,:);
K3 = K3(1,:);
K4 = K4(2,:);

K=[K1 0 0; 0 K2 0;0 0 K3;K4(1) 0 0 K4(2)];

end

