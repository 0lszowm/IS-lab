%% ZADANIE 1.1
% dane
close all;
clear all;
clc;
s = tf('s');

% niezaklucone dane
load('ProcessStepResponse.mat');

% Budowanie parametrów ze wczytanych 
niezaszumione_tn = S(:,1); %probki czasu w sekundach
niezaszumione_h = S(:,2); %probki zarejestrowanej odpowedzi skokowej
niezaszumione_N = length(niezaszumione_h);

% Wykreslanie odpowiedzi skokowej
figure(1)
subplot(2,1,1)
plot(niezaszumione_tn,niezaszumione_h, 'b--')
hold on;

% Odpowiedz impulsowa
for i = 2:niezaszumione_N
    niezaszumione_g(i) = (niezaszumione_h(i)-niezaszumione_h(i-1))/(niezaszumione_tn(i)-niezaszumione_tn(i-1));
end

% Wykreslanie odpowiedzi impulsowej
subplot(2,1,2)
plot(niezaszumione_tn,niezaszumione_g, 'm--')
hold on;

% tu wystepuje obliczanie stalej czasowej inercji
niezaszumione_T90 = 22.7; % yo zmierzylem nie tak dokladnie ale jednak
niezaszumione_T50 = 11.5; % tutaj jest tak jak linijke wyzej
niezaszumione_z_tego_wynika_ze_3_rzad = niezaszumione_T90/niezaszumione_T50
niezaszumione_p = 3; % na podstawie linijki kodu co znajduje sie wyzej o jedna od tej;
niezaszumione_Tv1 = (niezaszumione_T50/2.67 + niezaszumione_T90/5.32)/2; % usredniam to bo tak zadecydowalem :)
niezaszumione_y_nieskonczone = 0.5; % tak okolo ale nie chce mi sie dokladnie tam tego sprawdzac
niezaszumione_Au = 1; % bo wymuszenie u = 1(tn)
niezaszumione_K = niezaszumione_y_nieskonczone/niezaszumione_Au;

niezaszumione_gm1s = (niezaszumione_K/(niezaszumione_Tv1*s + 1)^niezaszumione_p);
subplot(2,1,1)
step(niezaszumione_gm1s, 'c');
legend("Step real", "Step Gm1s")
subplot(2,1,2)
impulse(niezaszumione_gm1s, 'g');
legend("Impulse real", "Impulse Gm1s")
% zakłócone dane
% liczy sie tak samo jak te wyzej czyli tylko trzeba to przejebac i troche zmienic
%
load('NoisyProcessStepResponse.mat');

% Budowanie parametrów ze wczytanych 
zaszumione_tn = nS(:,1); %probki czasu w sekundach
zaszumione_h = nS(:,2); %probki zarejestrowanej odpowedzi skokowej
zaszumione_N = length(zaszumione_h);

% Wykreslanie odpowiedzi skokowej
figure(2)
subplot(2,1,1)
plot(zaszumione_tn,zaszumione_h, 'b--')
hold on;
% Odpowiedz impulsowa
for i = 2:zaszumione_N
    zaszumione_g(i) = (zaszumione_h(i)-zaszumione_h(i-1))/(zaszumione_tn(i)-zaszumione_tn(i-1));
end

% Wykreslanie odpowiedzi impulsowej
subplot(2,1,2)
plot(zaszumione_tn,zaszumione_g, 'm--')
hold on;

% tu wystepuje obliczanie stalej czasowej inercji
zaszumione_T90 = 58; % yo zmierzylem nie tak dokladnie ale jednak
zaszumione_T50 = 33; % tutaj jest tak jak linijke wyzej
zaszumione_z_tego_wynika_ze_5_rzad = zaszumione_T90/zaszumione_T50
zaszumione_p = 5; % na podstawie linijki kodu co znajduje sie wyzej o jedna od tej;
zaszumione_Tv1 = (zaszumione_T50/4.67 + zaszumione_T90/7.99)/2; % usredniam to bo tak zadecydowalem :)
zaszumione_y_nieskonczone = 0.24; % tak okolo ale nie chce mi sie dokladnie tam tego sprawdzac
zaszumione_Au = 1; % bo wymuszenie u = 1(tn)
zaszumione_K = zaszumione_y_nieskonczone/zaszumione_Au;

