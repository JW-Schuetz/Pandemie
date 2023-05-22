function performance = calcDeathChanceBR( zeitreihe, ndxStart, ndxEnd )

    ageNew = zeitreihe.ageNew;
    ageTot = zeitreihe.ageTot;

	performance = mortality( ageNew, ageTot, ndxStart, ndxEnd, 0 );

	% Fehlermeldung auf Konsole ausgeben
    if( performance == 0 )
        sprintf( 'Daten fehlen!' )
    end
end