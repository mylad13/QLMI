clear
close all

load AB_datane18.mat
% load neData.mat
n=length(a_mat);
m=size(b_pm,2);

Act=a_mat;
Bct=b_pm;

% Act=a_mat;
% Bct=zeros(n,2*m);
% for i=1:m
%     Bct(:,2*i-1)=b_pm(:,i);
%     Bct(:,2*i)=b_vr(:,i);
% end
% M=m;
% m=m*2;
M=m;
sys=ss(Act,Bct,eye(n),0);
sysd=c2d(sys,.05);
A=round(sysd.A,3);
B=round(sysd.B,3);
co=ctrb(A,B);
rank(co)
R=eye(m);
Q=eye(n);   
% for i=1:M
%     Q(i*7-6,i*7-6)=1;   Q(i*7-5,i*7-5)=1;  
% 	for j=1:M
%         if i~=j
%         Q(i*7-6,j*7-6)=-0.1;
%         end
%     end
% end
% for i=1:M
%     Q(i*4-3,i*4-3)=1;   Q(i*4-2,i*4-2)=1;  
% % 	for j=1:M
% %         if i~=j
% %         Q(i*4-3,j*4-3)=-0.1;
% %         end
% %     end
% end

Lambda=[Q zeros(length(Q),length(R));
        zeros(length(R),length(Q)) R];

for i=1:M
    strc_init{i}=[2*i-1,2*i];
end

% strc{1}=[1,2,15,16];    strc{2}=[3,4,5,6];  strc{3}=[3,4,5,6];  strc{4}=[7,8,9,10,11];
% strc{5}=[7,8,9,10]; strc{6}=[11,12,13,14];  strc{7}=[11,12,13,14];  strc{8}=[1,2,15,16]; 
% strc{9}=[17,18];


strc{1}=[1,2,3,4,15,16];    strc{2}=[1,2,3,4,5,6];  strc{3}=[3,4,5,6,9,10];
strc{4}=[7,8,9,10,13,14];   strc{5}=[5,6,7,8,9,10]; strc{6}=[11,12,13,14,17,18];
strc{7}=[7,8,11,12,13,14];  strc{8}=[1,2,15,16];    strc{9}=[11,12,17,18];

inputs{1}=[1,2,8];  inputs{2}=[1,2,3];  inputs{3}=[2,3,5];  inputs{4}=[4,5,7];
inputs{5}=[3,4,5];  inputs{6}=[6,7,9];  inputs{7}=[4,6,7];  inputs{8}=[1,8];
inputs{9}=[6,9];

