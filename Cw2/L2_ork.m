%% dyskretne - pamietac nalezy zeby przejebac switcha na dolna pozycje w simulinku
%% należy pamietac zeby zmienic koniec symulacji na tend
% ten kod należy odpalac sekcjami (ctrl+enter i kursor w odpowiedniej sekcji)
% tylko ostrzegam, bo inaczej nie zadziała
close all; clear; clc;
set_param('AKident/Manual Switch', 'sw', '0');
% jak kod sie bedzie wypierdalac to nalezy odpalic simulinka a dokladnie ten plik xd
% wazne to jest a i nalezy wpisac do tego pliku u gory w czas symulacji zmienna tend albo na sztywno 500
% druga kropka
% to należy odpalic przed uruchomieniem symulacji w tym pliku w simulinku, juz nie trzeba jak cos
% inaczej tam bedzie sie simulink pluł o brak tych parametrow


Tp = 1; %% yo jest w sekundach
N = 1001;
sigma2v = 0.0;
tend = 500; %% w sekundach to tez musi byc 
% to co jest wyzej mozna zmienic dowolnie (chyba)
sim_data_dysk = sim('AKident.mdl');
Zdata_dysk = sim_data_dysk.Zdata;

% tutaj bedzie kod ktory bedzie wyswietlac wykresy
% to należy odpalic po uruchomieniu symulacji w tym pliku w simulinku

figure(1)
plot(Zdata_dysk(:, 3), Zdata_dysk(:,1))
title("To jest wejscie") %% tu wpisać co na tym wykresie jest należy
 
%nie mam pojecia co reprezentuje soba ten wykres ponizej ale zostawiam go
figure(2)
plot(Zdata_dysk(:, 3), Zdata_dysk(:,2), "r")
title("To jest obiekt odpowiedz obiektu dyskretnego") %% tu wpisać co na tym wykresie jest należy
% cały czas nie wiem co ten wykres linijke wyzej pokazuje ale drazkowska powiedziala ze sensownie wyglada


% trzecie polecenie
% Analiza korelacyjna
u_dysk = Zdata_dysk(:,1);
y_dysk = Zdata_dysk(:,2);
t_dysk = Zdata_dysk(:,3);
M = 20;
tau = 0:1:M-1;
% deklaracja macierzy korelacyjnych
Ryu_hat_dysk = zeros(M, M);
Ruu_hat_dysk = zeros(M, M);
ruu_hat_dysk = zeros(1, M);
ryu_hat_dysk = zeros(1, M);

% Wypelnianie macierzy korelacyjnych
for i = 0:1:(M-1)
    ruu_hat_dysk(i+1) = Covar([u_dysk u_dysk], i);
    ryu_hat_dysk(i+1) = Covar([y_dysk u_dysk], i);
end
for i = 1:M
    Ruu_hat_dysk(i,:) = ruu_hat_dysk;
    Ryu_hat_dysk(i,:) = ryu_hat_dysk;
    ruu_hat_dysk = circshift(ruu_hat_dysk,1);
    ryu_hat_dysk = circshift(ryu_hat_dysk,1);
    ruu_hat_dysk(1:i) = 0;
    ryu_hat_dysk(1:i) = 0;
end
Ruu_hat_dysk = Ruu_hat_dysk+Ruu_hat_dysk'-diag(diag(Ruu_hat_dysk));
Ryu_hat_dysk = Ryu_hat_dysk+Ryu_hat_dysk'-diag(diag(Ryu_hat_dysk));
ruu_hat_dysk = Ruu_hat_dysk(1, :)';
ryu_hat_dysk = Ryu_hat_dysk(1, :)';

% tutaj liczymy jakies gowno
gM_hat_v1_dysk = pinv(Ruu_hat_dysk)*ryu_hat_dysk;
gM_hat_v2_dysk = zeros(M, 1);
for i = 1:M
    gM_hat_v2_dysk(i, 1) = ryu_hat_dysk(i)/ruu_hat_dysk(1);
