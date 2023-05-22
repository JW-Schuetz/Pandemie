function performance = calcDeathChance( keys, zeitreihe, ndxStart, ndxEnd, ...
                        normToBeUsed )

    keyLength   = length( keys );
    performance = cell( keyLength, 2 );

    for k = 1 : keyLength
        key = keys( k );

        ageNew = zeitreihe.ageNew( key );
        ageTot = zeitreihe.ageTot( key );

        perf = mortality( ageNew, ageTot, ndxStart, ndxEnd, ...
            normToBeUsed );

        % Fehlermeldung auf Konsole ausgeben
        if( perf == 0 )
            sprintf( 'Daten zu %d fehlen!', key )
        end

        % Maximumsnorm: das Maximum der Zeitreihe zählt
        performance( k, : ) = { key, perf };
    end
end