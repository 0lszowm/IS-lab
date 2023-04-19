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
sim_data = sim('AKident.mdl');
Zdata = sim_data.Zdata;

%% tutaj bedzie kod ktory bedzie wyswietlac wykresy
% to należy odpalic po uruchomieniu symulacji w tym pliku w simulinku

figure(1)
plot(Zdata(:, 3), Zdata(:,1))
title("To jest pierwszy wykres") %% tu wpisać co na tym wykresie jest należy
 
%nie mam pojecia co reprezentuje soba ten wykres ponizej ale zostawiam go
figure(2)
plot(Zdata(:, 2), Zdata(:,1), "r.")
title("To jest drugi wykres") %% tu wpisać co na tym wykresie jest należy
% cały czas nie wiem co ten wykres linijke wyzej pokazuje ale drazkowska powiedziala ze sensownie wyglada


%% trzecie polecenie
% Analiza korelacyjna
u = Zdata(:,1);
y = Zdata(:,2);
t = Zdata(:,3);
M = 20;
tau = 0:1:M-1;
% deklaracja macierzy korelacyjnych
Ryu_hat = zeros(M, M);
Ruu_hat = zeros(M, M);
ruu_hat = zeros(1, M);
ryu_hat = zeros(1, M);

% Wypelnianie macierzy korelacyjnych
for i = 0:1:(M-1)
    ruu_hat(i+1) = Covar([u u], i);
    ryu_hat(i+1) = Covar([y u], i);
end
for i = 1:M
    Ruu_hat(i,:) = ruu_hat;
    Ryu_hat(i,:) = ryu_hat;
    ruu_hat = circshift(ruu_hat,1);
    ryu_hat = circshift(ryu_hat,1);
    ruu_hat(1:i) = 0;
    ryu_hat(1:i) = 0;
end
Ruu_hat = Ruu_hat+Ruu_hat'-diag(diag(Ruu_hat));
Ryu_hat = Ryu_hat+Ryu_hat'-diag(diag(Ryu_hat));
ruu_hat = Ruu_hat(1, :);
ryu_hat = Ryu_hat(1, :);

%% to niżej to wydaje mi sie ze mozna wykurwic ale pewien nie jestem wiec narazie zostawiam
% deklaracja macierzy est
Ruu_Hat = [];

% budowanie maceirzy est.
for i = 1:1:length(20)
    ruu_Hat = Ruu_hat([20-i+1:20, 1:20-i])'; 
    Ruu_Hat = [Ruu_Hat; ruu_Hat'];
end
