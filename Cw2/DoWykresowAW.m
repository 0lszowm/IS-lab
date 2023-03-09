%fragmnety kodu dla studentów do celu wykreœlania wyników analizy widmowej:
%--------------------------------------------------------------------------
%wykresy przebiegu modu³ów:
figure(30);
omega0 = omega2;%0.01:0.1:100.01; 
[MAGG,PHASEG] = bode(G,omega0);
magg = reshape(MAGG,size(MAGG,3),1);
LmMagg = 20*log10(magg);
semilogx(omega2m,LmETFE(1:indm),'Color',[0.7;0.7;0.7],'Linewidth',1);
hold on;
grid on;
semilogx(omega2,LmETFEs(1:ind),'Color',[0.2;0.2;0.2],'Linewidth',1);
semilogx(omega0,LmMagg,'k--','Linewidth',1);
legend('$\hat{G}^{*}_N$','$\hat{G}_N$','$G_{o}$','Orientation','vertical','Location','best');
set(legend,'Interpreter','latex');
xlabel('$\omega$ [rad/s]','Interpreter','latex');
ylabel('Lm [dB]','Interpreter','latex');
%--------------------------------------------------------------------------
%wykresy przebiegu przesuniêæ fazowych:
figure(40);
ph=reshape(PHASEG,size(PHASEG,3),1);
ArgETFE = unwrap(angle(ETFE))*180/pi;
ArgETFEs = unwrap(angle(ETFEs))*180/pi;
semilogx(omega2m,ArgETFE(1:indm),'Color',[0.7;0.7;0.7],'Linewidth',1);
hold on;
grid on;
semilogx(omega2,ArgETFEs(1:ind),'Color',[0.2;0.2;0.2],'Linewidth',1);
semilogx(omega0,ph,'k--','Linewidth',1);
legend('$\hat{G}^{*}_N$','$\hat{G}_N$','$G_{o}$','Orientation','vertical','Location','best');
set(legend,'Interpreter','latex');
xlabel('$\omega$ [rad/s]','Interpreter','latex');
ylabel('Arg [deg]','Interpreter','latex');

