%% pierwsza instrukcja byla w miare ta tez sie wydaje w miare, zobaczymy dalej co bedzie xd
close all; clear; clc;
load IdentWsadowaDyn.mat
% zaklucenie biale
u_biale = DaneDynW(:,1); % +zakłócenie biale
y_biale = DaneDynW(:,2); % to tak jak wyżej

u_color = DaneDynC(:,1); % +zakłócenie kolorowe
y_color = DaneDynC(:,2); % to tak jak wyżej

N=4001; Tp=0.01; t=0:Tp:(N-1)*Tp;
step=1;
dp=4;

figure(1)
subplot(2,1,1)
plot(u_biale, 'green')
title("Wejscie obiektu")
subplot(2,1,2)
plot(y_biale, color="#4DBEEE")
title("Wyjscie obiektu+zakłócenie biale")

figure(2)
subplot(2,1,1)
plot(u_color, 'green')
title("Wejscie obiektu")
subplot(2,1,2)
plot(y_color, color="#4DBEEE")
title("Wyjscie obiektu+zakłócenie color")

% tutaj nizej dziela sie te dane na podzbiory po 2000 i 2001 probek
u_bialeEst = u_biale(1:2000);
u_bialeWer = u_biale(2001:4000);

y_bialeEst = y_biale(1:2000);
y_bialeWer = y_biale(2001:4000);

u_colorEst = u_color(1:2000);
u_colorWer = u_color(2001:4000);

y_colorEst = y_color(1:2000);
y_colorWer = y_color(2001:4000);

phi_biale = [];
for i=2:1:length(y_bialeEst)
    phi_biale(i,:)=[y_bialeEst(i-1) u_bialeEst(i-1)];
end
%phi_biale = phi_biale';

phi_color = [];
for i=2:1:length(y_colorEst)
    phi_color(i,:)=[y_colorEst(i-1) u_colorEst(i-1)];
end
%phi_color = phi_color';


PN_LS_biale=pinv(phi_biale)*y_bialeEst;
p_biale=PN_LS_biale;
kp_biale = p_biale(2)/(1-p_biale(1)); % tutaj to dzielenie przez to 1-p_biale dalem
% bo inaczej wynik estymacji trzeba bylo losowo x50 dac xd (linijka 79)
T_biale = -Tp/log(p_biale(1)); % z tym minusem to niewiem ale dalem zeby czas ujemny nie byl

PN_LS_color=pinv(phi_color)*y_colorEst;
p_color=PN_LS_color;
kp_color = p_color(2)/(1-p_color(1)); % tutaj to dzielenie przez to 1-p_color dalem
% bo inaczej wynik estymacji trzeba bylo losowo x50 dac xd(linijka 81)
T_color = -Tp/log(p_color(1)); % to samo co kilka linijek wyzej

y_pred_color(1)=0;
y_pred_biale(1)=0;
for i=2:step:length(y_bialeWer)
    y_pred_biale(i)=[y_bialeWer(i-1) u_bialeWer(i-1)]*p_biale;
    y_pred_color(i)=[y_colorWer(i-1) u_colorWer(i-1)]*p_color;
end

% tutaj podobno lsimem trzeba wygenerowac pozostale przebiegi
z = tf('z', Tp);
G_est_biale = (kp_biale*(1-exp(-Tp/T_biale)))/(z-exp(-Tp/T_biale)) ;
y_est_biale = lsim(G_est_biale, u_bialeWer); % albo to trzeba pomnozyc razy 50 albo zostawic jak jest 59 linijke xd
G_est_color = (kp_color*(1-exp(-Tp/T_color)))/(z-exp(-Tp/T_color));
y_est_color_wer = lsim(G_est_color, u_colorWer); % albo to trzeba pomnozyc razy 50 albo zostawic jak jest 65 linijke xd
y_est_color_est = lsim(G_est_color, u_colorEst);
% tutaj nizej liczy sie w praktyce niedostepna! odpowiedz systemu xd
s = tf('s');
k0 = 2;
T0 = 0.5;
G_o = k0/(1+s*T0);
t_wer = 0:Tp:(length(y_bialeWer)-1)*Tp;
y_niezakl = lsim(G_o, u_bialeWer, t_wer);
% tutaj konczy sie liczyc w praktyce niedostepna! odpowiedz systemu xd

