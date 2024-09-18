function [r_sum,r_sumsol] = sysrun(A,B,Q,R,K,x)
P = dare(A,B,Q,R);
Hs = [Q+A'*P*A A'*P*B; B'*P*A R+B'*P*B];
K_sol = -inv(Hs(5:8,5:8))*Hs(5:8,1:4);
x_sol = x;
r_sum=0;
r_sumsol=0;
for k = 1:50
    x0=x;
    u0=K*x0;
    x = A*x0 + B*u0;
    r_sum = r_sum + x0'*Q*x0 + u0'*R*u0;
    
    x_sol0=x_sol;
    u0_sol=K_sol*x_sol0;
    x_sol = A*x_sol0 + B*u0_sol;
    r_sumsol = r_sumsol + x_sol0'*Q*x_sol0 + u0_sol'*R*u0_sol;
end

end

