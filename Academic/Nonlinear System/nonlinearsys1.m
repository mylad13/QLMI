function [x] = nonlinearsys1(x0,u0)
x=zeros(4,1);
x(1)=x0(3)^2+u0(1);
x(2)=x0(3)*x0(2)*u0(2)+0.5*x0(3);
x(3)=x0(4)+u0(3);
x(4)=u0(4)+x0(4)*x0(2)-x0(3);
end