figure(3)
plot(y_bialeWer, color="#000000")
title("+ Zakłócenie biale Zb.Wer Metoda LS")
hold on
plot(y_niezakl, color="#006BB6")
hold on
plot(y_pred_biale, color="#BEC0C2")
hold on
plot(y_est_biale, color="#F58426")
hold on
legend("Dane pomiarowe", "Niezakłócona odpowiedz(niedostępna!)" ,"Predyktor Jednokrokowy", "Identyfikacja", location="best")

figure(4)
plot(y_colorWer, color="#000000")
title("+ Zakłócenie korolowe Zb.Wer Metoda LS")
hold on
plot(y_niezakl, color="#006BB6")
hold on
plot(y_pred_color, color="#BEC0C2")
hold on
plot(y_est_color_wer, color="#F58426")
legend("Dane pomiarowe", "Niezakłócona odpowiedz(niedostępna!)" ,"Predyktor Jednokrokowy", "Identyfikacja", location="best")

% Ocena identyfikacji tutaj liczy sie
Nv=length(y_bialeWer);
Vp_biale=1/Nv*sum((y_bialeWer'-y_pred_biale).^2);
Vm_biale=1/Nv*sum((y_niezakl-y_est_biale).^2);
Nv=length(y_colorWer);
Vp_color=1/Nv*sum((y_colorWer'-y_pred_color).^2);
Vm_color=1/Nv*sum((y_niezakl-y_est_color_wer).^2);

% przedzial ufnosci nizej sie liczy, dokladnie tak samo jak w pierwszych
% na zajeciach wczesniej, wiec powinno byc git
cov0=Vm_biale^2*(phi_biale'*phi_biale)^-1;
for i=1:2
    ans_d(i)=PN_LS_biale(i)-1.96*sqrt(cov0(i,i));
    ans_g(i)=PN_LS_biale(i)+1.96*sqrt(cov0(i,i));
end
przedzial_biale_1=[ans_d(1) ans_g(1)];
przedzial_biale_2=[ans_d(2) ans_g(2)];


%% druga czesc tu bedzie a moze juz jest (chodzi o ta 2.2)
% dobra kiedys nalezy to dokonczyc
for i=2:1:length(y_est_color_est)
    Z(i,:)=[y_est_color_est(i-1) u_colorEst(i-1)]; % to jest to Z z instrukcji
end
PN_IV_color=(Z'*phi_color)^(-1)*Z'*y_colorEst;
p_color_ulepszone=PN_IV_color; % ulepszone bo liczone ponownie druga metoda;
kp_color_ulepszone = p_color_ulepszone(2)/(1-p_color_ulepszone(1)); % tutaj to dzielenie przez to 1-p_color dalem
% bo inaczej wynik estymacji trzeba bylo losowo x50 dac xd(linijka 81)
T_color_ulepszone = -Tp/log(p_color_ulepszone(1)); % to samo co kilka linijek wyzej

G_est_color_ulepszone = (kp_color_ulepszone*(1-exp(-Tp/T_color_ulepszone)))/(z-exp(-Tp/T_color_ulepszone));
y_est_color_ulepszone = lsim(G_est_color_ulepszone, u_colorWer); % albo to trzeba pomnozyc razy 50 albo zostawic jak jest 65 linijke xd
% to nizej co jest y_m napisala na tablicy nie dokonca wiem co to jest ale
% napisala jak sie liczy i przejebalem to
y_m = [];
y_m(1) = 0;
y_nn1(1) = 0;
for n=2:length(u_colorWer)
    y_m(n) = G_est_color_ulepszone.Numerator{1,1}(end)*u_colorWer(n-1)+exp(-Tp/T_color_ulepszone)*y_m(n-1);
    y_nn1(n) = G_est_color_ulepszone.Numerator{1,1}(end)*u_colorWer(n-1)+exp(-Tp/T_color_ulepszone)*y_colorWer(n-1);
end
Vp_color_ulepszone=1/Nv*sum((y_pred_color-y_nn1).^2);
Vm_color_ulepszone=1/Nv*sum((y_niezakl-y_est_color_ulepszone).^2);

figure(5)
plot(y_colorWer, color="#000000")
title("+ Zakłócenie korolowe Zb.Wer metoda IV")
hold on
plot(y_est_color_ulepszone, color="#F58426")
plot(y_m, LineStyle="--", color="#BEC0C2")
plot(y_nn1, color="#006BB6")
legend("Dane pomiarowe", "Identyfikacja", "y_m", "y_n/n-1", location="best")
