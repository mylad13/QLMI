clear; 

A = [0.2 0.7 0.0 0.0; 
     0.0 0.4 0.7 0.0;
     0.0 0.0 0.5 0.8;
     0.7 0.0 0.0 0.4]; %system 1 (unstable) no interactions
% A = [0.36 0.46 0.11 0.12;
%      0.11 0.36 0.35 0.12;
%      0.13 0.13 0.48 0.49;
%      0.47 0.12 0.12 0.48]; %system 2 (unstable) low interactions
% A = [0.3 0.4 0.2 0.2;
%      0.2 0.3 0.3 0.2;
%      0.2 0.2 0.4 0.4;
%      0.4 0.2 0.2 0.4]; %system 3 (unstable) high interatctions
% A = [0.3 0.4 0.0 0.0;
%      0.0 0.3 0.3 0.0;
%      0.0 0.0 0.4 0.4;
%      0.4 0.0 0.0 0.4]; %system 4 (stable) no interactions
% A = [0.3 0.4 0.1 0.1;
%      0.1 0.3 0.3 0.1;
%      0.1 0.1 0.4 0.4;
%      0.4 0.1 0.1 0.4]; %system 5 (stable) low interactions
% A = [0.25 0.35 0.15 0.14;
%      0.15 0.25 0.25 0.15;
%      0.14 0.14 0.34 0.33;
%      0.34 0.14 0.14 0.33]; %system 6 (stable) high interactions

B = eye(4);

Q = eye(4);
Q = 3*eye(4);   Q(1,2)=-1;  Q(2,3)=-1;  Q(3,4)=-1;  Q(4,1)=-1;
Q(2,1)=-1;  Q(3,2)=-1;  Q(4,3)=-1;  Q(1,4)=-1;

R = eye(4);
 
sol = dare(A,B,Q,R);
K_sol = -inv(R+B'*sol*B)*B'*sol*A;

x = [5;5;5;5];
x=5*randn(4,1);
runs=20;  
xx = [];
load('initialconditions.mat')
% states{1}=[1,2];    states{2}=[2,3];    states{3}=[3,4];    states{4}=[1,4];
% inputs=states;

%%

K1=QlearningPI(A,B,Q,R,x);
K2=QlearningLMI(A,B,Q,R,x);
% [rPI,ropt]=sysrun(A,B,K3,x)
% rVI=sysrun(A,B,K4,x)
% rLMI=sysrun(A,B,K5,x)
%%
for i=1:runs
%     x=5*randn(4,1);
%     xx=[xx x];
    x=xx(:,i);
    [rPI,ropt]=sysrun(A,B,Q,R,K1,x);
    rLMI=sysrun(A,B,Q,R,K2,x);
    V_opt(i)=ropt;
    V_LMI(i)=rLMI;
    V_PI(i)=rPI;
end
PIavg=sum(V_PI)/runs
LMIavg=sum(V_LMI)/runs
Optavg=sum(V_opt)/runs
% Lmipercent=(LMIavg-Optavg)/Optavg