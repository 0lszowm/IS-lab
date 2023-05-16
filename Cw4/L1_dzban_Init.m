%% Już widze ze te laby to bedzie takie gówno że szkoda strzepic ryja nawet mi
clear, close all, clc;


% Aby zapisać model rzeczywistego systemu (15) w postaci regresji liniowej,
% przyjmujemy v(n) jako nową zmienną pomocniczą. Możemy zatem przepisać równanie jako:
% y(n) = G_{o}(q^-1, p_{o})u(n) + v(n)
% gdzie v(n) jest zdefiniowane jako:
% v(n) = (1+c_{1o}q^-1)e(n)
% Teraz możemy potraktować y(n) jako naszą zmienną objaśnianą, a u(n) i v(n)
% jako zmienne niezależne. Możemy to przedstawić jako model regresji liniowej:
% y(n) = B_{0}u(n) + B_{1}v(n) + E(n)
% Gdzie:
% B_{0} i B_{1} to wspolczynniki regresji, które będziemy szukać
% E(n) to składnik losowy reprezentujący błąd modelu.

Tp = 0.1;
tend = 1000;
Td = 1500;
c1o = 0;

P = 1;

global z
z=[0; 0; 0];

global pd_ls
pd_ls = [0 0 0]';
global pd_iv
pd_iv = [0 0 0]';


global yd
global yd1
global yd2
yd=0;
yd1=0;
yd2=0;

global xd
global xd1
global xd2
xd=0;
xd1=0;
xd2=0;

global P_ls
P_ls=[P 0 0; 0 P 0;0 0 P];

global P_iv
P_iv=[P 0 0; 0 P 0;0 0 P];
