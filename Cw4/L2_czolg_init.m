%% Z pierwsza czescia byly ciezary ale udalo sie rozwiazac wszystkie problemy licze ze i z ta tak bedzie.
clear, close all, clc;

Tp = 0.1;
tend = 1500;
Td = 500;
c1o=0;

global lambda
lambda=0.5; % ten wspolczynnik nalezy przyjac tak aby był w przedziale 0.98-0.999 
% albo 0-1 sam juz kurwa nie wiem bo w poleceniach źle to opisane jest/

global pd
global P
pd=[0;0;0];
P = diag([1,1,1]); % to nalezy zmieniac tak jak jest w poleceniu

global z
z=[0; 0; 0];

global yd1
global yd2
yd1=0;
yd2=0;

global xd
global xd1
global xd2
xd=0;
xd1=0;
xd2=0;