function out = L2_czolg_rls(we)

global pd
global P
global yd
global yd1
global yd2
global lambda




y=we(1);
y1=we(2);
y2=we(3);
u=we(4);
u2=we(5);
pd1=[we(6); we(7); we(8)];

phi=[-y1 -y2 u2];
phi=phi';


si=[-y1 -y2 u2];
si=si';

P=(1/lambda)*(P-((P*si*phi'*P)/(lambda+phi'*P*si)));
k=P*si;
epsilon=y-phi'*pd1;
pd=pd1+k*epsilon;

% % to jest do tego co w ostatniej kropce jest
% V=diag([1,1,1])*10^-4;
% epsilon_max=0.3;
% P_min=20;
% Pp=P+V;
% k=Pp*phi*pinv(1+phi'*Pp*phi);
% P=Pp-k*phi'*Pp;
% epsilon=y-phi'*pd;
% pd=pd+k*epsilon;


yd2=yd1;

phi_d=[-yd1 -yd2 u2];
yd=phi_d*pd;
yd1=yd;

% if(abs(epsilon)>epsilon_max|(trace(P)<P_min))
%     P=[1 0 0; 0 1 0;0 0 1];
% end



out(1) = trace(P);
out(2) = yd;
out(3) = pd(1);
out(4) = pd(2);
out(5) = pd(3);
end

