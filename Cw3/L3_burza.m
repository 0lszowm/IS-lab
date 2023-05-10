%% mam nadzieje ze to pojdzie bo nie chce nad tym siedziec zbyt dlugo, mamy inna robote do zrobienia tez
close all; clear; clc;
load IdentWsadowaDyn.mat

Tp = 0.01;
N = 4001;
M = 3200;
u = DaneDynW(:, 1);
yw = DaneDynW(:, 2);
u_est = u(1:M);
u_wer = u(1+M:end);
y_est = yw(1:M);
y_wer = yw(1+M:end);
T = 0:Tp:N*Tp-Tp;
T_est = 0:Tp:M*Tp-Tp;
T_wer = M*Tp:Tp:N*Tp-Tp;

% to co jest nizej zostało przekurwione z instrukcji jak cos
%*****************************************************************************************
%----- filtracja SVF interpolowanych danych spróbkowanych: -----
%*****************************************************************************************

%
% M = 3200; % wybór liczby danych do zbioru Ze 
% To co jest linijke wyzej bylo w instrukcji ale przenioslem to wyzej :)

tE = Tp*(N-M:N)'; % wektor próbek chwil czasowych dla danych estymujących
uE = DaneDynW(N-M:N,1); % wybór wektora próbek sygnału pobudzającego u do zbioru Ze
yE = DaneDynW(N-M:N,2); % wybór wektora próbek sygnału wyjściowego y do zbioru Ze
%----------------------------
s = tf('s'); % zmienna operatorowa Laplace’a
TF = 1*Tp; % wybór wartości stałej czasowej dla filtrów SVF
n = 1; % wybór rzędu dynamiki sla filtrów SVF
F0 = 1/(1+s*TF)^n; % definicja filtru SFV typu F^0
F1 = s/(1+s*TF)^n; % definicja filtru SFV typu F^1
yF = lsim(F0,y_est,T_est,'foh'); % filtracja SVF filtrem F^0 sekwencji yE z ekstrapolacją _fohe
ypF = lsim(F1,y_est,T_est,'foh'); % filtracja SVF filtrem F^1 sekwencji yE z ekstrapolacją _fohe
uF = lsim(F0,u_est,T_est,'foh'); % filtracja SVF filtrem F^0 sekwencji uE z ekstrapolacją efohs
%*****************************************************************************************
% przejebalem z instrukcji to co znajduje sie wyzej

Phi = [yF(1:end-1) uF(1:end-1)];
PNLS_filtr = (Phi'*Phi)^-1*Phi'*y_est(2:end);
T_filtr = -Tp/log(PNLS_filtr(1)); % to jest na podstawie P(1)e^{-Tp/T}
kp_filtr = PNLS_filtr(2)/(1-exp(-Tp/T_filtr));
% Na podstawie parametrow powyzszych to sie liczy nizej
z = tf('z', Tp);
G_filtr = (kp_filtr*(1-exp(-Tp/T_filtr)))/(z-exp(-Tp/T_filtr));
Y_filtr = lsim(G_filtr, u_wer, T_wer);

% tutaj nizej liczy sie w praktyce niedostepna! odpowiedz systemu xd
s = tf('s');
k0 = 2;
T0 = 0.5;
G_o = k0/(1+s*T0);
Y_o = lsim(G_o, u_wer, T_wer);

figure(1)
plot(y_wer, color="#000000");
hold on
plot(Y_filtr, color="#F58426")
hold on 
plot(Y_o, color="#006BB6")
legend("Dane pomiarowe", "Identyfikacja", "y_o", location="best")

% Im wieksze Tf tym gorsza jakosc za duże złe (Duze Tf - duze odfiltrowanie - razem z informacja uzyteczna)
% Filtr SVF rekonstruuje pochodne y i u
% Im wyzszy rzad tym gorsza jakosc