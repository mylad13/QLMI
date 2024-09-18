clear
close all

A = [0.3 0.4 0.2 0.2;
     0.2 0.3 0.3 0.2;
     0.2 0.2 0.4 0.4;
     0.4 0.2 0.2 0.4]; %system 3 (unstable) high interatctions
B = eye(4);

n=size(B,1);
m=size(B,2);
states1=[1,2];  inputs1=[5,6];
states2=[2,3];  inputs2=[6,7];
states3=[3,4];  inputs3=[7,8];
states4=[1,4];  inputs4=[5,8];

strc{1}=states1;    strc{2}=states2;    strc{3}=states3;    strc{4}=states4; 
for i =1:m
    excl{i}=setdiff(1:n,strc{i});
end

Q = eye(4);
R = eye(4);
sol = dare(A,B,Q,R);
K_sol = -inv(R+B'*sol*B)*B'*sol*A;
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
l=4;

samples=40;
j=0;
noise=1;

for i = 1:samples
    j=j+1;
    x0=x;
    u0= K*x0 + 0.3*noise*randn(4,1);
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
        noise=0;
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

% figure(1)
% subplot(2,2,1)
% plot(1:length(xx),xx(1,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('x1')
% title('State 1')
% subplot(2,2,2)
% plot(1:length(xx),xx(2,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('x2')
% title('State 2')
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
% 
% figure(2)
% subplot(2,2,1)
% plot(1:length(xx),uu(1,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('u1')
% title('Input 1')
% subplot(2,2,2)
% plot(1:length(xx),uu(2,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('u2')
% title('Input 2')
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