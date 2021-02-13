function updateStatistikDatenstand( tab, startDatum )
	load( 'statistikDatenstand.mat', 'landkreisKeys', 'landkreisZeitreihenDatenstand', ...
          'letzterDatenstand' )

    % Datenstand des Table-Files
    datenstand = tab{ 2 };
    tab        = tab{ 1 };

	tag = daysdif( startDatum, datenstand ) + 1;	% Index des Datenstand-Tages

    lkNeu = landkreisZeitreihenDatenstand.neuInfektionen;
    lkTot = landkreisZeitreihenDatenstand.todesFaelle;

	len = length( landkreisKeys );
    for n = 1 : len
        key = landkreisKeys( n );

        % Teiltabelle des Landkreises
        tabLK = tab( tab.LandkreisId == key, : );

        % Anzahl der neuen Fälle bestimmen
        neu = ( tabLK.NeuerFall == 1 );
        neu = tabLK( neu, : );

        % neue Fälle eintragen
        lk        = lkNeu( key );
        lk( tag ) = sum( neu.Fallanzahl );
        lkNeu( key ) = lk;

        % Anzahl der neuen Todesfälle bestimmen
        tot = ( tabLK.NeuerTodesfall == 1 );
        tot = tabLK( tot, : );

        % neue Todesfälle eintragen
        lk        = lkTot( key );
        lk( tag ) = sum( tot.TodesfallAnzahl );
        lkTot( key ) = lk;
    end

    landkreisZeitreihenDatenstand.neuInfektionen = lkNeu;
    landkreisZeitreihenDatenstand.todesFaelle    = lkTot;

    if( letzterDatenstand < datenstand )
        letzterDatenstand = datenstand;
    end

    % Statistik-Daten abspeichern
	save( 'statistikDatenstand.mat', 'landkreisKeys', 'landkreisZeitreihenDatenstand', ...
          'letzterDatenstand' )

    home; sprintf( 'updateStatistikDatenstand(): fertig!' )
end