%% ten kod należy odpalac sekcjami (ctrl+enter i kursor w odpowiedniej sekcji)
% tylko ostrzegam, bo inaczej nie zadziała
close all; clear; clc;

%% druga kropka
% to należy odpalic przed uruchomieniem symulacji w tym pliku w simulinku
% inaczej tam bedzie sie simulink pluł o brak tych parametrow

Tp = 1; %% yo jest w sekundach
N = 1001;
sigma2v = 0;
tend = 500; %% w sekundach to tez musi byc 
% to co jest wyzej mozna zmienic dowolnie (chyba)



%% tutaj bedzie kod ktory bedzie wyswietlac wykresy
% to należy odpalic po uruchomieniu symulacji w tym pliku w simulinku

figure(1)
plot(Zdata(:, 3), Zdata(:,1))
title("To jest pierwszy wykres") %% tu wpisać co na tym wykresie jest należy
 
%nie mam pojecia co reprezentuje soba ten wykres ponizej ale zostawiam go
figure(2)
plot(Zdata(:, 2), Zdata(:,1), "r.")
title("To jest drugi wykres") %% tu wpisać co na tym wykresie jest należy
