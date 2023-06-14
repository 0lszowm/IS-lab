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
tp = 0.1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%









u = in;
y = out;

N=400; Tp=0.1; t=0:Tp:(N-1)*Tp;
step=1;

figure(1)
subplot(2,1,1)
plot(u, color="#006BB6")
title("Wejscie obiektu")
subplot(2,1,2)
plot(y, color="#F58426")
title("Wyjscie obiektu")
%%
% tutaj nizej dziela sie te dane na podzbiory po 200 probek
u_Est = u(1:N/2);
u_Wer = u(N/2+1:N);

y_Est = y(1:N/2);
y_Wer = y(N/2+1:N);
%% TU sie liczy LS metoda
disp('---------------------------------------------')
disp('Metoda LS')
phi = [];
for i=2:1:length(y_Est)
    phi(i,:)=[y_Est(i-1) u_Est(i-1)];
end
%phi_biale = phi_biale';



PN_LS=pinv(phi)*y_Est;
p=PN_LS;
kp = p(2)/(1-p(1)); % tutaj to dzielenie przez to 1-p_biale dalem
% bo inaczej wynik estymacji trzeba bylo losowo x50 dac xd (linijka 79)
T = -Tp/log(p(1)); % z tym minusem to niewiem ale dalem zeby czas ujemny nie byl


y_pred(1)=0;
for i=2:step:length(y_Wer)
    y_pred(i)=[y_Wer(i-1) u_Wer(i-1)]*p;
end

% tutaj podobno lsimem trzeba wygenerowac pozostale przebiegi
s = tf('s');
G_est = kp/(T*s+1);
t = 0:tp:tp*(length(u_Est)-1);
G_est
c2d(G_est, Tp)
y_est = lsim(G_est, u_Wer, t); % albo to trzeba pomnozyc razy 50 albo zostawic jak jest 59 linijke xd
t_wer = 0:Tp:(length(y_Wer)-1)*Tp;
% tutaj konczy sie liczyc w praktyce niedostepna! odpowiedz systemu xd

figure(4)
plot(y_Wer, color="#006BB6")
title("Zb.Wer Metoda LS I rząd")
hold on
% plot(y_pred_biale, color="#BEC0C2")
% hold on
plot(y_est, color="#F58426")
hold on
%legend("Dane pomiarowe","Predyktor Jednokrokowy", "Identyfikacja", location="best")
legend("Dane pomiarowe", "Identyfikacja", location="best")

% Ocena identyfikacji tutaj liczy sie
Nv=length(y_Wer);
Vp=1/Nv*sum((y_Wer'-y_pred).^2);
Vp;
% przedzial ufnosci nizej sie liczy, dokladnie tak samo jak w pierwszych
% na zajeciach wczesniej, wiec powinno byc git
cov0=Vp^2*(phi'*phi)^-1;
for i=1:2
    ans_d(i)=PN_LS(i)-1.96*sqrt(cov0(i,i));
    ans_g(i)=PN_LS(i)+1.96*sqrt(cov0(i,i));
end
przedzial1=[ans_d(1) ans_g(1)];
przedzial2=[ans_d(2) ans_g(2)];

[Jfit] = calculateFitMetrics(y_Wer, y_est);
[VPEn] = VPE(2, Vp, N/2);
%% Tu sie liczy IV metoda
disp('---------------------------------------------')
disp('Metoda IV')
Z = [];
for i=2:1:length(y_est)
    Z(i,:)=[y_est(i-1) u_Est(i-1)]; % to jest to Z z instrukcji
end
PN_IV=(Z'*phi)^(-1)*Z'*y_Est;
p_ulepszone=PN_IV; % ulepszone bo liczone ponownie druga metoda;
kp_ulepszone = p_ulepszone(2)/(1-p_ulepszone(1)); % tutaj to dzielenie przez to 1-p_color dalem
% bo inaczej wynik estymacji trzeba bylo losowo x50 dac xd(linijka 81)
T_ulepszone = -Tp/log(p_ulepszone(1)); % to samo co kilka linijek wyzej
G_est_ulepszone = kp_ulepszone/(T_ulepszone*s+1);
G_est_ulepszone
c2d(G_est_ulepszone, Tp)
t = 0:tp:tp*(length(u_Est)-1);
%y_est = lsim(G_est, u_Wer, t); % albo to trzeba pomnozyc razy 50 albo zostawic jak jest 59 linijke xd
%G_est_ulepszone = (kp_ulepszone*(1-exp(-Tp/T_ulepszone)))/(z-exp(-Tp/T_ulepszone));
y_est_ulepszone = lsim(G_est_ulepszone, u_Wer, t); 

% Ocena identyfikacji tutaj liczy sie
Nv=length(y_Wer);
Vp=1/Nv*sum((y_Wer'-y_pred).^2);
Vp;
% przedzial ufnosci nizej sie liczy, dokladnie tak samo jak w pierwszych
% na zajeciach wczesniej, wiec powinno byc git
cov0=Vp^2*(Z'*Z)^-1;
for i=1:2
    ans_d(i)=PN_IV(i)-1.96*sqrt(cov0(i,i));
    ans_g(i)=PN_IV(i)+1.96*sqrt(cov0(i,i));
end
przedzial1=[ans_d(1) ans_g(1)];
przedzial2=[ans_d(2) ans_g(2)];

figure(5)
plot(y_Wer, color="#006BB6")
title("Zb.Wer metoda IV I rząd")
hold on
plot(y_est_ulepszone, color="#F58426")
legend("Dane pomiarowe", "Identyfikacja", location="best")


[Jfit] = calculateFitMetrics(y_Wer, y_est_ulepszone);
[VPEn] = VPE(2, Vp, N/2);