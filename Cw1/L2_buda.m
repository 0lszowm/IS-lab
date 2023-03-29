close all; clear; clc;

% dane
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
% figure(2)
% subplot(2,2,1)
% plot(tn,e_fft,'r')
% title('e_fft')
% subplot(2,2,2)
% plot(tn,x_fft,'b')
% title('x_fft')
% subplot(2,2,3)
% plot(tn,v_fft,'m')
% title('v_fft')

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

%estym_prawidlowe(e, Tp, N, 4)
estym(e, N, Tp, f, 5)
% badanie zmiany sigm na estymate
sigm = 1; 
e = sigm*randn(1, N);
%estym_prawidlowe(e, Tp, N, 6)
estym(e, N, Tp, f, 7)
%% porównanie wpływu okna
okno = N/5;
estym_okno(e, N, Tp, f, okno, 8)
okno = N;
estym_okno(e, N, Tp, f, okno, 9)
okno = N/25;
estym_okno(e, N, Tp, f, okno, 10)

%% to jest do ostatniej kropki
%estym_prawidlowe(v, Tp, N, 11)
estym(v', N, Tp, f, 12)




%% tu znajdują się definicje funkcji

function estym_prawidlowe(sig, Tp, N, nr)
    % tutaj wszystko sie liczy gotowymi funkcjami matlab
    Fs = 1/Tp;
    [pee, fp] = periodogram(sig, [], [], Fs);

    [peek, fpk] = pwelch(sig, [], [], [], Fs);
    % Wykresy
    figure(nr);
    subplot(3,1,1);
    plot((0:N-1)*Tp, sig);
    title('Sygnał e');

    subplot(3,1,2);
    stem(fp, pee);
    xlabel('Częstotliwość [Hz]');
    ylabel('Gęstość widmowa mocy');
    title('Periodogram');

    subplot(3,1,3);
    stem(fpk, peek);
    xlabel('Częstotliwość [Hz]');
    ylabel('Gęstość widmowa mocy');
    title('Korelogram');
end

function estym(sig, N, Tp, f, img)
    % tu sie liczy gotowymi funkcjami w matlabie by porownac
    Fs = 1/Tp;
    [pee, fp] = periodogram(sig, [], [], Fs);
    [peek, fpk] = pwelch(sig, [], [], [], Fs);
    
    % od tego momentu bez gotowych funkcji sie liczy
    f2 = linspace(0, 500, 2000);
    % Estymacja gęstości widmowej mocy - periodogram
    fft_e=2*abs(fft(sig))/N; % to git
    S_per = (1/(N*Tp)) * fft_e.^2;
    %S_per = (1/(Tp*length(fft_e))) * fft_e.^2;

    % Estymacja gęstości widmowej mocy - korelogramowa
    for i = 0:N
        r(i+1) = Covar([sig' sig'], i);
    end
    mw = N/5;
    Ree = [r(1:mw+1)*1 zeros(1, 2*N-2*mw-2) r(mw+1:-1:2)];
    S_corr = (2/N)*abs(fft(Ree));

    % Wykresy
    figure(img);
    subplot(3,2,1:2);
    plot((0:N-1)*Tp, sig);
    xlabel('Czas [s]');
    title('Sygnał e');

    subplot(3,2,3);
    stem(fp, pee);
    xlabel('Częstotliwość [Hz]');
    ylabel('Gęstość widmowa mocy');
    title('Periodogram');

    subplot(3,2,4);
    stem(fpk, peek);
    xlabel('Częstotliwość [Hz]');
    ylabel('Gęstość widmowa mocy');
    title('Korelogram');

    subplot(3,2,5);
    %stem(S_per(1:N)) % a tutaj z odbiciem sie rysuje
    stem(f, 2*S_per(1:N/2+1)); % tutaj bez odbicia i mnozone x2 dlatego
    xlabel('Częstotliwość [Hz]');
    ylabel('Gęstość widmowa mocy');
    title('Periodogram');

    subplot(3,2,6);
    %stem(S_corr); % tutaj odbija sie okno wiec komentarz daje
    stem(f2, 2*S_corr(1:N)); % tutaj bez odbicia wiec elegancko i mnozone x2 dlatego
    xlabel('Częstotliwość [Hz]');
    ylabel('Gęstość widmowa mocy');
    title('Korelogram');
end

function estym_okno(sig, N, Tp, f, win, img)
    % ta funckja to tak naprawde to samo co baton tylko ze z mozliwoscia
    % zmiany okna :)
    f2 = linspace(0, 500, 2000);
    % Estymacja gęstości widmowej mocy - periodogram
    fft_e=2*abs(fft(sig))/N; % to git
    S_per = (1/(N*Tp)) * fft_e.^2;

    % Estymacja gęstości widmowej mocy - korelogramowa
    for i = 0:N
        r(i+1) = Covar([sig' sig'], i);
    end
    mw = win;
    Ree = [r(1:mw+1)*1 zeros(1, 2*N-2*mw-2) r(mw+1:-1:2)];
    S_corr = (2/N)*abs(fft(Ree));

    Fs = 1/Tp;
    [pee, fp] = periodogram(sig, [], [], Fs);

    [peek, fpk] = pwelch(sig, [], [], [], Fs);

    % Wykresy
    figure(img);
    subplot(3,2,1:2);
    plot((0:N-1)*Tp, sig);
    xlabel('Czas [s]');
    title('Sygnał');

    subplot(3,2,3);
    stem(fp, pee);
    xlabel('Częstotliwość [Hz]');
    ylabel('Gęstość widmowa mocy');
    title('Periodogram');

    subplot(3,2,4);
    stem(fpk, peek);
    xlabel('Częstotliwość [Hz]');
    ylabel('Gęstość widmowa mocy');
    title('Korelogram');

    subplot(3,2,5);
    %stem(S_per) % a tutaj z odbiciem sie rysuje
    stem(f, 2*S_per(1:N/2+1)); % tutaj tez bez odbicia i mnozone x2 dlatego
    xlabel('Częstotliwość [Hz]');
    ylabel('Gęstość widmowa mocy');
    title('Periodogram');

    subplot(3,2,6);
    %stem(S_corr); % tutaj odbija sie okno wiec komentarz daje
    stem(f2, 2*S_corr(1:N)); % tutaj bez odbicia wiec elegancko
    xlabel('Częstotliwość [Hz]');
    ylabel('Gęstość widmowa mocy');
    title('Korelogram');
end

function x = skakanka(n, tp)
    x = sin(2*pi*5*n*tp) + 0.5*sin(2*pi*10*n*tp) + 0.25*sin(2*pi*30*n*tp);
end

function en = rabarbar(sig, n, tp)
    %en = tp*sum(abs(tp*(fft(sig,ork)).^2)/(ork*tp)); % to jest zle
    X_Njw = abs(fft(sig, n));
    X_Njw = 2*X_Njw/(n*tp);
    X_Njw = X_Njw/(n/2);
    en = sum(1/(n*tp)*X_Njw.^2);
end