P=dare(A,B,Q,R);
K_sol = -inv(R+B'*P*B)*B'*P*A;
% K_mb=lmiSolver(A,B,Lambda,eye(n) );
% K_init=K_sol+K_sol.*(rand(m,n)-0.5)*0.5;
% K=K_init;
K=lmiSolverC(A,B,Lambda,strc_init);
% K=zeros(m,n);
max(abs(eig(A+B*K)))
% init_poles= [0.8 -0.5 0.5 -0.8 0.2 -0.2 0.3 -0.3 0.4 -0.4 0.98 -0.98];
% init_K = place(A,B,init_poles);
% K=-init_K;
%%
samples=200;
j=0;

l=n+m;
noise_bias=round(1000*rand(m,1));
noise=ones(m,1);
noise_value=0.3;

xxx=[];
uuu=[];
xx=[];
uu=[];

disturbance=zeros(m,1);
% x=[5;0;5;0;5;0;5;0;5;0;5;0];
x=zeros(n,1);
x0=x;
u0= K*(x0) + noise_value*randn(m,1).*noise+disturbance;
x = A*x0 + B*(u0);
% setpoint=[5;0;5;0;5;0;5;0;5;0;5;0];
% setpoint=[1;0;0;0;0;0];

for i=1:samples
        x0=x;
%         if norm(K*x0)<10
%             noise_val(i)=0.1;
%         else
%             noise_val(i)=0.3*norm(K*x0);
%         end
        u0= K*x0 + noise_value*richnoiseN(i,m,noise_bias).*noise+disturbance;
%         u0= K*(x0) + noise_value*randn(m,1).*noise+disturbance;
        x = A*x0 + B*(u0);
        xxx=[xxx x0];
        uuu=[uuu u0];
        xx=[xx x0];
        uu=[uu u0];
        for k=1:m
            li=length(strc{k})+length(inputs{k});
            if i==li+1
                Di=[xxx(strc{k},1:li);uuu(inputs{k},1:li)];
                Xi=xxx([strc{k}],2:li+1);
                Ki=lmiSolverSSMF(Di,Xi,Lambda,strc{k},n+inputs{k});
                ind=find(inputs{k}==k);
                K(k,strc{k})=Ki(ind,:);
                noise(k)=0;
            end
        end
        if i==90
            disturbance(4)=5;
        end
        if i==100
            disturbance=disturbance*0;
        end
end
%%
% figure(1)
% subplot(3,2,1)
% plot(1:length(xx),xx(1,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('Angle Deviation (degree)')
% title('\theta_1')
% subplot(3,2,2)
% plot(1:length(xx),xx(3,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('Angle Deviation (degree)')
% title('\theta_2')
% subplot(3,2,3)
% plot(1:length(xx),xx(5,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('Angle Deviation (degree)')
% title('\theta_3')
% subplot(3,2,4)
% plot(1:length(xx),xx(7,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('Angle Deviation (degree)')
% title('\theta_4')
% subplot(3,2,5)
% plot(1:length(xx),xx(9,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('Angle Deviation (degree)')
% title('\theta_5')
% subplot(3,2,6)
% plot(1:length(xx),xx(11,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('Angle Deviation (degree)')
% title('\theta_6')
% 
% figure(2)
% subplot(3,2,1)
% plot(1:length(xx),xx(2,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('Speed Deviation (rad/s)')
% title('$\dot{\theta}_1$','interpreter','latex')
% subplot(3,2,2)
% plot(1:length(xx),xx(4,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('Speed Deviation (rad/s)')
% title('$\dot{\theta}_2$','interpreter','latex')
% subplot(3,2,3)
% plot(1:length(xx),xx(6,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('Speed Deviation (rad/s)')
% title('$\dot{\theta}_3$','interpreter','latex')
% subplot(3,2,4)
% plot(1:length(xx),xx(8,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('Speed Deviation (rad/s)')
% title('$\dot{\theta}_4$','interpreter','latex')
% subplot(3,2,5)
% plot(1:length(xx),xx(10,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('Speed Deviation (rad/s)')
% title('$\dot{\theta}_5$','interpreter','latex')
% subplot(3,2,6)
% plot(1:length(xx),xx(12,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('Speed Deviation (rad/s)')
% title('$\dot{\theta}_6$','interpreter','latex')
% 
% figure(3) %inputs
% subplot(3,2,1)
% plot(1:length(xx),uu(1,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('u1')
% title('Generator Input 1')
% subplot(3,2,2)
% plot(1:length(xx),uu(2,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('u2')
% title('Generator Input 2')
% subplot(3,2,3)
% plot(1:length(xx),uu(3,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('u3')
% title('Generator Input 3')
% subplot(3,2,4)
% plot(1:length(xx),uu(4,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('u4')
% title('Generator Input 4')
% subplot(3,2,5)
% plot(1:length(xx),uu(5,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('u5')
% title('Generator Input 5')
% subplot(3,2,6)
% plot(1:length(xx),uu(6,:),'r')
% grid on
% xlabel('Time Step')
% ylabel('u4')
% title('Generator Input 6')


figure(1)
plot(1:length(xx),xx(1,:),'-')
grid on
hold on
plot(1:length(xx),xx(3,:))
hold on
plot(1:length(xx),xx(5,:))
hold on
plot(1:length(xx),xx(7,:))
hold on
plot(1:length(xx),xx(9,:))
hold on
plot(1:length(xx),xx(11,:))
hold on
plot(1:length(xx),xx(13,:))
hold on
plot(1:length(xx),xx(15,:))
hold on
plot(1:length(xx),xx(17,:))
xlabel('Time Step')
ylabel('Angle Deviation (degree)')
legend('\theta_1','\theta_2','\theta_3','\theta_4','\theta_5'...
    ,'\theta_6','\theta_7','\theta_8','\theta_9')
axis([0 200 -1.5 3.5])
figure(2)
plot(1:length(xx),xx(2,:),'-')
grid on
hold on
plot(1:length(xx),xx(4,:))
hold on
plot(1:length(xx),xx(6,:))
hold on
plot(1:length(xx),xx(8,:))
hold on
plot(1:length(xx),xx(10,:))
hold on
plot(1:length(xx),xx(12,:))
hold on
plot(1:length(xx),xx(14,:))
hold on
plot(1:length(xx),xx(16,:))
hold on
plot(1:length(xx),xx(18,:))
xlabel('Time Step')
ylabel('Velocity Deviation (rad/s)')
legend('$\dot{\theta}_1$','$\dot{\theta}_2$','$\dot{\theta}_3$',...
    '$\dot{\theta}_4$','$\dot{\theta}_5$','$\dot{\theta}_6$'...
    ,'$\dot{\theta}_7$','$\dot{\theta}_8$','$\dot{\theta}_9$','interpreter','latex')

figure(3)
plot(1:length(xx),uu(1,:))
grid on
hold on
plot(1:length(xx),uu(2,:))
hold on
plot(1:length(xx),uu(3,:))
hold on
plot(1:length(xx),uu(4,:))
hold on
plot(1:length(xx),uu(5,:))
hold on
plot(1:length(xx),uu(6,:))
hold on
plot(1:length(xx),uu(7,:))
hold on
plot(1:length(xx),uu(8,:))
hold on
plot(1:length(xx),uu(9,:))
xlabel('Time Step')
ylabel('Generator Mechanical Power Input (pu)')
legend('u_1','u_2','u_3','u_4','u_5'...
    ,'u_6','u_7','u_8','u_9')
