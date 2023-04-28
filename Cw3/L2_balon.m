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
u_bialeWer = u_biale(2001:4001);

y_bialeEst = y_biale(1:2000);
y_bialeWer = y_biale(2001:4001);

u_colorEst = u_color(1:2000);
u_colorWer = u_color(2001:4001);

y_colorEst = y_color(1:2000);
y_colorWer = y_color(2001:4001);

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
kp_biale = p_biale(2);
T_biale = -Tp/log(p_biale(1)); % z tym minusem to niewiem ale dalem zeby czas ujemny nie byl

PN_LS_color=pinv(phi_color)*y_colorEst;
p_color=PN_LS_color;
kp_color = p_color(2);
T_color = -Tp/log(p_color(1)); % to samo co kilka linijek wyzej



figure(3)
plot(y_bialeWer, color="#4DBEEE")
title("+ Zakłócenie biale Zb.Wer")
% tutaj podobno lsimem trzeba wygenerowac pozostale przebiegi

figure(4)
plot(y_colorWer, color="#4DBEEE")
title("+ Zakłócenie korolowe Zb.Wer")
% i tutaj to samo nalezy zrobic co wyzej kilka linijek
