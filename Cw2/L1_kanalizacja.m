%% ZADANIE 1.1

% dane
clear all;
clc;

% niezaklucone dane
load('ProcessStepResponse.mat');

% Budowanie parametrów ze wczytanych 
tn1 = S(:,1); %probki czasu w sekundach
h1 = S(:,2); %probki zarejestrowanej odpowedzi skokowej
N1 = length(h1);

% Wykreslanie odpowiedzi skokowej
figure(1)
subplot(2,1,1)
plot(tn1,h1, 'b--')
hold on;

% Odpowiedz impulsowa
for i = 2:N1
    g1(i) = (h1(i)-h1(i-1))/(tn1(i)-tn1(i-1));
end

% Wykreslanie odpowiedzi impulsowej
subplot(2,1,2)
plot(tn1,g1, 'm--')
hold on;

% tu wystepuje obliczanie stalej czasowej inercji
T90 = 22.7; % yo zmierzylem nie tak dokladnie ale jednak
T50 = 11.5; % tutaj jest tak jak linijke wyzej
z_tego_wynika_ze_3_rzad = T90/T50
p = 3; % na podstawie linijki kodu co znajduje sie wyzej o jedna od tej;
T = (T50/2.67 + T90/5.32)/2; % usredniam to bo tak zadecydowalem :)
y_nieskonczone = 0.5; % tak okolo ale nie chce mi sie dokladnie tam tego sprawdzac
Au = 1; % bo wymuszenie u = 1(tn)
K = y_nieskonczone/Au;

mian = [T^3, 3*T^2, 3*T, 1]; % bo rozwijam to (Ts + 1)^p
sys = tf(K,mian);
subplot(2,1,1)
step(sys, 'c');
legend("Step real", "Step approx")
subplot(2,1,2)
impulse(sys, 'g');
legend("Impulse real", "Impulse approx")
% zakłócone dane
% liczy sie tak samo jak te wyzej czyli tylko trzeba to przejebac i troche zmienic

load('NoisyProcessStepResponse.mat');

% Budowanie parametrów ze wczytanych 
tn2 = nS(:,1); %probki czasu w sekundach
h2 = nS(:,2); %probki zarejestrowanej odpowedzi skokowej
N2 = length(h2);

% Wykreslanie odpowiedzi skokowej
figure(2)
subplot(2,1,1)
plot(tn2,h2, 'b--')
hold on;
% Odpowiedz impulsowa
for i = 2:N2
    g2(i) = (h2(i)-h2(i-1))/(tn2(i)-tn2(i-1));
end

% Wykreslanie odpowiedzi impulsowej
subplot(2,1,2)
plot(tn2,g2, 'm--')
hold on;

% tu wystepuje obliczanie stalej czasowej inercji
T90 = 58; % yo zmierzylem nie tak dokladnie ale jednak
T50 = 33; % tutaj jest tak jak linijke wyzej
z_tego_wynika_ze_5_rzad = T90/T50
p = 5; % na podstawie linijki kodu co znajduje sie wyzej o jedna od tej;
T = (T50/4.67 + T90/7.99)/2; % usredniam to bo tak zadecydowalem :)
y_nieskonczone = 0.24; % tak okolo ale nie chce mi sie dokladnie tam tego sprawdzac
Au = 1; % bo wymuszenie u = 1(tn)
K = y_nieskonczone/Au;

syms T1
syms s1
mnos = (T1*s1 + 1)^5;
expand(mnos);

mian = [T^5, 5*T^4, 10*T^3, 10*T^2 5*T 1]; % bo rozwijam to (Ts + 1)^p



sys = tf(K,mian);
subplot(2,1,1)
step(sys, 'c');
legend("Step real", "Step approx")
subplot(2,1,2)
impulse(sys, 'g');
legend("Impulse real", "Impulse approx")

%% ZADANIE 1.2

clear all;
clc;

%% niezaszumione
% niezaklucone dane
load('ProcessStepResponse.mat');

% Budowanie parametrów ze wczytanych 
tn1 = S(:,1); %probki czasu w sekundach
h1 = S(:,2); %probki zarejestrowanej odpowedzi skokowej
N1 = length(h1);

% Wykreslanie odpowiedzi skokowej
figure(3)
subplot(2,1,1)
plot(tn1,h1, 'b--')
hold on;

% Odpowiedz impulsowa
for i = 2:N1
    g1(i) = (h1(i)-h1(i-1))/(tn1(i)-tn1(i-1));
end

% Wykreslanie odpowiedzi impulsowej
subplot(2,1,2)
plot(tn1,g1, 'm--')
hold on;

tg = 8.5;
ag = 0.03429;
tg = 8.5;
yg = 0.151645;
sg = yg;
b = sg - ag*tg;

t = 1:1:25;
styczna_s = ag*t+b;
figure(4)
plot(styczna_s)
hold on
plot(tn1,h1, 'b--')


%% zaszumione

clear all;
close all;
clc;

load('NoisyProcessStepResponse.mat');

% Budowanie parametrów ze wczytanych 
tn2 = nS(:,1); %probki czasu w sekundach
h2 = nS(:,2); %probki zarejestrowanej odpowedzi skokowej
N2 = length(h2);

% Wykreslanie odpowiedzi skokowej
figure(3)
subplot(2,1,1)
plot(tn2,h2, 'b--')
hold on;

% Odpowiedz impulsowa
for i = 2:N2
    g2(i) = (h2(i)-h2(i-1))/(tn2(i)-tn2(i-1));
end

% Wykreslanie odpowiedzi impulsowej
subplot(2,1,2)
plot(tn2,g2, 'm--')
hold on;

tg = 32;
ag = 0.006;
tg = 32;
yg = 0.115;
sg = yg;
b = sg - ag*tg;

t = 1:1:60;
styczna_s = ag*t+b;
figure(4)
plot(styczna_s)
hold on
plot(tn2,h2, 'b--')

%% wspolny wykresy

