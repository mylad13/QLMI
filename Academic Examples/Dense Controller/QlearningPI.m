function [K] = QlearningPI(A,B,Q,R,x)
samples = 5000; % Number of samples
% --------------- System Definition
n=length(A);
m=size(B,2);
l=m+n;
lsize=l*(l+1)/2;

sol = dare(A,B,Q,R);
H_sol=[Q+A'*sol*A A'*sol*B; B'*sol*A R+B'*sol*B];
W_sol=WfromH(H_sol);
K_sol = -inv(R+B'*sol*B)*B'*sol*A;

% --------------- Initital Stabilzing Control

% poles=linspace(-0.6,0.6,n);
poles= [0.8 -0.5 0.5 -0.8];
K_init = -place(A,B,poles);
K=K_init;


% --------------- Initialization
beta=1000; %for S matrix in RLS
gamma = 1; %Discount Factor
upd_thrsh = 5e-3; %threshhold before updating
stop_thrsh = 5e-2; %Noise stop threshhold
noise_val = 1.5;
bias=round(1000*rand(4,1));

S = beta*eye(lsize);
H=eye(l);
W=WfromH(H);
WW=W; %saves W over time
WWW=[];
add_noise=noise_val;
noise_stop=false;
j=0; %update counter
upd=[]; %saves update timesteps


% x=5*randn(n,1);
% x=[1;2;3;4];
x_init=x;


xx=[];
uu=[];

%%
for k=1:samples
    x0 = x;
    u0 = K*x + add_noise*randn(4,1);
%     u0 = K*x + add_noise*richnoiseN(k,4,bias);
    phi0 = mod_kron([x0;u0]);
    x = A*x0 + B*u0;
    u = K*x;
    phi = mod_kron([x;u]);
    Phi = phi0-gamma*phi;
    r = x0'*Q*x0 + u'*R*u;
    W0 = W;
    S0=S;
    [W, S] = RLS(Phi,r,W0,S0);
    WW = [WW W];
    j=j+1;
    if (j>lsize) && (norm(W-W0)<upd_thrsh)
        j = 0;
        WWW = [WWW W]; %saved W updates
        upd = [upd k];
        H = HfromW(W);
        K = -inv(H(n+1:n+m,n+1:n+m))*...
            H(n+1:n+m,1:n);
        S = beta*eye(lsize);
        if (size(WWW,2)>1) 
            if (norm(WWW(:,end)-WWW(:,end-1))<stop_thrsh)
                add_noise=0;
                if noise_stop==false
                    noise_stop=true;
                    stop_time=k;
                end
            end
        end     
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

