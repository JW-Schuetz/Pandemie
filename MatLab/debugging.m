function debugging()
    clc
    clear

    load( 'rkiMapDebug.mat', 'landkreisName', 'landkreisZeitreihen', 'bundeslandName', ...
          'bundeslandZeitreihen', 'bundesrepublikZeitreihen', 'debugInfo' )
    load( 'tableDebug.mat', 'tab' )

    datenstand = tab{ 2 };
    tab        = tab{ 1 };

    % Landkreis 02000: Daten aus table.mat
    ndx    = ( tab.LandkreisId == 2000 );
    tabNeu = tab( ndx,  : );
    neu    = tabNeu.NeuerFall;
    neu    = or( neu == 0, neu == 1 );
    tabNeu = tabNeu( neu, : );
    objId1 = tabNeu.ObjectId;
    s1     = sum( tabNeu.Fallanzahl );

    % Landkreis 02000: Daten aus processLandkreisMeldungen()
    days = length( landkreisZeitreihen.neuInfektionen );

    s2   = double( 0 );
    len  = length( debugInfo );
    tag  = zeros( days, 1 );
    for n = 1 : len
        objId2( n ) = debugInfo{ 1, n }; %#ok<AGROW>
        tagn        = debugInfo{ 3, n };
        faelle      = debugInfo{ 2, n };
        tag( tagn ) = tag( tagn ) + double( faelle );
        s2          = s2 + double( faelle );
    end

    % sind die beiden Mengen identisch?
    if( ~isempty( setdiff( objId1', objId2 ) ) || ~isempty( setdiff( objId2, objId1' ) ) )
        error( 'Debugging(): Fehler' )
    end

    home; sprintf( 'Fälle: %d\nFälle: %d\n\nDebugging(): kein Fehler', s1, s2 )
end