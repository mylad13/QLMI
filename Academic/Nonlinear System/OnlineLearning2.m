clear
close all
n=2;
m=2;
states{1}=[1,2,4];    states{2}=[2,3];    states{3}=[3,4];    states{4}=[2,3,4];
inputs=states;
strc{1}=states{1};    strc{2}=states{2};    strc{3}=states{3};    strc{4}=states{4}; 
for i =1:m
    excl{i}=setdiff(1:n,strc{i});
end

Q = eye(m);
R = eye(n);

Lambda=[Q zeros(length(Q),length(R));
        zeros(length(R),length(Q)) R];


K=zeros(m,n);
% init_poles= [0.8 -0.5 0.5 -0.8];
% init_K = place(A,B,init_poles);
% K=-init_K;

x=[4;-2];
xx=[];
uu=[];
xxx=[];
uuu=[];
l=m+n;

samples=60;
j=0;
noise=1;
% setpoint=[4;0;0;0];

for i = 1:samples
    j=j+1;
    x0=x;
    u0= K*(x0) + 0.2*noise*randn(m,1);
    x = nonlinearsys1(x0,u0);
    xx=[xx x0];
    uu=[uu u0];
    xxx=[xxx x0];
    uuu=[uuu u0];
    if (j==l+1) 
        D=[xxx(:,1:l);uuu(:,1:l)];
        X=[xxx(:,2:l+1)];
        cost=D'*Lambda*D;
        xxx=[];
        uuu=[];
%         K=lmiSolverCMF(D,X,cost,strc);
        K=lmiSolverMF(D,X,cost);
        noise=0;
    end
end
    

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
% subplot(2,2,3) 
% plot(1:length(xx),uu(3,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('u3')
% title('Input 3')
% subplot(2,2,4) 
% plot(1:length(xx),uu(4,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('u4')
% title('Input 4')

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
% subplot(2,2,3) 
% plot(1:length(xx),xx(3,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('x3')
% title('State 3')
% subplot(2,2,4) 
% plot(1:length(xx),xx(4,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('x4')
% title('State 4')
