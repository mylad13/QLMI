clear
close all

A = [0.3 0.4 0.2 0.2;
     0.2 0.3 0.3 0.2;
     0.2 0.2 0.4 0.4;
     0.4 0.2 0.2 0.4]; %system 3 (unstable) high interatctions
B = eye(4);


Q = eye(4);
Q = 3*eye(4);   Q(1,2)=-1;  Q(2,3)=-1;  Q(3,4)=-1;  Q(4,1)=-1;
Q(2,1)=-1;  Q(3,2)=-1;  Q(4,3)=-1;  Q(1,4)=-1;
R = eye(4);

sol = dare(A,B,Q,R);
Lambda = [Q zeros(4);zeros(4) R];

Za=eye(4);
Zb = zeros(4);
z2=[1 -4 1 4 5;2 2 0 4 1;5 3 9 1 2; 7 4 1 2 3];
for i = 1:5
    Zb=Zb + z2(:,i)*z2(:,i)';
end

K_sol = -inv(R+B'*sol*B)*B'*sol*A; %obtained from solving the Riccati equation

[Ka,Ha,H11a,H12Ta,H22a,Wa,const2a]=lmiSolver(A,B,Lambda,Za);
[Kb,Hb,H11b,H12Tb,H22b,Wb,const2b]=lmiSolver(A,B,Lambda,Zb);

