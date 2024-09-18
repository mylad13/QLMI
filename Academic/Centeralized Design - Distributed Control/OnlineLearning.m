clear
close all

A = [0.3 0.4 0.2 0.2;
     0.2 0.3 0.3 0.2;
     0.2 0.2 0.4 0.4;
     0.4 0.2 0.2 0.4]; %system 3 (unstable) high interatctions
B = eye(4);

n=size(B,1);
m=size(B,2);
states{1}=[1,2];    states{2}=[2,3];    states{3}=[3,4];    states{4}=[1,4];
inputs=states;
strc{1}=states{1};    strc{2}=states{2};    strc{3}=states{3};    strc{4}=states{4}; 
for i =1:m
    excl{i}=setdiff(1:n,strc{i});
end

Q = eye(4);
Q = 3*eye(4);   Q(1,2)=-1;  Q(2,3)=-1;  Q(3,4)=-1;  Q(4,1)=-1;
Q(2,1)=-1;  Q(3,2)=-1;  Q(4,3)=-1;  Q(1,4)=-1;
R = eye(4);

Lambda = [Q zeros(4);zeros(4) R];

K=zeros(4);
% init_poles= [0.8 -0.5 0.5 -0.8];
% init_K = place(A,B,init_poles);
% K=-init_K;

x=[1;2;3;4];
xx=[];
uu=[];
xxx=[];
uuu=[];
l=8;

samples=30;
j=0;
noise=1;
% setpoint=[4;0;0;0];

for i = 1:samples
    j=j+1;
    x0=x;
    u0= K*(x0) + 0.05*noise*randn(4,1);
    x = A*x0 + B*u0;
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
        K=lmiSolverCMF(D,X,cost,strc);
        noise=0;
    end
end
    
figure(1)
plot(1:length(xx),xx(1,:))
grid on
hold on
plot(1:length(xx),xx(2,:),'r')
hold on
plot(1:length(xx),xx(3,:),'m')
hold on
plot(1:length(xx),xx(4,:),'k')
xlabel('Time Step')
ylabel('State values')
legend('x_1','x_2','x_3','x_4')

figure(2)
subplot(2,2,1)
plot(1:length(xx),xx(1,:),'r')
grid on
xlabel('Time Step', 'FontSize', 16)
ylabel('x_1')
title('State 1')
subplot(2,2,2)
plot(1:length(xx),xx(2,:),'r')
grid on
xlabel('Time Step', 'FontSize', 16)
ylabel('x_2', 'FontSize', 16)
title('State 2')
subplot(2,2,3) 
plot(1:length(xx),xx(3,:),'r')
grid on
xlabel('Time Step', 'FontSize', 16)
ylabel('x_3', 'FontSize', 16)
title('State 3')
subplot(2,2,4) 
plot(1:length(xx),xx(4,:),'r')
grid on
xlabel('Time Step', 'FontSize', 16)
ylabel('x_4', 'FontSize', 16)
title('State 4')
% figure(2)
% plot(1:length(xx),uu(1,:))
% grid on
% hold on
% plot(1:length(xx),uu(2,:),'r')
% hold on
% plot(1:length(xx),uu(3,:),'m')
% hold on
% plot(1:length(xx),uu(4,:),'k')
% xlabel('Time Step')
% ylabel('Input values')
% legend('u_1','u_2','u_3','u_4')