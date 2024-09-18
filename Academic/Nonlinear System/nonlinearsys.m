function [x] = nonlinearsys(x0,u0)
x=zeros(4,1);
x(1)=-x0(4)+x0(1)*x0(2)*u0(1);
x(2)=-x0(3)*x0(2)*u0(2);
x(3)=u0(3)+x0(4);
x(4)=u0(4)+x0(4)*x0(2)-x0(3);
end

