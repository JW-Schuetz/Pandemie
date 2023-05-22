function plotRKIData()
    clc
    clear

	events = { ...
        { 'Veranstaltungsverbot',   datetime( '09.03.2020' ) };
        { 'Kontaktverbot',          datetime( '23.03.2020' ) };
%       { 'Toennies-Ausbruch',      datetime( '17.06.2020' ) };
        { 'Grenzöffnungen',         datetime( '21.06.2020' ) };
        { 'Lockdown (Soft)',        datetime( '01.11.2020' ) };
        { 'Lockdown (Hard)',        datetime( '16.12.2020' ) };
        { '1. Lockerung Schulen',   datetime( '22.02.2021' ) }
	};

    % Auswerteparameter
    auto           = 1;     % automatische Konversion in PDF-Dateien (mit LyX)
    saveData       = 1;     % erzeugte Grafiken/Statistik speichern
    withTestanzahl = 0;

    % RKI-Datenbasis einlesen
    inputFileName = 'rkiMap.mat';
	load( inputFileName, 'datum', 'landkreisKeys', 'landkreisName', ...
          'landkreisZeitreihen', 'bundeslandName', 'bundeslandZeitreihen', ...
          'bundesrepublikZeitreihen', 'modus', 'stichTag' )

    % Zielordner für die erzeugten Dateien (im Fall saveData=true)
    if( auto )
        outputDirPrefix = '..\LyX\';
    else
        outputDirPrefix = 'D:\VBSharedFolder\Debian\Pandemie\'; %#ok<UNRCH>
    end

    % Auswertegebiet Bundesrepublik
	name = 'Deutschland';

    % Auswertegebiet Bundesland, Hessen=6
    bundesLandId = 6;
    blName       = bundeslandName( bundesLandId );
    blName       = blName{ 1 };

    % vom Kreis unabhängige Plots
	figures = {};

	% Umrechnung der Fälle in Inzidenzen (pro 100000 Einwohner)
    fak = normierungsFaktoren();

    % Startdatum, Datum des ersten Datensatzes
    if( withTestanzahl )
        titel = 'Tägliche Testanzahl'; %#ok<UNRCH>
        f     = plotTestanzahl( titel, 350000, testAnzahl );
        figures = [ figures; { f, 'Testanzahlen' } ];
    end

    % Plot Datenstand
    titel = 'Neuinfektionen/Todesfälle Datenstandsdatum';
    f     = plotDatenstand( titel, datum, fak, name, events );
    figures = [ figures; { f, 'Neu-Tot-Datenstand-Einwohneranzahl' } ];

    % Inzidenzen (0, klein, gross)
    neuInfektionenLK = landkreisZeitreihen.neuInfektionen;

    titel = 'Inzidenzen';
    f     = plotKreisInzidenzen( titel, events, '[0.0 0.7 0.0]', '[0.0 0.3 0.0]', ...
                'r', datum, landkreisKeys, neuInfektionenLK, 35, 50, modus );
    figures = [ figures; { f, 'LandkreiseNeuinfektionen' } ];

	if( saveData )
        saveFigures( figures, outputDirPrefix )
	end

	% Odenwaldkreis=6437, Darmstadt=6411, Frankfurt=6412,
    % Dieburg=6432, Gross-Gerau=6433, LK-Offenbach=6438
    kreisId = [ 6437, 6411, 6412, 6432, 6433, 6438 ];

    for k = 1 : length( kreisId )
        kreis  = kreisId( k ) %#ok<NOPRT>
        lkName = landkreisName( kreis );
        lkName = lkName{ 1 };
        lkName = alias( lkName );

        plotKreisData( kreis, outputDirPrefix, ...
                       saveData, name, blName, lkName, bundesLandId, ...
                       events, datum, landkreisZeitreihen, ...
                       bundeslandZeitreihen, bundesrepublikZeitreihen, ...
                       modus, stichTag )

        if( auto )
            % Grafiken in PDF konvertieren
            exe     = '"C:\Program Files (x86)\LyX 2.3\bin\LyX.exe"';
            pdfName = sprintf( 'Aktuelle-Zahlen-%s', lkName );

            cmd = sprintf( '%s -e pdf2 ../LyX/%s.lyx', exe, pdfName );
            [ state, msg ] = system( cmd );
            if( state )
                error( 'Kommando \"%s\" scheiterte mit der Meldung: \"%s\"', ...
                       cmd, msg )
            end

            cmd = sprintf( 'move /Y ../LyX/%s.pdf ..', pdfName );
            [ state, msg ] = system( cmd );
            if( state )
                error( 'Kommando \"%s\" scheiterte mit der Meldung: \"%s\"', ...
                       cmd, msg )
            end
        end
    end
end

