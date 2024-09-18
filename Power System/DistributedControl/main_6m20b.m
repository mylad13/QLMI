clear
load AB_6m20b.mat


Act=a_mat;
Bct=b_pm;
n=length(Act);
m=size(Bct,2);
sys=ss(Act,Bct,eye(n),0);
sysd=c2d(sys,0.1);
A=round(sysd.A,2);
B=round(sysd.B,3);
% A=sysd.A;
% B=sysd.B;
co=ctrb(A,B);
rank(co)
Q=eye(n);   R=eye(m);
% for i=1:m
%     Q(i*4,i*4)=0;   Q(i*4-1,i*4-1)=0;
% end
Lambda=[Q zeros(length(Q),length(R));
        zeros(length(R),length(Q)) R];
    
P=dare(A,B,Q,R);
K_sol = -inv(R+B'*P*B)*B'*P*A;

for i =1:m
    ss{i}=i*2-1:i*2;
end
% Decent Communication
inputs{1}=[1 2 3 4 5];    inputs{2}=[1 2 5];      inputs{3}=[1 2 3 6];    inputs{4}=[1 4 5];
inputs{5}=[1 2 4 5];      inputs{6}=[1 3 6];

% Scarse Communication
inputs{1}=[1 2 4 5];    inputs{2}=[1 2 5];      inputs{3}=[1 3 6];    inputs{4}=[1 4 5];
inputs{5}=[1 2 5];      inputs{6}=[3 6];

% All the Communications!
% inputs{1}=[1 2 3 4 5 6];    inputs{2}=[1 2 3 4 5 6];      inputs{3}=[1 2 3 4 5 6]; 
% inputs{4}=[1 2 3 4 5 6];    inputs{5}=[1 2 3 4 5 6];      inputs{6}=[1 2 3 4 5 6];

for i=1:m
    states{i}=[];
    for j=1:length(inputs{i})
        states{i}=[states{i} ss{inputs{i}(j)}];
    end
end
clear i j
% poles=[0.25+0.7j 0.25-0.7j 0.3+0.7j 0.3-0.7j 0.4+0.7j 0.4-0.7j...
%        0.15+0.8j 0.15-0.8j 0.75+0.2j 0.75-0.2j];
% poles=[0.765988423522344 + 0.178434812463863i;0.765988423522344 - 0.178434812463863i;0.145772781351507 + 0.800722353874655i;0.145772781351507 - 0.800722353874655i;0.372042220150626 + 0.728227498776062i;0.372042220150626 - 0.728227498776062i;0.330010564563540 + 0.730048102837193i;0.330010564563540 - 0.730048102837193i;0.245179243230024 + 0.746664431392746i;0.245179243230024 - 0.746664431392746i];
   
% K_init = -place(A,B,poles);
K_init=K_sol+K_sol.*(rand(m,n)-0.5)*1;
% for i = 1:m
%     exc{i}=setdiff(1:n, states{i});
%     K_init(i,exc{i})=0;
% end
K=zeros(m,n);

%% RLS
% K = sparsefunc(A,B,Q,R,states,inputs);

%%

l=n+m;
noise_bias=round(1000*rand(m,1));
xxx=[];
uuu=[];
x=[5;0;5;0;5;0;5;0;5;0;5;0];
x1=x;
for i=1:l+1
            x0=x;
%             u0= K*x0 + 0.5*richnoise4(i);
            if norm(K_init*x0)<10
                noise_val(i)=0.1;
            else
                noise_val(i)=0.3*norm(K_init*x0);
            end
            u0= K_init*x0 + noise_val(i)*richnoiseN(i,m,noise_bias);
%             u0= K*x0;
%             u0= 0.3*richnoise4(i+4);
%             u0= 0.5*randn(m,1);
            x = A*x0 + B*u0;
            xxx=[xxx x0];
            uuu=[uuu u0];
            

end
D=[xxx(:,1:l);uuu(:,1:l)];
X=[xxx(:,2:l+1)];
cost=D'*Lambda*D;
%%

K=lmiSolverMF(D,X,cost);

%%
% K=zeros(m,n);
% for i=1:m
%     Ai=A(states{i},states{i});    Bi=B(states{i},inputs{i});
%     Ki=lmiSolverSS(Ai,Bi,states{i},n+inputs{i},Lambda);
%     ind=find(inputs{i}==i);
%     K(i,states{i})=Ki(ind,:);
% end

%%
% [K,H]=lmiSolverSS(cell2mat(Ass(i)),cell2mat(Bss(i)),cell2mat(states(i)),n+cell2mat(states(i)),Lambda);
% ind=find(cell2mat(states(i))==i);
% Ki=K(ind,:)

%%

x=5*randn(n,1);
x2=x;
x_sol = x;
r_sum=0;
r_sumsol=0;
xx=[x];
xx_sol=[x_sol];
uu=[];
uu_sol=[];

for k = 1:100
    x0=x;
    u0=K*x0;
    x = A*x0 + B*u0;
    xx = [xx x];
    uu = [uu u0];
    r_sum = r_sum + x0'*Q*x0 + u0'*R*u0;
    
    x_sol0=x_sol;
    u0_sol=K_sol*x_sol0;
    x_sol = A*x_sol0 + B*u0_sol;
    xx_sol = [xx_sol x_sol];
    uu_sol = [uu_sol u0_sol];
    r_sumsol = r_sumsol + x_sol0'*Q*x_sol0 + u0_sol'*R*u0_sol;
end
r_sum
r_sumsol
difference_percentage=100*(r_sum-r_sumsol)/r_sumsol

figure(1)
subplot(3,2,1)
plot(1:length(xx),xx(1,:),'r')
grid on
xlabel('Time Step')
ylabel('x1')
title('State 1')
subplot(3,2,2)
plot(1:length(xx),xx(3,:),'r')
grid on
xlabel('Time Step')
ylabel('x2')
title('State 2')
subplot(3,2,3)
plot(1:length(xx),xx(5,:),'r')
grid on
xlabel('Time Step')
ylabel('x3')
title('State 3')
subplot(3,2,4)
plot(1:length(xx),xx(7,:),'r')
grid on
xlabel('Time Step')
ylabel('x4')
title('State 4')
subplot(3,2,5)
plot(1:length(xx),xx(9,:),'r')
grid on
xlabel('Time Step')
ylabel('x4')
title('State 4')
subplot(3,2,6)
plot(1:length(xx),xx(11,:),'r')
grid on
xlabel('Time Step')
ylabel('x4')
title('State 4')
