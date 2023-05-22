function zeitreihen = processBundeslandDaten( datum, landkreisZeitreihen, bundeslandLK, ...
    bundeslandKeys )

    % Anzahl der Tage
    numDays = length( datum );

    % leere Maps erzeugen
    zeitreihen.neuInfektionen = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );
    zeitreihen.todesFaelle    = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );
    zeitreihen.ageNew         = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );
    zeitreihen.ageTot         = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );
    zeitreihen.genderNew      = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );
    zeitreihen.genderTot      = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );

    name = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );

    len = length( bundeslandKeys );
    % keys der Map initialisieren
    for n = 1 : len
        key = bundeslandKeys( n );

        zeitreihen.neuInfektionen( key ) = [];
        zeitreihen.todesFaelle( key )    = [];
        zeitreihen.ageNew( key )         = [];
        zeitreihen.ageTot( key )         = [];
        zeitreihen.genderNew( key )      = [];
        zeitreihen.genderTot( key )      = [];

        name( key ) = [];
    end

    old = 100;
    for n = 1 : len
        key = bundeslandKeys( n );

        fortSchritt = fix( 100 * n / len );
        if( fortSchritt ~= old )
            home; sprintf( '%s: Bearbeite Bundesland %2.0f. Fortschritt: %3.0f Prozent', ...
                           'processBundeslandDaten()', key, fortSchritt )
            old = fortSchritt;
        end

        neu = zeros( numDays, 1 );
        tot = zeros( numDays, 1 );
        an  = cell( numDays, 1 );
        at  = cell( numDays, 1 );
        gn  = cell( numDays, 1 );
        gt  = cell( numDays, 1 );

        for d = 1 : numDays
            an( d ) = { zeros( 7, 1 ) };
            at( d ) = { zeros( 7, 1 ) };

            gn( d ) = { zeros( 2, 1 ) };
            gt( d ) = { zeros( 2, 1 ) };
        end

        % Landkreis key auswerten
        blLandkreise = bundeslandLK( key );	% alle Landkreise des Landes key

        for m = 1 : length( blLandkreise )
            lk = blLandkreise( m );         % Landkreis m

            neu = neu + landkreisZeitreihen.neuInfektionen( lk );
            tot = tot + landkreisZeitreihen.todesFaelle( lk );
            an  = mergeBins( an, landkreisZeitreihen.ageNew( lk ) );
            at  = mergeBins( at, landkreisZeitreihen.ageTot( lk ) );
            gn  = mergeBins( gn, landkreisZeitreihen.genderNew( lk ) );
            gt  = mergeBins( gt, landkreisZeitreihen.genderTot( lk ) );
        end

        % Zahlen für Bundesland speichern
        zeitreihen.neuInfektionen( key ) = neu;
        zeitreihen.todesFaelle( key )    = tot;
        zeitreihen.ageNew( key )         = an;
        zeitreihen.ageTot( key )         = at;
        zeitreihen.genderNew( key )      = gn;
        zeitreihen.genderTot( key )      = gt;
    end

    home; sprintf( 'processBundeslandDaten(): fertig' )
end
