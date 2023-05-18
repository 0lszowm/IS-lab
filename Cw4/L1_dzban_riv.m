function out = L1_dzban_riv(we)

global pd_iv
global P_iv
global yd
global yd1
global yd2
global xd
global xd1
global xd2
global z

xd=we(1);
xd1=we(2);
xd2=we(3);
u=we(4);
u2=we(5);
y = we(6);
y1 = we(7);
y2 = we(8);

phi=[-y1 -y2 u2];
phi=phi';

%xd2=xd1;
phi_d=[-xd1 -xd2 u2];

%xd=phi_d*pd_iv;
%xd1=xd;

z=[-xd1 -xd2 u2];
z=z';

P_iv=P_iv-(P_iv*z*phi'*P_iv)/(1+phi'*P_iv*z);
k=P_iv*z;
epsilon=y-phi'*pd_iv;
pd_iv=pd_iv +k*epsilon;

yd2=yd1;
phi_d=[-yd1 -yd2 u2];

yd=phi_d*pd_iv;
yd1=yd;

phi_dp=[-y1 -y2 u2];
ydp=phi_dp*pd_iv;

out(1) = yd;
out(2) = ydp;
out(3)=pd_iv(3);
out(4) = trace(P_iv);
end
