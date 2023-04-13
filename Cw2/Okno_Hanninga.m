function O = Okno_Hanninga(i,Mw)
    if abs(i)<Mw
       wH = 0.5*( 1 + cos((i * pi) / Mw));
    else
        wH = 0;
    end
    
O = wH;
