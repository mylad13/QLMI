clear
close all
A = [0.36 0.46 0.11 0.12;
     0.11 0.36 0.35 0.12;
     0.13 0.13 0.48 0.49;
     0.47 0.12 0.12 0.48]; %system 2 (unstable) low interactions
 A = [0.3 0.4 0.2 0.2;
     0.2 0.3 0.3 0.2;
     0.2 0.2 0.4 0.4;
     0.4 0.2 0.2 0.4]; %system 3 (unstable) high interatctions
%   A = [0.25 0.35 0.15 0.14;
%      0.15 0.25 0.25 0.15;
%      0.14 0.14 0.34 0.33;
%      0.34 0.14 0.14 0.33]; %system 6 (stable) high interactions
B = eye(4);
Q = eye(4);
R = eye(4);
Lambda = [Q zeros(4);zeros(4) R];

sol = dare(A,B,Q,R);
H_sol=[Q+A'*sol*A A'*sol*B; B'*sol*A R+B'*sol*B];
W_sol=WfromH(H_sol);
K_sol = -inv(R+B'*sol*B)*B'*sol*A;

n=size(B,1);
m=size(B,2);

xxx=[];
uuu=[];
xx=[];
uu=[];
samples=40;
l=8;
j=0;
noise=1;

K=zeros(4);
x=3*randn(4,1);
x=[1;2;3;4];
% x=[5;5;5;5];
for i=1:samples
            j=j+1;
            x0=x;
            u0= K*x0 + noise*0.01*randn(4,1);
            x = A*x0 + B*u0;
            xxx=[xxx x0];
            uuu=[uuu u0];
            xx=[xx x0];
            uu=[uu u0];
            if j==l+1
                D=[xxx(:,1:l);uuu(:,1:l)];
                X=[xxx(:,2:l+1)];
                xxx=[];
                uuu=[];
%                 j=0;
                noise=0;
                cost = D'*Lambda*D;
                [K,H]=lmiSolverMF(D,X,cost);
            end
                
end

%%
W=WfromH(H);

r_sumhat=0;
r_sumsol=0;

x_hat=5*randn(n,1);
x_sol=x_hat;
xx_sol=[];
xx_hat=[];

for k=1:400
    x_hat0=x_hat;
    u_0 = K*x_hat0;
    x_hat = A*x_hat0 + B*u_0;
    xx_hat = [xx_hat x_hat];
    r_sumhat = r_sumhat + x_hat0'*Q*x_hat0 + u_0'*R*u_0;
    %
    x_sol0 = x_sol;
    u_0_sol = K_sol*x_sol0;
    x_sol = A*x_sol0 + B*u_0_sol;
    xx_sol = [xx_sol x_sol];
    r_sumsol = r_sumsol + x_sol0'*Q*x_sol0 + u_0_sol'*R*u_0_sol;
end
r_sumhat
r_sumsol

figure(1)
subplot(2,2,1)
plot(1:length(xx),xx(1,:),'r')
grid on
xlabel('Time Step')
ylabel('x1')
title('State 1')
subplot(2,2,2)
plot(1:length(xx),xx(2,:),'r')
grid on
xlabel('Time Step')
ylabel('x2')
title('State 2')
subplot(2,2,3)
plot(1:length(xx),xx(3,:),'r')
grid on
xlabel('Time Step')
ylabel('x3')
title('State 3')
subplot(2,2,4)
plot(1:length(xx),xx(4,:),'r')
grid on
xlabel('Time Step')
ylabel('x4')
title('State 4')

figure(2)
subplot(2,2,1)
plot(1:length(xx),uu(1,:),'r')
grid on
xlabel('Time Step')
ylabel('u1')
title('Input 1')
subplot(2,2,2)
plot(1:length(xx),uu(2,:),'r')
grid on
xlabel('Time Step')
ylabel('u2')
title('Input 2')
subplot(2,2,3)
plot(1:length(xx),uu(3,:),'r')
grid on
xlabel('Time Step')
ylabel('u3')
title('Input 3')
subplot(2,2,4)
plot(1:length(xx),uu(4,:),'r')
grid on
xlabel('Time Step')
ylabel('u4')
title('Input 4')