function staticRKIData( tab )
    tab = tab{ 1 };

    % 'bundeslandMap.mat' enthält nur statische Informationen und muss nur ein einziges mal 
    % ausgeführt werden
    if( isfile( 'bundesland.mat' ) )
        return
    end

    landkreisName = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );
	landkreisKeys = unique( tab.LandkreisId );

    % LandkreisId ist bereits einem Bundesland zugeordnet: alreadyAdded(landkreisKey)=true
    alreadyAdded = containers.Map( 'KeyType', 'int32', 'ValueType', 'logical' );
    for n = 1 : length( landkreisKeys )
        alreadyAdded( landkreisKeys( n ) ) = false;
    end

    % alle Bundesland-Ids und Landkreis-Ids sammeln
    bundeslandLK    = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );
    bundeslandName  = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );

    bundeslandKeys  = unique( tab.BundeslandId );
    lenKeys = length( bundeslandKeys );
    for n = 1 : lenKeys
        bundeslandLK( bundeslandKeys( n ) )   = [];
        bundeslandName( bundeslandKeys( n ) ) = [];
    end

    % Tabelleneinträge eintüten
    old = 100;
    len = size( tab, 1 );

    for n = 1 : len
        entry = tab( n, : );
        key   = entry.BundeslandId;
        lkId  = entry.LandkreisId;

        if( ~alreadyAdded( lkId ) )
            fortSchritt = fix( 100 * n / len );
            if( fortSchritt ~= old )
                home; sprintf( '%s: Füge Landkreis %5.0f hinzu. Fortschritt: %3.0f Prozent', ...
                               'staticRKIData()', lkId, fortSchritt )
                old = fortSchritt;
            end

            % Name des Landkreises eintragen
            landkreisName( lkId ) = entry.Landkreis;

            % LandkreisId eintragen
            bundeslandLK( key ) = [ bundeslandLK( key ); lkId ];
            if( isempty( bundeslandName( key ) ) )
                bundeslandName( key ) = entry.Bundesland;
            end

            alreadyAdded( lkId )  = true;
        end
    end

    % Ergebnis speichern
	save( 'bundesland.mat', 'landkreisKeys', 'landkreisName', 'bundeslandKeys', ...
          'bundeslandName', 'bundeslandLK' )

	home; sprintf( 'staticRKIData(): fertig' )
end