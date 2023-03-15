close all; clear; clc;

%% wczytywanie danych + usunięcie pierwszego głupiego wiersza 
dane = importdata("StochasticProcess.mat");
dane(1,:) = [];

%% wyswietlanie kilku wybranych realizacji procesu losowego
wybrane_realizacje = [7, 22, 42, 133, 313, 498];
for i = 1:length(wybrane_realizacje)
    %figure(wybrane_realizacje(i))
    %plot(dane(wybrane_realizacje(i), :));
end

%% obliczanie estymat po realizacjach
m_n_daszek = 1/size(dane, 2)*sum(dane, 1);
%o2_n_daszek = 1/size(dane, 2)*(sum(dane, 1)-m_n_daszek).^2; %to jest do wykuriwenia chyba
o2_n_daszek = 1/size(dane, 2)*sum((dane - m_n_daszek).^2, 1); %to jest lepsza wersja tego samego co wyzej

%% obliczanie estymat po czasie
m_daszek = 1/size(dane, 1)*sum(dane, 2);
o2_daszek = 1/size(dane, 1)*sum((dane - m_daszek).^2, 2);

%% wykresy - chuj wie czy dobrze są tak jak w poleceniu
figure(222)
plot(m_n_daszek)
hold on;
plot(m_daszek)
figure(223)
plot(o2_n_daszek)
hold on;
plot(o2_daszek)

%% nie wiem o chuj chodzi z tym stacjonranym i ergodycznym procesem wiec puste to zostawiam

%% Estymaty funkcji korelacji sygnałów