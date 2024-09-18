function [K] = DisQlearningPI(A,B,Q,R,x,strc)
samples = 10000; % Number of samples
% --------------- System Definition
n=length(A);
m=size(B,2);
l=m+n;
lsize=l*(l+1)/2;

states=strc;
inputs=strc;

N=length(inputs);

sol = dare(A,B,Q,R);
K_sol = -inv(R+B'*sol*B)*B'*sol*A;

for i=1:N
    Ri{i}=R(inputs{i},inputs{i});
    Qi{i}=Q(states{i},states{i});
end


% --------------- Initital Stabilzing Control

% poles=linspace(-0.6,0.6,n);
poles= [0.8 -0.5 0.5 -0.8];
K_init = -place(A,B,poles);
for i = 1:N
    exc{i}=setdiff(1:n, states{i});
    K_init(i,exc{i})=0;
end

K=K_init;
% 
% K_N1 = [K(1,1) K(1,2)];
% K_N2 = [K(2,2) K(2,3)];
% K_N3 = [K(3,3) K(3,4)];
% K_N4 = [K(4,1) K(4,4)];
% 
% KK=[K_N1 0 0;0 K_N2(1) K_N2(2) 0; 0 0 K_N3; K_N4(1) 0 0 K_N4(2)];


% --------------- Initialization
beta=10; %for S matrix in RLS
gamma = 1; %Discount Factor
upd_thrsh = 5e-4; %threshhold before updating
stop_thrsh = 5e-4; %Noise stop threshhold
noise_val = 0.3;
base=eye(N); 
for i = 1:N
    ni{i}=length(states{i});
    mi{i}=length(inputs{i});
    li{i}=mi{i}+ni{i};
    lisize{i}=(li{i})*(li{i}+1)/2;
    H{i}=eye(li{i});
    W{i}=WfromH(H{i});
    WW{i}=W{i}; %saves W over time
    WWW{i}=[];
    S{i}=beta*eye(lisize{i});
    add_noise{i}=noise_val*base(:,i);
    noise_stop(i)=false;
    j{i}=0; %update counter
    upd{i}=[]; %saves update timesteps
end

% x=2*randn(n,1);
x_init=x;


xx=[];
uu=[];

sw = 1; %switches between subsystems
%%
for k=1:samples
    x0 = x;
    u0 = K*x + add_noise{sw}*richnoise(k,lsize);
%     u0 = K*x + add_noise{sw}*randn(1);
    phi0 = mod_kron([x0(states{sw});u0(inputs{sw})]);
    x = A*x0 + B*u0;
    u = K*x;
    phi = mod_kron([x(states{sw});u(inputs{sw})]);
    Phi = phi0-gamma*phi;
    r = x0(states{sw})'*Qi{sw}*x0(states{sw}) + u(inputs{sw})'*Ri{sw}*u(inputs{sw});
    W0 = W{sw};
    S0=S{sw};
    [W{sw}, S{sw}] = RLS(Phi,r,W0,S0);
    WW{sw} = [WW{sw} W{sw}];
    j{sw}=j{sw}+1;
    if (j{sw}>lisize{sw}) && (norm(W{sw}-W0)<upd_thrsh)
        j{sw} = 0;
        WWW{sw} = [WWW{sw} W{sw}]; %saved W updates
        upd{sw} = [upd{sw} k];
        H{sw} = HfromW(W{sw});
        Ki{sw} = -inv(H{sw}(ni{sw}+1:ni{sw}+mi{sw},ni{sw}+1:ni{sw}+mi{sw}))*...
            H{sw}(ni{sw}+1:ni{sw}+mi{sw},1:ni{sw});
        ind=find(inputs{sw}==sw);
        K(sw,states{sw})=Ki{sw}(ind,:);
        S{sw} = beta*eye(lisize{sw});
        if (size(WWW{sw},2)>1) 
            if (norm(WWW{sw}(:,end)-WWW{sw}(:,end-1))<stop_thrsh)
                add_noise{sw}=0*base(:,sw);
                if noise_stop(sw)==false
                    noise_stop(sw)=true;
                    stop_time(sw)=k;
                end
            end
        end     
        sw=sw+1;
    end
    
    if mod(sw,N)==1
        sw=1;
    end
    xx = [xx x0];
    uu = [uu u0];
end


%%
% eigvalues=eig(A+B*K);
% r_sumhat=0;
% r_sumsol=0;
% 
% x_hat=5*randn(n,1);
% x_sol=x_hat;
% xx_sol=[];
% xx_hat=[];
% 
% for k=1:200
%     x_hat0=x_hat;
%     u_0 = K*x_hat0;
%     x_hat = A*x_hat0 + B*u_0;
%     xx_hat = [xx_hat x_hat];
%     r_sumhat = r_sumhat + x_hat0'*Q*x_hat0 + u_0'*R*u_0;
%     %
%     x_sol0 = x_sol;
%     u_0_sol = K_sol*x_sol0;
%     x_sol = A*x_sol0 + B*u_0_sol;
%     xx_sol = [xx_sol x_sol];
%     r_sumsol = r_sumsol + x_sol0'*Q*x_sol0 + u_0_sol'*R*u_0_sol;
% end
% r_sumhat
% r_sumsol
% 
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




end

