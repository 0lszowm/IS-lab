%% MAM nadzieje ze tym razem laboratoria pójdą nam lepiej i ze nie zrobi wejsciowki ktora przepierdolic bedzie mozna
close all; clear; clc;

load IdentWsadowaStat.mat
u0 = DaneStatW(:,1); % +zakłócenie nieskorelowane e
y0 = DaneStatW(:,2); % to tak jak wyżej

u1 = DaneStatC(:,1); % +zakłócenie skorelowane v
y1 = DaneStatC(:,2); % to tak jak wyżej

figure(1)
subplot(2,1,1)
plot(u0, 'green')
title("Wejscie obiektu")
subplot(2,1,2)
plot(y0, color="#4DBEEE")
title("Wyjscie obiektu+zakłócenie nieskorelowane e")

figure(2)
subplot(2,1,1)
plot(u1, 'green')
title("Wejscie obiektu")
subplot(2,1,2)
plot(y1, color="#4DBEEE")
title("Wyjscie obiektu+zakłócenie skorelowane v")


%ktrok (liczba N) wpływa na jakość identyfikacji
step = 250; % mozna 250 lub 500 dac tez ogolnie nalezy tu wjebac liczbe 
% przez ktora sie dzieli 2500 inaczej blad wykurwi sie o jakies dimensions xd
dp=4; % to z polecenia przestukałem

%% to nizej to sie liczy dla pomiarow zakłóconych przez e
% mozna przekurwic dla tych drugich zakłóceń tylko 0 na 1 radze zmienic
for i=1:step:length(y0)
    phi0(i,:)=[1, 1/u0(i), 1/u0(i)^2, 1/u0(i)^3]; 
    % czatbot mowi ze zamiast jedynek mozna losowe liczby wstawic a zamiast
    % tego u niby losowe funkcje xdddd
    % z tym u to wiem ze zmysla ale z tym ze te jedynki mozna zamienic to moze miec racje
end

PN_LS0=pinv(phi0)*y0;
p0=PN_LS0;

for i=1:step:length(y0)
    y0_hat(i,:)=(p0(1) + p0(2)/u0(i) + p0(3)/u0(i)^2 + p0(4)/u0(i)^3);
    E0(i) = y0(i) - y0_hat(i);
end
var0=1/(step-dp)*sum(E0.^2);
cov0=var0^2*(phi0'*phi0)^-1;

for i=1:4
    ans_d0(i)=PN_LS0(i)-1.96*sqrt(cov0(i,i));
    ans_g0(i)=PN_LS0(i)+1.96*sqrt(cov0(i,i));
end
przedzial0_1=[ans_d0(1) ans_g0(1)];
przedzial0_2=[ans_d0(2) ans_g0(2)];
przedzial0_3=[ans_d0(3) ans_g0(3)];
przedzial0_4=[ans_d0(4) ans_g0(4)];
figure(1)
hold on
subplot(2,1,2)
plot(1:step:length(y0), y0_hat(1:step:length(y0)), color="#D95319")
legend('pomiar', 'estymata')

%% to nizej to sie liczy dla pomiarow zakłóconych przez v
for i=1:step:length(y1)
    phi1(i,:)=[1, 1/u1(i), 1/u1(i)^2, 1/u1(i)^3]; 
    % czatbot mowi ze zamiast jedynek mozna losowe liczby wstawic a zamiast
    % tego u niby losowe funkcje xdddd
    % z tym u to wiem ze zmysla ale z tym ze te jedynki mozna zamienic to moze miec racje
end

PN_LS1=pinv(phi1)*y1;
p1=PN_LS1;

for i=1:step:length(y1)
    y1_hat(i,:)=(p1(1) + p1(2)/u1(i) + p1(3)/u1(i)^2 + p1(4)/u1(i)^3);
    E1(i) = y0(i) - y0_hat(i);
end
var1=1/(step-dp)*sum(E1.^2);
cov1=var1^2*(phi1'*phi1)^-1;
for i=1:4
    ans_d1(i)=PN_LS1(i)-1.96*sqrt(cov1(i,i));
    ans_g1(i)=PN_LS1(i)+1.96*sqrt(cov1(i,i));
end

przedzial1_1=[ans_d1(1) ans_g1(1)];
przedzial1_2=[ans_d1(2) ans_g1(2)];
przedzial1_3=[ans_d1(3) ans_g1(3)];
przedzial1_4=[ans_d1(4) ans_g1(4)];
figure(2)
hold on
subplot(2,1,2)
plot(1:step:length(y1), y1_hat(1:step:length(y1)), color="#D95319")
legend('pomiar', 'estymata')

