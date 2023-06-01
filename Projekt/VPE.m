function [VPEn] = VPE(dp, V, N)
    VPEn = V*(1+dp/N)/(1-dp/N);
    fprintf('Wskaźnik VPE: %.4f\n', VPEn);
    AICe = N *log(V)+ 2*dp;
    fprintf('Wskaźnik AIC: %.4f\n', AICe);
    SICe = N *log(V)+ 2*dp*log(N);
    fprintf('Wskaźnik SIC: %.4f\n', SICe);

end