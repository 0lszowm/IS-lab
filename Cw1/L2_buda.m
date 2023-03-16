close all; clear; clc;

%% dane
Tp = 0.001;
N = 2000; 
n = 0:N-1; 
tn = n*Tp;
H = tf(0.1,[1 -0.9],Tp);


f = 0:(1/(N*Tp)):(1/Tp-1/(N*Tp));

sigm = 0.8;
e = sigm*randn(1, N);
x = skakanka(n, Tp);
v = lsim(H,e,tn);

%% wykresy wszystkich sygnałów w dziedzinie czasu dystkretnego
figure(333)
subplot(2,2,1)
plot(e)
title('e')
subplot(2,2,2)
plot(x)
title('x')
subplot(2,2,3)
plot(v)
title('v')

%% fft z uwzględniemiem Tp
e_fft =  fft(e,N);
x_fft =  fft(x,N);
v_fft =  fft(v,N);

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

Om = (2*pi)/N * n;
om = Om/Tp;

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
%przygotowanie wektora do fft 
%Rxx = [rxx(1:Mw+1) zeros(1,2*N-2*Mw-2) rxx(Mw+1:-12)] to nie wazne jest
pars_xt = Tp*sum(x.^2)
pars_et = Tp*sum(e.^2);
pars_vt = Tp*sum(v.^2);

X_Njw = abs(fft(x, N));
X_Njw = 2*X_Njw/(N*Tp);
X_Njw = X_Njw/(N/2);
% energia w dziedzinie czestotliwosci
en_freq = sum(1/(N*Tp)*X_Njw.^2) 


%N=100;
omega=0:2*pi/N:2*pi-2*pi/N;
Mh=N/5;
i=0;
for tau = 0:N-1
    i=i+1;
    if tau<=Mh
        wh(i)=0.5*(1+cos(tau*pi/Mh));
    end
    if tau>Mh
        wh(i)=0;
    end
    r_xx(i)=Covar([x',x'],tau);
    Rxx = [r_xx(Mh+1) zeros(1, 2*N-2*Mh-2) r_xx(Mh+1:-1:2)]
    cor_xxh(i)=wh(i)*r_xx(i)*exp(-j*omega(i)*tau);
end
figure(5)
stem(omega(1:N/2),cor_xxh(1:N/2))
 

function x = skakanka(n, tp)
    x = sin(2*pi*5*n*tp) + 0.5*sin(2*pi*10*n*tp) + 0.25*sin(2*pi*30*n*tp);
end