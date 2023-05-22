function statistik( outputPraefix, lkName, kreisId, bundesLandId, datum, ...
                    landkreisZeitreihen, blName, bundeslandZeitreihen, ...
                    bundesrepublikZeitreihen, stichTag  )

    fileName = createFileName( outputPraefix, 'Statistik', 'txt', lkName );
	writeStatistik( fileName, lkName, kreisId, bundesLandId, blName, ...
        bundesrepublikZeitreihen, bundeslandZeitreihen, landkreisZeitreihen )

    % Tagesaktuelle Tabelle laden
    fileName = [ '..\Tabellen\', 'table-', char( datum( end ) + 1, 'dd.MM.yyyy' ), '.mat' ];
    load( fileName, 'tab' );

    datenstandsDatum = tab{ 2 };
    tab              = tab{ 1, : };

	% Teiltabelle des aktuellen Landkreises
    tabLK = tab( tab.LandkreisId == kreisId, : );

    neu       = tabLK.NeuerFall;
    neuerfall = or( neu == 0, neu == 1 );
    neutab    = tabLK( neuerfall, : );

    lastDay   = datenstandsDatum - 1;
    ndx       = neutab.Meldedatum == lastDay;
    neutab    = neutab( ndx, : );

    % Sortieren nach Altersgruppe
    [ ~, ndx ] = sort( neutab.Altersgruppe );
    neutab     = neutab( ndx, : );

    fileName = createFileName( outputPraefix, 'LastCases', 'csv', lkName );
    writeTable( neutab, fileName, sprintf( 'Die %d %s %s', sum( neutab.Fallanzahl ), ...
        'Neuinfektionen am', string( lastDay, 'dd.MM.yyyy' ) ) )

    tot       = tabLK.NeuerTodesfall;
    todesfall = or( tot == 0, tot == 1 );
    tottab    = tabLK( todesfall, : );

    % erst ab Stichtag
    ndx    = tottab.Meldedatum >= stichTag;
    tottab = tottab( ndx, : );

    % Sortieren nach Referenzdatum
    [ ~, ndx ] = sort( tottab.Referenzdatum );
    tottab     = tottab( ndx, : );

    % nur die letzten N Fälle darstellen
    N = 10;
    tottab = tottab( end - ( N - 1 ) : end, : );

    % Sortieren nach Altersgruppe
    [ ~, ndx ] = sort( tottab.Altersgruppe );
	tottab     = tottab( ndx, : );

    N = size( tottab, 1 );

    fileName = createFileName( outputPraefix, 'LastDeaths', 'csv', lkName );
    writeTable( tottab, fileName, sprintf( 'Die letzten %d %s %s', N, 'Todesfälle seit dem', ...
        string( stichTag, 'dd.MM.yyyy' ) ) )

%     % Statistik Sterbehäufigkeit der LK
%     len = size( tab, 1 );
%     for n = 1 : len
%         tn  = tab( n, : );
%         key = tn.LandkreisId;
%     end
end

function writeTable( tab, fileName, text )
    % Datei neu erzeugen
    file = fopen( fileName, 'w' );
    fprintf( file, '%s:\n\n', text );
	if( size( tab, 1 ) == 0 )
        fprintf( file, '%s', 'Keine' );
	end
    fclose( file );

	if( size( tab, 1 ) ~= 0 )
        % Abspecken der Tabelle
        tab.BundeslandId         = [];
        tab.Bundesland           = [];
        tab.Landkreis            = [];
        tab.LandkreisId          = [];
        tab.TodesfallAnzahl      = [];
        tab.NeuerFall            = [];
        tab.NeuerTodesfall       = [];

        % Tabelle anhängen
        writetable( tab, fileName, 'Delimiter', 'tab', 'WriteMode','Append', ...
            'WriteVariableNames', 1 )
	end
end

function writeStatistik( filename, lkName, landKreisId, bundesLandId, blName, ...
            bundesrepublikZeitreihen, bundeslandZeitreihen, landkreisZeitreihen )

    Name = 'Deutschland';

    neuInfektionen   = bundesrepublikZeitreihen.neuInfektionen;
    neuInfektionenBL = bundeslandZeitreihen.neuInfektionen;
    neuInfektionenLK = landkreisZeitreihen.neuInfektionen;
    todesFaelle      = bundesrepublikZeitreihen.todesFaelle;
    todesFaelleBL    = bundeslandZeitreihen.todesFaelle;
    todesFaelleLK    = landkreisZeitreihen.todesFaelle;

    % Normierungsfaktoren (100000 Enwohner)
    [ fak, fakBL, fakLK ] = normierungsFaktoren( bundesLandId, landKreisId );

    % Mittelwerte
    mde  = meanFilter( bundesrepublikZeitreihen.neuInfektionen * fak );
    mble = meanFilter( bundeslandZeitreihen.neuInfektionen( bundesLandId ) * fakBL );
    mlke = meanFilter( landkreisZeitreihen.neuInfektionen( landKreisId ) * fakLK );

    format   = '%s\t\t%d\n';
    formatBL = '%s\t\t\t%d\n';
	formatLK = '%s\t\t%d\n';

    switch landKreisId
        case { 6411, 6433 }
            formatLK = '%s\t\t%d\n';
        case { 6412, 6437, 6438 }
            formatLK = '%s\t%d\n';
        case { 6432 }
            formatLK = '%s\t\t%d\n';
    end

    % Statistik-Output in Konsole und File
    file = fopen( filename, 'w' );

    % Neuinfektionen 
    fprintf( file, 'Infektionen (absolut):\n' );
    fprintf( file, format, Name, sum( neuInfektionen ) );
    fprintf( file, formatBL, blName, sum( neuInfektionenBL( bundesLandId ) ) );
    fprintf( file, formatLK, lkName, sum( neuInfektionenLK( landKreisId ) ) );

    % Todesfälle
    fprintf( file, '\nTodesfälle (absolut):\n' );
    fprintf( file, format, Name, sum( todesFaelle ) );
    fprintf( file, formatBL, blName, sum( todesFaelleBL( bundesLandId ) ) );
    fprintf( file, formatLK, lkName, sum( todesFaelleLK( landKreisId ) ) );

    % Inzidenzen
    fprintf( file, '\nInzidenzen:\n' );
    fprintf( file, format, Name, int32( mde( end ) ) );
    fprintf( file, formatBL, blName, int32( mble( end ) ) );
    fprintf( file, formatLK, lkName, int32( mlke( end ) ) );

    fclose( file );
end

function fileName = createFileName( outputPraefix, name, ext, lkName )
    fileName = [ outputPraefix, name, '-', lkName, '.', ext ];
end