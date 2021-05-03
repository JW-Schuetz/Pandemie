 function rkiData()
    clc
    clear

    version = 0; % 0: aktuell, 1: historisch
    idpos   = 4; % 0: aktuell, ~0: historisch, 4: mit Hash
    modus   = 0; % modus=0: Meldedatum, modus=1: Referenzdatum

    % Zielverzeichnis für die Tabellen, Quelldateiname
    srcDir        = '..\';
    dstTabDir     = '..\Tabellen\';
    dstImmuDir    = '..\Impfquoten\';
    inputDataFile = 'RKI_COVID19.csv';
    outputFile    = 'rkiMap.mat';

    % Messung der Ausführungszeit
    startTime = datetime( 'now' );

    % Startdatum und Stichtag
    startDate = datetime( '01.01.2020' );
    stichTag  = datetime( '01.06.2020' );

    % Datei 'Impfquotenmonitoring.xlsx' (mit Curl) herunterladen und auslesen
    inputImmuFile = 'Impfquotenmonitoring.xlsx';
    infile = [ srcDir, 'Impfquoten\', inputImmuFile ];
    generateImmuData( infile, dstImmuDir );

	% Datei 'RKI_COVID19.csv' (mit curl) herunterladen und auslesen
    infile = [ srcDir, inputDataFile ];
    tab    = generateRKITab( infile, dstTabDir, version, idpos, 'yyyy/MM/dd HH:mm:ss' );

    if( ~isempty( tab ) )
        % Datumsarray ohne Lücken ab startDate und bis zum Vortag des Datenstands-Datums
        % generieren (zum Datenstandsdatum liegen noch keine Meldungen vor)
        datum = generateDateArray( startDate, tab{ 2 } - 1 );
        akkumuliereRKIData( tab, datum, modus, stichTag, outputFile, false )
        updateStatistikDatenstand( tab, startDate )
    end

    % Ausführungszeit [Sekunden]
    sec   = seconds( diff( [ startTime, datetime( 'now' ) ] ) );
    fixed = fix( sec / 60 );

    home; sprintf( 'RKIData(): fertig! Rechenzeit: %2.0f Minuten %2.0f Sekunden', ...
                   fixed, sec - 60 * fixed )
end