function f = plotDatenstand( titel, datum, fak, Name, events )
    % Statistik der Datenstände einlesen
	load( 'statistikDatenstand.mat', 'landkreisKeys', ...
          'landkreisZeitreihenDatenstand', 'letzterDatenstand' )

    % Datumsarray bis zum letzten Datenstand erweitern
	datum = generateDateArray( datum( 1 ), letzterDatenstand );

    % Deutschland Neuinfektionen und Todesfälle über dem Datenstand
    tage = daysdif( datum( 1 ), letzterDatenstand ) + 1;
    neu  = zeros( 1, tage );
    tot  = zeros( 1, tage );

    neuDatenstand = landkreisZeitreihenDatenstand.neuInfektionen;
    totDatenstand = landkreisZeitreihenDatenstand.todesFaelle;

    for n = 1 : length( neuDatenstand )
        key = landkreisKeys( n );

        neu  = neu + neuDatenstand( key );
        tot  = tot + totDatenstand( key );
    end

    % aus den täglichen Lageberichten des RKI abgetippte Fallzahlen
    [ dat, neuDatenstand, totDatenstand ] = staticStatistikDatenstand();
    for n = 1 : length( dat )
        tag = daysdif( datum( 1 ), dat( n ) ) + 1;

        neu( tag ) = neuDatenstand( n );
        tot( tag ) = totDatenstand( n );
    end

    neu     = neu * fak;
    neuMean = meanFilter( neu );
    tot     = tot * fak;
    totMean = meanFilter( tot );

    % Figure erzeugen
    f = createFigure( titel );

    % geteilter Zeitraum
    tiledlayout( 1, 2 )

    nexttile

    yName = 'Inzidenz Neuinfektionen';
    plotDataTile( f, yName, datum, neu, neuMean, [], [], [], [], ...
                  '[1.0 0.0 0.0]', 0, 0, Name, '', '', [], events, ...
                  'northwest', 2 );
    nexttile

    yName = 'Inzidenz Todesfälle';
    legendStr = plotDataTile( f, yName, datum, tot, totMean, [], [], [], ...
                    [], '[0.0 0.0 0.0]', 0, 0, Name, '', '', [], events, ...
                    'northwest', 2 );

    ax = f.CurrentAxes;
	legendStr = plotEvents( legendStr, events, ax.YLim( 2 ) );

	legend( legendStr, 'Location', 'west' )
end

function f = plotTestanzahl( titel, yMax, testAnzahl ) %#ok<DEFNU>
    % Figure erzeugen
    f = createFigure( titel );

	hold on
    grid on

    ax     = f.CurrentAxes;
    ax.Box = 'on';              % Rahmen zeichnen

    yName = 'Tägliche Testanzahl';

    plotXYLabels( 3, yName )    % x-Achsbeschriftung: 'Datum'

    ylim( [ 0, yMax ] )

    localEvents = { ...
        { 'Testkriterien geändert', datetime( '03.11.2020' ) };
	};

	legendStr = plotEvents( [], localEvents, ax.YLim( 2 ) );

	for n = 1 : length( testAnzahl )
        s = datetime( testAnzahl{ n, 1 }, 'InputFormat', 'dd.MM.yyyy' );
        e = datetime( testAnzahl{ n, 2 }, 'InputFormat', 'dd.MM.yyyy' );
        t = testAnzahl{ n, 3 } / days( e - s );

        plot( [ s, e ], [ t, t ], 'Color', 'k', 'Linewidth', 2 )
	end

	legend( legendStr, 'Location', 'northwest' )
end

function f = plotKreisInzidenzen( titel, events, cZero, cLow, cHigh, datum, ...
                             landkreisKeys, neuInfektionenLK, limLow, ...
                             limHigh, modus )
    limLow  = fix( limLow );
    limHigh = fix( limHigh );

    % Anzeigedaten berechnen
    [ datum, without, low, high, kreisanzahl ] = calcInzidenz( datum, ...
        landkreisKeys, neuInfektionenLK, limLow, limHigh );

    % Plotten
    f = createFigure( titel );

	hold on
    grid on

    ax     = f.CurrentAxes;
    ax.Box = 'on';              % Rahmen zeichnen

    yName = 'Anzahl der Kreise';
	plotXYLabels( modus, yName )

    legendStr = {};

	legendStr = [ legendStr, 'Inzidenz = 0' ];
    plot( datum, without, 'Linewidth', 2, 'Color', cZero )

	legendStr = [ legendStr, sprintf( 'Inzidenz <= %d', limLow ) ];
    plot( datum, low, 'Linewidth', 2, 'Color', cLow )

	legendStr = [ legendStr, sprintf( 'Inzidenz > %d', limHigh ) ];
    plot( datum, high, 'Linewidth', 2, 'Color', cHigh )

	legendStr = [ legendStr, 'Gesamtzahl der Kreise' ];
    plot( xlim, kreisanzahl * [ 1, 1 ], '--k', 'Linewidth', 1 )

    % Events plotten
    legendStr = plotEvents( legendStr, events, ax.YLim( 2 ) );

    % Legende
	legend( legendStr, 'Location', 'best' )
end

function [ datum, without, low, high, keyLength ] = calcInzidenz( datum, ...
            landkreisKeys, neuInfektionenLK, limLow, limHigh )
	% Bestimme die tägliche Anzahl der Landkreise für verschiedene Inzidenzen
	keyLength = length( landkreisKeys );

    numDays = length( datum );
    without = zeros( numDays, 1 );
    low     = zeros( numDays, 1 );
    high    = zeros( numDays, 1 );

    for n = 1 : numDays
        for k = 1 : keyLength
            key = landkreisKeys( k );
            neu = neuInfektionenLK( key );

            % 7-Tages Mittelwerte rechnen
            inz = meanFilter( neu );

            % Inzidenz am letzten Tag
            inzidenz = 100000 * inz( n ) / einwohnerKreis( key );

            if( inzidenz == 0 )
                without( n ) = without( n ) + 1;
            else
                if( inzidenz <= limLow )
                    low( n ) = low( n ) + 1;
                else
                    if( inzidenz > limHigh )
                        high( n ) = high( n ) + 1;
                    end
                end
            end
        end
    end
end