end
figure(3)
stem(1:M, gM_hat_v1_dysk, 'b');
hold on
plot(1:M, gM_hat_v2_dysk, 'r');
legend('gM hat v1 dyskretne','gM hat v2 dyskretne')

%% ciagle - pamietac nalezy zeby przejebac switcha na gorna pozycje w simulinku

set_param('AKident/Manual Switch', 'sw', '1');
Tp = 1; %% yo jest w sekundach
N = 1001;
sigma2v = 0.001;
tend = 500; %% w sekundach to tez musi byc 
% to co jest wyzej mozna zmienic dowolnie (chyba)

sim_data_ciag = sim('AKident.mdl');

Zdata_ciag = sim_data_ciag.Zdata;

%nie mam pojecia co reprezentuje soba ten wykres ponizej ale zostawiam go
figure(12)
plot(Zdata_ciag(:, 3), Zdata_ciag(:,2), "r")
title("To jest obiekt odpowiedz obiektu ciaglego") %% tu wpisać co na tym wykresie jest należy
% cały czas nie wiem co ten wykres linijke wyzej pokazuje ale drazkowska powiedziala ze sensownie wyglada

% trzecie polecenie
% Analiza korelacyjna
u_ciag = Zdata_ciag(:,1);
y_ciag = Zdata_ciag(:,2);
t_ciag = Zdata_ciag(:,3);
M = 50;
tau = 0:1:M-1;
% deklaracja macierzy korelacyjnych
Ryu_hat_ciag = zeros(M, M);
Ruu_hat_ciag = zeros(M, M);
ruu_hat_ciag = zeros(1, M);
ryu_hat_ciag = zeros(1, M);

% Wypelnianie macierzy korelacyjnych
for i = 0:1:(M-1)
    ruu_hat_ciag(i+1) = Covar([u_ciag u_ciag], i);
    ryu_hat_ciag(i+1) = Covar([y_ciag u_ciag], i);
end
for i = 1:M
    Ruu_hat_ciag(i,:) = ruu_hat_ciag;
    Ryu_hat_ciag(i,:) = ryu_hat_ciag;
    ruu_hat_ciag = circshift(ruu_hat_ciag,1);
    ryu_hat_ciag = circshift(ryu_hat_ciag,1);
    ruu_hat_ciag(1:i) = 0;
    ryu_hat_ciag(1:i) = 0;
end
Ruu_hat_ciag = Ruu_hat_ciag+Ruu_hat_ciag'-diag(diag(Ruu_hat_ciag));
Ryu_hat_ciag = Ryu_hat_ciag+Ryu_hat_ciag'-diag(diag(Ryu_hat_ciag));
ruu_hat_ciag = Ruu_hat_ciag(1, :)';
ryu_hat_ciag = Ryu_hat_ciag(1, :)';
gM_hat_v1_ciag = 1/Tp*pinv(Ruu_hat_ciag)*ryu_hat_ciag;
gM_hat_v2_ciag = zeros(M, 1);
for i = 1:M
    gM_hat_v2_ciag(i, 1) = 1/Tp*ryu_hat_ciag(i)/ruu_hat_ciag(1);
end
figure(13)
plot(1:M, gM_hat_v1_ciag, 'b');
hold on
plot(1:M, gM_hat_v2_ciag, 'r');
legend('gM hat v1 ciagle','gM hat v2 ciagle' )

h_M_hat = zeros(M+1, 1);

for n = 1:M 
    h_M_hat(n+1, 1) = Tp*sum(gM_hat_v1_ciag(1:n));
end

figure(14)
system = tf(0.5, [5 11 7 1]);
plot(h_M_hat)
hold on
[y_step, ~]=step(system);
t_step = linspace(0,  M, 460);
plot(t_step, y_step) % tutaj ten obiekt sie plotuje zeby porownac
% wszystko jest raczej dobrze z tym bo jak pokazalismy to powiedziala ze ok