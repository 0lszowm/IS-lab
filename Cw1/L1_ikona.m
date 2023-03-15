close all; clear; clc;

%% wczytywanie danych + usunięcie pierwszego wiersza 
dane = importdata("StochasticProcess.mat");
lp = dane(1,:);
dane(1,:) = [];

%% wyswietlanie kilku wybranych realizacji procesu losowego
wybrane_realizacje = [7, 22, 42, 133, 313, 498];
for i = 1:length(wybrane_realizacje)
    %figure(wybrane_realizacje(i))
    %plot(dane(wybrane_realizacje(i), :));
end

%% obliczanie estymat po realizacjach
m_n_daszek = 1/size(dane, 2)*sum(dane, 1);
%o2_n_daszek = 1/size(dane, 2)*(sum(dane, 1)-m_n_daszek).^2; %to jest do wywalenia chyba
o2_n_daszek = 1/size(dane, 2)*sum((dane - m_n_daszek).^2, 1); %to jest lepsza wersja tego samego co wyzej

%% obliczanie estymat po czasie
m_daszek = 1/size(dane, 1)*sum(dane, 2);
o2_daszek = 1/size(dane, 1)*sum((dane - m_daszek).^2, 2);

%% wykresy - niewiem czy dobrze w kazdym razie są tak jak w poleceniu
figure(222)
plot(dane(1,:),m_n_daszek,'r.')
hold on;
plot(dane(:,1),m_daszek,'b.');
legend('po realizacji','po czasie')
figure(223)
subplot(2,1,1)
plot(lp,o2_n_daszek,'r.')
title('Po realizacji')
subplot(2,1,2)
plot([1:500],o2_daszek,'b.');
title('Po czasie')

%% nie wiem o co chodzi z tym stacjonranym i ergodycznym procesem wiec puste to zostawiam

%% Estymaty funkcji korelacji sygnałów
Tp = 0.001;
N = 2000;
H = tf(0.1,[1 -0.9],Tp);


sigm2 = 0.64; % musi być z przedziału <0.64; 1.0>
sigm = sqrt(sigm2);

n = 1:2000;
tn = n*Tp;

e = sigm*randn(1, N);
x = skakanka(N, Tp);
y = pociag(N, Tp, e);
v = lsim(H,e,tn);

figure(333)
subplot(2,2,1)
plot(e)
title('e')
subplot(2,2,2)
plot(x)
title('x')
subplot(2,2,3)
plot(y)
title('y')
subplot(2,2,4)
plot(v)
title('v')

tau = 0:1:(N-1);

% autokorelacje i korelacje
R_ee = []; R_eeNO = [];
R_xx = []; R_xxNO = [];
R_yy = []; R_yyNO = [];
R_vv = []; R_vvNO = [];
R_xy = []; R_yx = [];

%covar - obciążony
%covarNO - niebociążony 
for i = 1:length(tau)
  R_ee = [R_ee Covar([e' e'], tau(i))];
  R_eeNO = [R_eeNO CovarNO([e' e'], tau(i))];
  R_xx = [R_xx  Covar([x' x'], tau(i))];
  R_xxNO = [R_xxNO CovarNO([x' x'], tau(i))];
  R_yy = [R_yy Covar([y' y'], tau(i))];
  R_yyNO = [R_yyNO CovarNO([y' y'], tau(i))];
  R_vv = [R_vv Covar([v v], tau(i))];
  R_vvNO = [R_vvNO CovarNO([v v], tau(i))];
  R_xy = [R_xy Covar([x' y'], tau(i))];
  R_yx = [R_yx Covar([y' x'], tau(i))];
end

%% wlasnosci W1

%zebranie z odbiciem z własności W
tau_caly = (-(N-1)):1:(N-1);
R_ee_caly = [];
R_eeNO_caly = [];
R_xx_caly = [];
R_xxNO_caly = [];
R_yy_caly = [];
R_yyNO_caly = [];
R_vv_caly = [];
R_vvNO_caly = [];
R_xy_caly = [];
R_yx_caly = [];

%odbicie symetryczne lewa strona
for i = (-N):-2
  R_ee_caly = [R_ee_caly R_ee(abs(i))];
  R_eeNO_caly = [R_eeNO_caly R_eeNO(abs(i))];
  R_xx_caly = [R_xx_caly R_xx(abs(i))];
  R_xxNO_caly = [R_xxNO_caly R_xxNO(abs(i))];
  R_yy_caly = [R_yy_caly R_yy(abs(i))];
  R_yyNO_caly = [R_yyNO_caly R_yyNO(abs(i))];
  R_vv_caly = [R_vv_caly R_vv(abs(i))];
  R_vvNO_caly = [R_vvNO_caly R_vvNO(abs(i))];
  R_xy_caly = [R_xy_caly R_xy(abs(i))];
  R_yx_caly = [R_yx_caly R_yx(abs(i))];
end

%odbicie symetryczne lewa strona plus prawa
R_ee_caly = [R_ee_caly R_ee];
R_eeNO_caly = [R_eeNO_caly R_eeNO];
R_xx_caly = [R_xx_caly R_xx];
R_xxNO_caly = [R_xxNO_caly R_xxNO];
R_yy_caly = [R_yy_caly R_yy];
R_yyNO_caly = [R_yyNO_caly R_yyNO];
R_vv_caly = [R_vv_caly R_vv];
R_vvNO_caly = [R_vvNO_caly R_vvNO];
R_xy_caly = [R_xy_caly R_xy];
R_yx_caly = [R_yx_caly R_yx];

figure(2)
subplot(2, 4, 1)
plot(tau_caly, R_ee_caly)
title('Ree')
subplot(2, 4, 5)
plot(tau_caly, R_eeNO_caly)
title('ReeNO')
subplot(2, 4, 2)
plot(tau_caly, R_xx_caly)
title('Rxx')
subplot(2, 4, 6)
plot(tau_caly, R_xxNO_caly)
title('RxxNO')
subplot(2, 4, 3)
plot(tau_caly, R_yy_caly)
title('Ryy')
subplot(2, 4, 7)
plot(tau_caly, R_yyNO_caly)
title('RyyNO')
subplot(2, 4, 4)
plot(tau_caly, R_vv_caly)
title('Rvv')
subplot(2, 4, 8)
plot(tau_caly, R_vvNO_caly)
title('RvvNO')

figure(4);
subplot(2, 1, 1)
plot(tau_caly, R_vv_caly)
title('Autokorelacja sygnału v(nTp)')
subplot(2, 1, 2)
plot(tau_caly, R_ee_caly)
title('Autokorelacja szumu białego e(nTp)')

figure(5);
subplot(2, 1, 1)
plot(tau_caly, R_xy_caly)
title('Rxy')
subplot(2, 1, 2)
plot(tau_caly, R_yx_caly)
title('Ryx')


function x = skakanka(n, tp)
    for i=1:n
        x(i) = sin(2*pi*5*i*tp); % tu ta 5 można wywalić aby ładniejsze wykresy robiły sie
    end
end

function y = pociag(n, tp, e)
    for i=1:n
        y(i) = sin(2*pi*5*i*tp) + e(i); % tutaj to co wyżej należy zrobić
    end
end