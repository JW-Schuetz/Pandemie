function [ zeitreihen, debugInfo ] = processLandkreisMeldungen( datum, ...
    landkreisKeys, landkreisMeldungen, modus, debug )
	% modus=0: Meldedatum, modus=1: Referenzdatum

    debugInfo = {};

    % leere Maps erzeugen
    zeitreihen.neuInfektionen = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );
    zeitreihen.todesFaelle    = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );
    zeitreihen.ageNew         = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );
    zeitreihen.ageTot         = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );
    zeitreihen.genderNew      = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );
    zeitreihen.genderTot      = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );

    % keys der Inzidenz-Map initialisieren
    len = length( landkreisKeys );
    for n = 1 : len
        key = landkreisKeys( n );

        zeitreihen.neuInfektionen( key ) = [];
        zeitreihen.todesFaelle( key )    = [];
        zeitreihen.ageNew( key )         = [];
        zeitreihen.ageTot( key )         = [];
        zeitreihen.genderNew( key )      = [];
        zeitreihen.genderTot( key )      = [];
    end

    numDays = length( datum );

    % Schleife über alle Landkreise
    old = 100;
    for n = 1 : len
        key = landkreisKeys( n );   % LandkreisId ist Schlüssel

        fortSchritt = fix( 100 * n / len );
        if( fortSchritt ~= old )
            home; sprintf( '%s: Bearbeite Landkreis %5.0f. Fortschritt: %3.0f Prozent', ...
                           'processLandkreisMeldungen()', key, fortSchritt )
            old = fortSchritt;
        end

        % Landkreis key auswerten
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

        lkMeldungen = landkreisMeldungen( key );    % Liste der Meldungen des Kreises

        if( ~isempty( lkMeldungen ) )
            % sortieren nach Meldedatum/Referenzdatum
            switch( modus )
                case 0  % modus=0: Meldedatum
                    dat = lkMeldungen.Meldedatum;
                case 1  % modus=1: Referenzdatum
                    dat = lkMeldungen.Referenzdatum;
                otherwise
                    error( 'modus unbekannt' )
            end

            % Sortieren nach Datum
            [ ~, ndx ]  = sort( dat );
            lkMeldungen = lkMeldungen( ndx, : );

            for m = 1 : size( lkMeldungen, 1 )
                lkm = lkMeldungen( m, : );              % aktuelle Meldung

                switch( modus )
                    case 0  % modus=0: Meldedatum
                        dat = lkm.Meldedatum;
                    case 1  % modus=1: Referenzdatum
                        dat = lkm.Referenzdatum;
                    otherwise
                        error( 'modus unbekannt' )
                end

                tag = daysdif( datum( 1 ), dat ) + 1;	% Index des Meldungstages

                if ismember( lkm.NeuerFall, [ 0, 1 ] )
                    fallAnzahl = double( lkm.Fallanzahl );

                    if( debug )
                        if( key == 2000 )   % SK Hamburg
                            debugInfo = [ debugInfo, { lkm.ObjectId; fallAnzahl; tag } ]; %#ok<AGROW>
                        end
                    end

                    neu( tag ) = neu( tag ) + fallAnzahl;
                    an{ tag }  = fillAgeBins( lkm.Altersgruppe, an{ tag }, fallAnzahl );
                    gn{ tag }  = fillGenderBins( lkm.Geschlecht, gn{ tag }, fallAnzahl );
                end

                if ismember( lkm.NeuerTodesfall, [ 0, 1 ] )
                    fallAnzahl = double( lkm.TodesfallAnzahl );

                    tot( tag ) = tot( tag ) + fallAnzahl;
                    at{ tag }  = fillAgeBins( lkm.Altersgruppe, at{ tag }, fallAnzahl );
                    gt{ tag }  = fillGenderBins( lkm.Geschlecht, gt{ tag }, fallAnzahl );
                end
            end
        end

        zeitreihen.neuInfektionen( key ) = neu;
        zeitreihen.todesFaelle( key )    = tot;
        zeitreihen.ageNew( key )         = an;
        zeitreihen.ageTot( key )         = at;
        zeitreihen.genderNew( key )      = gn;
        zeitreihen.genderTot( key )      = gt;
    end

    home; sprintf( 'processLandkreisMeldungen(): fertig' )
end