clear
close all

n=4;
m=4;

% states1=[1,2,4];    states2=[2,3];    states3=[3,4];    states4=[2,3,4];
% inputs1=states1;    inputs2=states2;    inputs3=states3;    inputs4=states4;

states{1}=[1,3];    states{2}=[2,3];    states{3}=[3,4];    states{4}=[2,3,4];
inputs=states;
strc{1}=states{1};    strc{2}=states{2};    strc{3}=states{3};    strc{4}=states{4}; 
for i =1:m
    excl{i}=setdiff(1:n,strc{i});
end

Q = eye(4);
R = eye(4);

Lambda = [Q zeros(4);zeros(4) R];

K=zeros(4);
% init_poles= [0.8 -0.5 0.5 -0.8];
% init_K = place(A,B,init_poles);
% K=-init_K;

x=[4;3;2;1];
xx=[];
uu=[];
xxx=[];
uuu=[];
l=8;

samples=40;
j=0;
noise=ones(m,1);
% setpoint=[4;0;0;0];
for i=1:samples
        x0=x;
        u0= K*(x0) + 0.1*randn(4,1).*noise;
        x = nonlinearsys1(x0,u0);
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
        
end
    
figure(2)
subplot(2,2,1)
plot(1:length(xx),uu(1,:),'r')
grid on
xlabel('Time Step', 'FontSize', 16)
ylabel('u_1', 'FontSize', 16)
title('Input 1')
subplot(2,2,2)
plot(1:length(xx),uu(2,:),'r')
grid on
xlabel('Time Step', 'FontSize', 16)
ylabel('u_2', 'FontSize', 16)
title('Input 2')
subplot(2,2,3) 
plot(1:length(xx),uu(3,:),'r')
grid on
xlabel('Time Step', 'FontSize', 16)
ylabel('u_3', 'FontSize', 16)
title('Input 3')
subplot(2,2,4) 
plot(1:length(xx),uu(4,:),'r')
grid on
xlabel('Time Step', 'FontSize', 16)
ylabel('u_4', 'FontSize', 16)
title('Input 4')
figure(1)
subplot(2,2,1)
plot(1:length(xx),xx(1,:),'r')
grid on
xlabel('Time Step', 'FontSize', 16)
ylabel('x_1', 'FontSize', 16)
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