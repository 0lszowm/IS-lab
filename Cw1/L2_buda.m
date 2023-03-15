close all; clear; clc;

%% dane
Tp = 0.001;
N = 2000; 
n = 0:N-1; 
tn = n*Tp;
H = tf(0.1,[1 -0.9],Tp);

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
e_fft = Tp * fft(e,N);
x_fft = Tp * fft(x,N);
v_fft = Tp * fft(v,N);

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

mod_x = abs(x_fft);
mod_e = abs(e_fft);
mod_v = abs(v_fft);

figure(3)
subplot(2,2,1)
stem(om(1:N/2),mod_e(1:N/2),'r')
grid on
title('mod e')
subplot(2,2,2)
stem(om(1:N/2),mod_x(1:N/2),'b')
grid on
title('mod x')
subplot(2,2,3)
stem(om(1:N/2),mod_v(1:N/2),'m')
grid on 
title('mod v')

function x = skakanka(n, tp)
    x = sin(2*pi*5*n*tp) + 0.5*sin(2*pi*10*n*tp) + 0.25*sin(2*pi*30*n*tp);
end