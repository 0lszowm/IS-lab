function out = L1_dzban_rls(we)

global pd_ls
global P_ls
global yd
global yd1
global yd2

y=we(1);
y1=we(2);
y2=we(3);
u=we(4);
u2=we(5);

phi=[-y1 -y2 u2];
phi=phi';

P_ls=P_ls-(P_ls*phi*phi'*P_ls)/(1+phi'*P_ls*phi);
k=P_ls*phi;
epsilon=y-phi'*pd_ls;
pd_ls=pd_ls +k*epsilon;

yd2=yd1;
yd1=yd;
phi_d=[-yd1 -yd2 u2];
yd=phi_d*pd_ls;

phi_dp=[-y1 -y2 u2];
ydp=phi_dp*pd_ls;

out(1)=yd;
out(2)=ydp;
out(3)=pd_ls(3);
end
