function landkreisMeldungen = akkumuliereLandkreisMeldungen( tab, landkreisKeys )
    tab = tab{ 1 };

    % leere Landkreise-Map erzeugen
    landkreisMeldungen = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );

    % keys der Map initialisieren
	keyLength = length( landkreisKeys );
    for n = 1 : keyLength
        landkreisMeldungen( landkreisKeys( n ) ) = [];
    end

    % Tabelleneinträge eintüten
    len = size( tab, 1 );

    old = 100;
    for n = 1 : len
        tn = tab( n, : );

        key = tn.LandkreisId;

        fortSchritt = fix( 100 * n / len );
        if( fortSchritt ~= old )
            home; sprintf( '%s: Füge Landkreis %5.0f hinzu. Fortschritt: %3.0f Prozent', ...
                           'akkumuliereLandkreisMeldungen()', key, fortSchritt )
            old = fortSchritt;
        end

        % evtl. zur Map hinzufügen
        try
        landkreisMeldungen( key ) = [ landkreisMeldungen( key ); tn ];
        catch
            error( 'Landkreis %d unbekannt!', tn )
        end
    end

    home; sprintf( 'akkumuliereLandkreisMeldungen(): fertig' )
end