zaszumione_gm1s = (zaszumione_K/(zaszumione_Tv1*s + 1)^zaszumione_p);
subplot(2,1,1)
step(zaszumione_gm1s, 'c');
legend("Step real", "Step Gm1s")
subplot(2,1,2)
impulse(zaszumione_gm1s, 'g');
legend("Impulse real", "Impulse Gm1s")
%%
% ZADANIE 1.2

% niezaszumione
niezaszumione_ag = 0.03429;
niezaszumione_tg = 8.5;
niezaszumione_yg = 0.151645;
niezaszumione_sg = niezaszumione_yg;
niezaszumione_b = niezaszumione_sg - niezaszumione_ag*niezaszumione_tg;

niezaszumione_t = 1:1:25;
niezaszumione_Tv2 = ((niezaszumione_ag*niezaszumione_tg)-niezaszumione_sg)/niezaszumione_ag;
niezaszumione_T0 = (niezaszumione_Au*niezaszumione_K)/niezaszumione_ag;
niezaszumione_gm2s = (niezaszumione_K/(niezaszumione_T0*s + 1))* exp(-s*niezaszumione_Tv2);
niezaszumione_styczna_s = niezaszumione_ag*niezaszumione_t+niezaszumione_b;
figure(3)
plot(niezaszumione_styczna_s)
hold on
plot(niezaszumione_tn,niezaszumione_h, 'b--')
legend("Wyznaczona styczna", "Step real")
title("Niezaszumione dane")

% zaszumione
zaszumione_ag = 0.006;
zaszumione_tg = 32;
zaszumione_yg = 0.115;
zaszumione_sg = zaszumione_yg;
zaszumione_b = zaszumione_sg - zaszumione_ag*zaszumione_tg;

zaszumione_t = 1:1:60;
zaszumione_Tv2 = ((zaszumione_ag*zaszumione_tg)-zaszumione_sg)/zaszumione_ag;
zaszumione_T0 = (zaszumione_Au*zaszumione_K)/zaszumione_ag;
zaszumione_gm2s = (zaszumione_K/(zaszumione_T0*s + 1))* exp(-s*zaszumione_Tv2);
zaszumione_styczna_s = zaszumione_ag*zaszumione_t+zaszumione_b;
figure(4)
plot(zaszumione_styczna_s)
hold on
plot(zaszumione_tn,zaszumione_h, 'b--')
legend("Wyznaczona styczna", "Step real")
title("Zaszumione dane")

%% wspolny wykresy
figure(5)
subplot(2,1,1)
plot(niezaszumione_tn,niezaszumione_h, 'b--')
hold on;
subplot(2,1,2)
plot(niezaszumione_tn,niezaszumione_g, 'm--')
hold on;
subplot(2,1,1)
step(niezaszumione_gm2s, 'c');
hold on;
legend("Step real", "Step Gm2s")
subplot(2,1,2)
impulse(niezaszumione_gm2s, 'r');
hold on;
legend("Impulse real", "Impulse Gm2s")

figure(6)
subplot(2,1,1)
plot(zaszumione_tn,zaszumione_h, 'b--')
hold on;
subplot(2,1,2)
plot(zaszumione_tn,zaszumione_g, 'm--')
hold on;
subplot(2,1,1)
step(zaszumione_gm2s, 'c');
hold on;
legend("Step real", "Step Gm2s")
subplot(2,1,2)
impulse(zaszumione_gm2s, 'r');
hold on;
legend("Impulse real", "Impulse Gm2s")