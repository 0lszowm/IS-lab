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
sim('AKident.mdl')


%% tutaj bedzie kod ktory bedzie wyswietlac wykresy
% to należy odpalic po uruchomieniu symulacji w tym pliku w simulinku

figure(1)
plot(Zdata(:, 3), Zdata(:,1))
title("To jest pierwszy wykres") %% tu wpisać co na tym wykresie jest należy
 
%nie mam pojecia co reprezentuje soba ten wykres ponizej ale zostawiam go
figure(2)
plot(Zdata(:, 2), Zdata(:,1), "r.")
title("To jest drugi wykres") %% tu wpisać co na tym wykresie jest należy


%% trzecie polecenie
% Analiza korelacyjna
u = Zdata(:,1);
y = Zdata(:,2);
t = Zdata(:,3);
M = 20;
tau = 0:1:M-1;
% deklaracja macierzy korelacyjnych
Ryu = zeros(1, N);
Ruu = zeros(1, N);

% Wypelnianie macierzy korelacyjnych
for i = 0:1:(N-1)
    ruu = Covar([u u], i);
    %wlasna
    Ruu(i+1) = ruu;
    
    ryu = Covar([y u], i);
    %wspolna
    Ryu(i+1) = ryu;
end


%% part3

% deklaracja macierzy est
Ruu_Hat = [];

% budowanie maceirzy est.
for i = 1:1:length(20)
    ruu_Hat = Ruu([20-i+1:20, 1:20-i])'; 
    Ruu_Hat = [Ruu_Hat; ruu_Hat'];
end
