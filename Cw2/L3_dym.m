%% te laby powinny byc proste
% bo powiedziala ze wyswietlic wykresy, a obliczenia to podobno w wiekszosci mozna przejebac z pierwszych labów 
% bo podobno sie powtarzaja wzory

% yo co wyzej napisane jest to jakis totalny farmazon

close all; clear; clc;

% Parametry symulacji 
Tp = 0.5;
N = 1000;
sigma2v = 0.001;
tend = Tp*(N-1);

% Horyzont czasowy to tylko do wykresow
t_t = 0:Tp:Tp*(N-1);

% Pozyskanie danych z symulacji
sim('AWident.mdl')
u = Zdata(:,1);
y = Zdata(:,2);

% Wyswietlanie danych w dziedzinie czasu
figure
subplot(2,1,1);
plot(t_t, u);
title("Sygnal we")
subplot(2,1,2);
plot(t_t, y);
title("Sygnal wy")

% Analiza widmowa 

% Wzor 15
Yn = Tp*fft(y);
Un = Tp*fft(u);
Gn_1 = Yn./Un;

k = 1:1:N;
Omega(k) = 2*pi*k/N;
wk = Omega./Tp;


% Obiekt rzeczywisty w celu porównania z przeprowadzona analiza(char bod)
G = tf(1, [0.1 1.05 0.6 1]); % to sa dane tego obiektu z pliku AWident.mdl 
[MAGG,PHASEG] = bode(G,wk);
magg = reshape(MAGG,size(MAGG,3),1);
LmMagg = 20*log10(magg);
ph = reshape(PHASEG,size(PHASEG,3),1);


%zbiory estymat punktow charakterystyki bodego
Lm1 = abs(Gn_1);
Lm1 = 20*log10(Lm1);
Ph1 = unwrap(angle(Gn_1))*180/pi; % to jest zeby wartosci sie nie przepierdalaly za mocno
% albo zle dziala to albo tylko zmniejsza to zjawisko(chyba ze zle
% zaimplementowane) nie mam pojecia jak dziala to unwrap w takim wypadku

%porornwanie obiektu rzeczywistego ze zbiorek estymat
% to nizej troche jest przejebane z pliku DoWykresowAW.m i lekko poprawione
figure
sgtitle('Charakterystyki Bodego wzor 15 oraz obiekt rzeczywisty')
subplot(2, 1, 1)
semilogx(wk(1:end/2), Lm1(1:end/2))
hold on
semilogx(wk(1:end/2),LmMagg(1:end/2),'Color',[0.7;0.7;0.7],'Linewidth',1);
grid on
xlabel('$\omega$ [rad/s]','Interpreter','latex');
ylabel('Lm [dB]','Interpreter','latex');
subplot(2, 1, 2)
semilogx(wk(1:end/2), Ph1(1:end/2))
axis([0 10 -500 1000])
hold on
semilogx(wk(1:end/2),ph(1:end/2),'Color',[0.7;0.7;0.7],'Linewidth',1);
grid on
xlabel('$\omega$ [rad/s]','Interpreter','latex');
ylabel('Arg [deg]','Interpreter','latex');



% to nizej to podobno to samo co bylo na pierwszych zajeciach xddddd
% takiego kurwa farmazona dawno nie slyszalem // BOP

% Wzor 16
Mw = 200; % gamma = Mw

%Deklaracje macierzy potrzebnych do obliczen
sum1 = zeros(2*Mw+1,1);
sum2 = zeros(2*Mw+1,1);
Phi_uu = zeros(1,N);
Phi_yu = zeros(1,N);


%Realizacja wzoru 16 z wykorzystaniem okna hanninga
for k = 1:N
    for tau = -Mw:Mw
        sum1(tau+Mw+1)= Covar([u, u], tau) * Okno_Hanninga(tau, Mw) * exp(-1i*Omega(k)*tau);
        sum2(tau+Mw+1)= Covar([y, u], tau) * Okno_Hanninga(tau, Mw) * exp(-1i*Omega(k)*tau);
    end
    Phi_uu(k) = Tp * sum(sum1);
    Phi_yu(k) = Tp * sum(sum2);

end

%budowanie przebiegow
Gn_2 = Phi_yu./Phi_uu;
Lm2 = abs(Gn_2);
Lm2 = 20*log10(Lm2);
Ph2 = unwrap(angle(Gn_2))*180/pi; % to jest zeby wartosci sie nie przepierdalaly za mocno

% Wykreslanie przebiegow 
figure
sgtitle('Charakterystyki Bodego wzor 16 oraz obiekt rzeczywisty') 
subplot(2, 1, 1)
semilogx(wk(1:end/2), Lm2(1:end/2))
hold on
semilogx(wk(1:end/2),LmMagg(1:end/2),'Color',[0.7;0.7;0.7],'Linewidth',1);
grid on
xlabel('$\omega$ [rad/s]','Interpreter','latex');
ylabel('Lm [dB]','Interpreter','latex');

subplot(2, 1, 2)
semilogx(wk(1:end/2), Ph2(1:end/2))
axis([0 10 -500 1000])
hold on
semilogx(wk(1:end/2),ph(1:end/2),'Color',[0.7;0.7;0.7],'Linewidth',1);
grid on
xlabel('$\omega$ [rad/s]','Interpreter','latex');
ylabel('Arg [deg]','Interpreter','latex');


%% ODPOWIEDZI NA PYTANIA NIZEJ ZNAJDUJA SIE

% Uzycie okna prostokatnego pogarsza jakosc estymacji
% Wieksze Mw oznacza wiecej szumow, ale bardziej zgodny estymator

% Im mniejsze Tp tym lepsze dopasowanie do oryginalu, ale wiecej szumow
% Zbyt duze Tp powoduje opoznienie wyznaczonej odpowiedzi wzgledem rzeczywistej

% Wieksze sigma to mnniejsze dopasowanie i wiecej szumow pod koniec estymatora

% Lepiej N = 1000, bo przy 100 bardzo male dopasowanie
