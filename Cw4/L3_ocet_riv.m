function out = L3_ocet_riv(we)
global pd 
global P
global yd1 
global yd2

lambda=1;

y=we(1);
yf=we(2);
yf1=we(3);
yf2=we(4);
uf=we(5);
xf=we(6);
xf1=we(7);



z=[-xf1; -xf; uf];

phi=[-yf1; -yf; uf];


si=z;

P=(1/lambda)*(P-((P*si*phi'*P)/(lambda+phi'*P*si)));
k=P*si;
epsilon=yf2-phi'*pd;
pd=pd+k*epsilon;


out(1)=epsilon;
out(2)=pd(1);
out(3)=pd(2);
out(4)=pd(3);
end