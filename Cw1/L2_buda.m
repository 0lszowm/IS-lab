close all; clear; clc;

%% dane
Tp = 0.001;
N = 2000; 
n = 0:N-1; 
tn = n*Tp;
H = tf(0.1,[1 -0.9],Tp);


f = 0:(1/(N*Tp)):(1/Tp-1/(N*Tp));

sigm = 0.8; % ta wartość przyjąłem bo taka tez została wykorzystana w trakcie poprzednich zajęć

% obliczanie wartosci sygnałów
e = sigm*randn(1, N);
x = skakanka(n, Tp);
v = lsim(H,e,tn);

% wykresy
figure(1)
subplot(2,2,1)
plot(e)
title('e')
subplot(2,2,2)
plot(x)
title('x')
subplot(2,2,3)
plot(v)
title('v')

%% fft
e_fft = fft(e,N);
x_fft = fft(x,N);
v_fft = fft(v,N);

%wykresy w fft
figure(2)
subplot(2,2,1)
plot(tn,e_fft,'r')
title('e_fft')
subplot(2,2,2)
plot(tn,x_fft,'b')
title('x_fft')
subplot(2,2,3)
plot(tn,v_fft,'m')
title('v_fft')

mod_x = 2/N*abs(x_fft);
mod_e = 2/N*abs(e_fft);
mod_v = 2/N*abs(v_fft);

figure(3)
subplot(2,2,1)
stem(f,mod_e,'r')
grid on
title('mod e')
subplot(2,2,2)
stem(f,mod_x,'b')
grid on
title('mod x')
subplot(2,2,3)
stem(f,mod_v,'m')
grid on 
title('mod v')


%% twierdzenie Parsevala (15)

pars_xt = Tp*sum(x.^2);
pars_et = Tp*sum(e.^2);
pars_vt = Tp*sum(v.^2);

% energia w dziedzinie czestotliwosci
en_freq_x = rabarbar(x, N, Tp); 
en_freq_e = rabarbar(e, N, Tp); 
en_freq_v = rabarbar(v, N, Tp); 
% Twierdzenie parsevala się zgadza (zostało potwierdzone w powyższych linijkach)

%% porównanie estymatorów periodogram i korelogram 
% Parametry
f = linspace(0,1/(2*Tp),N/2+1); % wektor częstotliwości

% Generowanie sygnału
e = sigm * randn(1,N);

% Estymacja gęstości widmowej mocy - periodogram
S_per = (1/(N*Tp)) * abs(fft(e)).^2;
S_per = S_per(1:N/2+1);

% Estymacja gęstości widmowej mocy - korelogram
[r, lags] = xcorr(e, 'unbiased');
r = r(N:end);
lags = lags(N:end);
S_corr = (1/(N*Tp)) * abs(fft(r)).^2;
S_corr = S_corr(1:N/2+1);

% Wykresy
figure(4);
subplot(3,1,1);
plot((0:N-1)*Tp, e);
xlabel('Czas [s]');
title('Sygnał e');

subplot(3,1,2);
plot(f, 10*log10(S_per));
xlabel('Częstotliwość [Hz]');
ylabel('Gęstość widmowa mocy [dB/Hz]');
title('Periodogram');

subplot(3,1,3);
plot(f, 10*log10(S_corr));
xlabel('Częstotliwość [Hz]');
ylabel('Gęstość widmowa mocy [dB/Hz]');
title('Korelogram');

%% tu znajdują się definicje funkcji
function x = skakanka(n, tp)
    x = sin(2*pi*5*n*tp) + 0.5*sin(2*pi*10*n*tp) + 0.25*sin(2*pi*30*n*tp);
end

function en = rabarbar(sig, n, tp)
    X_Njw = abs(fft(sig, n));
    X_Njw = 2*X_Njw/(n*tp);
    X_Njw = X_Njw/(n/2);
    en = sum(1/(n*tp)*X_Njw.^2);
end