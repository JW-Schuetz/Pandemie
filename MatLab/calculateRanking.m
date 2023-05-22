function perf = calculateRanking( keys, zeitreihe, ndxStart, ndxEnd, ...
                    normToBeUsed )

    % prozentuale Todesrate
	performance = calcDeathChance( keys, zeitreihe, ndxStart, ndxEnd, ...
        normToBeUsed );

    % evtl. fehlende Datensätze (die mit 0%) eliminieren
	proz = cell2mat( performance( :, 2 ) );

	ndx  = ( proz ~= 0 );
	proz = proz( ndx );

    % nach Prozenten aufsteigend sortieren
    [ ~, ndx ] = sort( proz );

    % sortierte Performanzen returnen
    perf = performance( ndx, : );
end