%% Ostatnia czesc tu kodu malo bedzie bo duzo w simulinku bedzie ukladania bloczkow
clear, close all, clc;

Tp=0.05;
tend=1000;
sigma2e=0.1;
Tf=8*Tp;
global pd 
global P
global yd1 
global yd2

pd=[0;0;0];
yd1=0;
yd2=0;
P=diag([1, 1, 1]);