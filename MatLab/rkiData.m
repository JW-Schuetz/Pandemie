function rkiData()
    clc
    clear

    idpos = 0; % 0: aktuell, ~0: historisch, 4: mit Hash
    modus = 0; % 0: Meldedatum, 1: Referenzdatum

    % Zielverzeichnis für die Tabellen, Quelldateiname
    srcDir        = 'D:\Downloads\';
    dstTabDir     = '..\Tabellen\';
    inputDataFile = 'RKI_COVID19.csv';
    outputFile    = 'rkiMap.mat';

    % Startdatum und Stichtag
    startDate = datetime( '01.01.2020' );
    stichTag  = datetime( '01.06.2020' );

	% Datei 'RKI_COVID19.csv' (mit curl) herunterladen und auslesen!
    infile = [ srcDir, inputDataFile ];

    [ tab, downLoadTime ] = generateRKITab( infile, dstTabDir, idpos, ...
                               'yyyy/MM/dd HH:mm:ss' );

	startTime = datetime( 'now' );

    if( ~isempty( tab ) )
        % Datumsarray ohne Lücken ab startDate und bis zum Vortag des Datenstands-Datums
        % generieren (zum Datenstandsdatum liegen noch keine Meldungen vor)
        datum = generateDateArray( startDate, tab{ 2 } - 1 );
        akkumuliereRKIData( tab, datum, modus, stichTag, outputFile, false )
        updateStatistikDatenstand( tab, startDate )

        % Daten plotten
        plotRKIData
    end

    % Gesamtausführungszeit [Sekunden]
    totalTime    = seconds( diff( [ startTime, datetime( 'now' ) ] ) );
    minutesTotal = fix( totalTime / 60 );
	secTotal     = totalTime - 60 * minutesTotal;

    % Downloadzeit [Sekunden]
    minutesDownLoad = fix( downLoadTime / 60 );
	secDownLoad     = downLoadTime - 60 * minutesDownLoad;

	home % Cursor -> Home
    arg1 = 'RKIData(): fertig!\n';
    arg2 = 'Downloadzeit: %2.0f Minuten %2.0f Sekunden \n';
    arg3 = 'Rechenzeit:   %2.0f Minuten %2.0f Sekunden';
    sprintf( [ arg1, arg2, arg3 ], minutesDownLoad, secDownLoad, ...
             minutesTotal, secTotal )
end