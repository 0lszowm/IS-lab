clear all, close all, clc;
%% z pominięciem L_a
syms s;
syms Ra;
syms Ki;
syms Jz;
syms Ke;
syms La;
syms z;

%Go = (1/(Ra))*Ki*(1/(Jz*s));
Go = (1/(La*s+Ra))*Ki*(1/(Jz*s));
Gz = Go/(1+Go*Ke);
Gz = simplify(Gz)

% Celem modelowania jest Uzyskanie symulatora wyjaśniającego odpowiedź systemu na poziomie J_FIT>90%.
load dane.mat
data = iddata(out, in, 0.1);
figure(1111)
plot(in)
hold on;
plot(out)
tp = 0.1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%









u = in;
y = out;

N=400; Tp=0.1; t=0:Tp:(N-1)*Tp;
step=1;

figure(1)
subplot(2,1,1)
plot(u, 'green')
title("Wejscie obiektu")
subplot(2,1,2)
plot(y, color="#4DBEEE")
title("Wyjscie obiektu+zakłócenie biale")

%%
% tutaj nizej dziela sie te dane na podzbiory po 200 probek
u_Est = u(1:N/2);
u_Wer = u(N/2+1:N);

y_Est = y(1:N/2);
y_Wer = y(N/2+1:N);
%% dla testu tu LS second order
disp('---------------------------------------------')
disp('Metoda LS 2 rzad')
phi = [];
for i=3:1:length(y_Est) % Modify the loop to start from 3 instead of 2
    phi(i,:)=[y_Est(i-1) y_Est(i-2) u_Est(i-1) u_Est(i-2)]; % Modify phi matrix to include two previous y and u values
end

PN_LS = pinv(phi) * y_Est;
p = PN_LS;

kp_t = (p(4)+p(3))/(1 - p(1)-p(2)); % Correct calculation of kp for a second-order system
T = -Tp / log(p(2)); % Calculate T using the appropriate element of p
Td = -Tp / log(p(1)); % Calculate Td using the appropriate element of p

% Create the transfer function
s = tf('s');
kp_t
T
Td
G_est_secondOrder = kp_t / ((T*s + 1) * (Td*s + 1));
G_est_secondOrder
c2d(G_est_secondOrder, Tp)

t = 0:tp:tp*(length(u_Wer)-1);
y_est = lsim(G_est_secondOrder, u_Wer, t);

% Ocena identyfikacji tutaj liczy sie
Nv=length(y_Wer);
Vp=1/Nv*sum((y_Wer-y_est).^2);
Vp
% przedzial ufnosci nizej sie liczy, dokladnie tak samo jak w pierwszych
% na zajeciach wczesniej, wiec powinno byc git
cov0=Vp^2*(phi'*phi)^-1;
for i=1:4
    ans_d(i)=PN_LS(i)-1.96*sqrt(cov0(i,i));
    ans_g(i)=PN_LS(i)+1.96*sqrt(cov0(i,i));
end
przedzial1=[ans_d(1) ans_g(1)];
przedzial2=[ans_d(2) ans_g(2)];
przedzial3=[ans_d(1) ans_g(1)];
przedzial4=[ans_d(2) ans_g(2)];

figure(2)
plot(y_Wer, color="#006BB6")
title("Zb.Wer Metoda LS II rząd")
hold on
plot(y_est, color="#F58426")
hold on
legend("Dane pomiarowe", "Identyfikacja", location="best")

% Calculate fit metrics
[Jfit] = calculateFitMetrics(y_Wer, y_est);
[VPEn] = VPE(4, Vp, N/2);

%% Dla testu jest tu IV second order
disp('---------------------------------------------')
disp('Metoda IV 2 rzad')
Z = [];
for i = 3:length(y_est)
    Z(i,:) = [y_est(i-1) y_est(i-2) u_Est(i-1) u_Est(i-2)];
end

PN_IV = (Z' * phi)^(-1) * Z' * y_Est;

p_ulepszone=PN_IV; % ulepszone bo liczone ponownie druga metoda;
kp_t = (p_ulepszone(4)-p_ulepszone(3))/(1 - p_ulepszone(1)); % Correct calculation of kp for a second-order system
T = -Tp / p_ulepszone(2); % Calculate T using the appropriate element of p
Td = Tp / p_ulepszone(1); % Calculate Td using the appropriate element of p
s = tf('s');
kp_t
T
Td
G_est_secondOrder = kp_t / ((T*s + 1) * (Td*s + 1));
G_est_secondOrder
c2d(G_est_secondOrder, Tp)

t = 0:tp:tp*(length(u_Wer)-1);
y_est_ulepszone= lsim(G_est_secondOrder, u_Wer, t);

figure(3)
plot(y_Wer, color="#006BB6")
title("Zb.Wer metoda IV II rząd")
hold on
plot(y_est_ulepszone, color="#F58426")
legend("Dane pomiarowe", "Identyfikacja", location="best")
% Ocena identyfikacji tutaj liczy sie
Nv=length(y_Wer);
Vp=1/Nv*sum((y_Wer-y_est_ulepszone).^2);
% przedzial ufnosci nizej sie liczy, dokladnie tak samo jak w pierwszych
% na zajeciach wczesniej, wiec powinno byc git
cov0=Vp^2*(Z'*Z)^-1;
for i=1:4
    ans_d(i)=PN_IV(i)-1.96*sqrt(cov0(i,i));
    ans_g(i)=PN_IV(i)+1.96*sqrt(cov0(i,i));
end
przedzial1=[ans_d(1) ans_g(1)];
przedzial2=[ans_d(2) ans_g(2)];
przedzial3=[ans_d(1) ans_g(1)];
przedzial4=[ans_d(2) ans_g(2)];

[Jfit] = calculateFitMetrics(y_Wer, y_est_ulepszone);
[VPEn] = VPE(4, Vp, N/2);

%% A tu sie liczy gotowa funkcja matlabowa tfest()
disp('---------------------------------------------')
disp('Matlabowa funkcja tfest()')
np = 1;
t = 0:tp:tp*(length(u_Est)-1);
sys = tfest(u_Est, y_Est, np, 'Ts', tp);
sys
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out_2 = lsim(sys, u_Wer, t);
figure(2222)
plot(out_2, color="#006BB6")
hold on;
title("Zb.Wer tfest() 1 rząd")
plot(y_Wer, color="#F58426")
[Jfit] = calculateFitMetrics(y_Wer, out_2);

%% A tu sie liczy gotowa funkcja matlabowa tfest()
disp('---------------------------------------------')
disp('Matlabowa funkcja tfest() 2 rząd')
np = 2;
t = 0:tp:tp*(length(u_Est)-1);
sys = tfest(u_Est, y_Est, np, 'Ts', tp);
sys
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out_2 = lsim(sys, u_Wer, t);
figure(2223)
plot(out_2, color="#006BB6")
hold on;
title("Zb.Wer tfest() 2 rząd")
plot(y_Wer, color="#F58426")
[Jfit] = calculateFitMetrics(y_Wer, out_2);
%% tutaj tym wbudowanym sprobowac mozna xddd
%systemIdentification

