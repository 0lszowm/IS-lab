% ZADANIE 1.1

%% niezakłócone dane
clear all;
clc;
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
%% zakłócone dane
% liczy sie tak samo jak te wyzej czyli tylko trzeba to przejebac i troche zmienic





