function doItAll( inputFileName, outputDirPrefix, withTestanzahl, withAge80Plus, saveData, ...
                  kreisId, k, bundesLandId, events )
    % RKI-Datenbasis einlesen
	load( inputFileName, 'datum', 'landkreisKeys', 'landkreisName', 'landkreisZeitreihen', ...
          'bundeslandName', 'bundeslandZeitreihen', 'bundesrepublikZeitreihen', 'modus', ...
          'stichTag' )

    Name   = 'Deutschland';
	blName = bundeslandName( bundesLandId );
    blName = blName{ 1 };
    lkName = landkreisName( kreisId( k ) );
    lkName = lkName{ 1 };
    lkName = alias( lkName );

    % Normierungsfaktoren (pro 100000 Einwohner)
    [ fak, fakBL, fakLK ] = normierungsFaktoren( bundesLandId, kreisId( k ) );

    % Normierung
    neuNormiert   = bundesrepublikZeitreihen.neuInfektionen * fak;
    totNormiert   = bundesrepublikZeitreihen.todesFaelle * fak;
    neuBLNormiert = bundeslandZeitreihen.neuInfektionen( bundesLandId ) * fakBL;
    totBLNormiert = bundeslandZeitreihen.todesFaelle( bundesLandId ) * fakBL;
    neuLKNormiert = landkreisZeitreihen.neuInfektionen( kreisId( k ) ) * fakLK;
    totLKNormiert = landkreisZeitreihen.todesFaelle( kreisId( k ) ) * fakLK;

    ageNew   = bundesrepublikZeitreihen.ageNew;
    ageNewBL = bundeslandZeitreihen.ageNew( bundesLandId );
    ageNewLK = landkreisZeitreihen.ageNew( kreisId( k ) );
    ageTot   = bundesrepublikZeitreihen.ageTot;
    ageTotBL = bundeslandZeitreihen.ageTot( bundesLandId );
    ageTotLK = landkreisZeitreihen.ageTot( kreisId( k ) );

    neuInfektionenLK = landkreisZeitreihen.neuInfektionen;

	figures = {};

    if( withTestanzahl )
        % Startdatum, Datum des ersten Datensatzes
        titel = 'Tägliche Testanzahl';
        f = plotTestanzahl( titel, 250000, testAnzahl );
        figures = [ figures; { f, 'Testanzahlen' } ];
    else
        % Plot Datenstand
        titel = 'Neuinfektionen/Todesfälle Datenstandsdatum';
        f = plotDatenstand( titel, datum, fak, Name, events );
        f.WindowState = 'maximized';
        figures = [ figures; { f, 'Neu-Tot-Datenstand-Einwohneranzahl' } ];

        % Plots für Landkreis, Bundesland, Deutschland
        titel = 'Tägliche NeuInfektionen';
        f = plotData( titel, datum, neuNormiert, neuBLNormiert, neuLKNormiert, ...
            '[1.0 0.0 0.0]', '[1.0 0.3 0.3]', '[1.0 0.7 0.7]', Name, blName, lkName, ...
            events, [], modus );
        f.WindowState = 'maximized';
        figures = [ figures; { f, [ 'Neuinfektionen-Einwohneranzahl', '-', lkName ] } ];

        % Plots für Landkreis, Bundesland, Deutschland
        titel = 'Tägliche Todesfälle';
        f = plotData( titel, datum, totNormiert, totBLNormiert, totLKNormiert, ...
            '[0.0 0.0 0.0]', '[0.3 0.3 0.3]', '[0.7 0.7 0.7]', Name, blName, ...
            lkName, events, stichTag, modus );
        f.WindowState = 'maximized';
        figures = [ figures; { f, [ 'Todesfälle-Einwohneranzahl', '-', lkName ] } ];

        % Inzidenzen (0, klein, gross)
        titel = 'Inzidenzen';
        f = plotInzidenzen( titel, events, '[0.0 0.7 0.0]', '[0.0 0.3 0.0]', 'r', datum, ...
                landkreisKeys, neuInfektionenLK, 35, 50, modus );
        f.WindowState = 'maximized';
        figures = [ figures; { f, 'LandkreiseNeuinfektionen' } ];

        titel = 'Tägliche Neuinfektionen Landkreis';
        f = plotAgesLK( titel, datum, events, lkName, ageNewLK, fakLK, stichTag, modus, ...
                withAge80Plus );
        f.WindowState = 'maximized';
        figures = [ figures; { f, [ 'NeuinfektionenLandkreis-Altersklassen', '-', lkName ] } ];

        % Ages Neuinfektionen Deutschland, Bundesland, Landkreis
        titel  = 'Tägliche Neuinfektionen';
        colors = [ '[ 0.0 0.8 0.0 ]'; '[ 0.0 0.5 0.0 ]'; '[ 0.0 0.3 0.0 ]'; '[ 0.0 0.1 0.0 ]' ];
        f = plotAgesTiled( titel, datum, events, lkName, blName, Name, ageNewLK, ...
                ageNewBL, ageNew, fakLK, fakBL, fak, 50, colors, modus, withAge80Plus, ...
                'northwest', 'northwest', 'northwest' );
        f.WindowState = 'maximized';
        figures = [ figures; { f, [ 'Neuinfektionen-Altersklassen', '-', lkName ] } ];

        % Darmstadt=6411, Frankfurt=6412, Gross-Gerau=6433, Odenwaldkreis=6437, Landkreis Offenbach=6438
        switch( kreisId( k ) )
            case 6437
                step     = 50;
                location = 'northeast';
            case { 6412, 6433 }
                step     = 10;
                location = 'northwest';
            otherwise
                step     = 20;
                location = 'northwest';
        end

        % Ages Todesfälle Deutschland, Bundesland, Landkreis
        titel  = 'Tägliche Todesfälle';
        colors = [ '[0.8 0.8 0.8]'; '[0.4 0.4 0.4]'; '[0.2 0.2 0.2]'; '[0.0 0.0 0.0]' ];
        f = plotAgesTiled( titel, datum, events, lkName, blName, Name, ageTotLK, ...
                ageTotBL, ageTot, fakLK, fakBL, fak, step, colors, modus, withAge80Plus, ...
                'northwest', 'northwest', location );
        f.WindowState = 'maximized';
        figures = [ figures; { f, [ 'Todesfälle-Altersklassen', '-', lkName ] } ];

        % Impfstatistik (nur ein mal rechnen)
        if( k == 1 )
            titel = 'Impfstatistik';
            f     = impfStatistik( titel );
            f.WindowState = 'maximized';
            figures = [ figures; { f, 'ImpfStatistik' } ];
        end
    end

	if( saveData )
         % Statistikdaten (Kreis, Land, Deutschland) schreiben
        statistik( outputDirPrefix, kreisId( k ), bundesLandId )

        for n = 1 : size( figures, 1 )
            f = figures{ n, 1 };
            saveas( f, [ outputDirPrefix, figures{ n, 2 } ], 'epsc' );
        end

        close( 'all' )
	end
end

function yMax = calcPlotMax( step, age, fak, withAge80Plus )
    % Diskretisierungs-Schrittweite step
	[ kind, erwachsen, alt, greis ] = calcAltersklassen( age );

    kindMax      = max( meanFilter( kind * fak ) );
    erwachsenMax = max( meanFilter( erwachsen * fak ) );
    maxJung      = max( kindMax, erwachsenMax );

    if( withAge80Plus )
        altMax   = max( meanFilter( alt * fak ) );
        greisMax = max( meanFilter( greis * fak ) );
        ageMax   = max( max( max( maxJung ), altMax ), greisMax );
    else
        maxAlt = max( meanFilter( ( alt + greis ) * fak ) );
        ageMax = max( maxJung, maxAlt );
    end

    for n = 20 : -1 : -1
        m = step * n;
        if( ageMax > m )
            break
        end
    end

    yMax = m + step;
end

function f = plotAgesLK( titel, datum, events, lkName, ageLK, fakLK, stichTag, modus, ...
                withAge80Plus )
	f = figure( 'Name', titel );

	yName = 'Tägliche Neuinfektionen';

    % Maximalwert für die Darstellung bestimmen
    yMax = calcPlotMax( 50, ageLK, fakLK, withAge80Plus );

	plotAges( f, yName, events, lkName, datum, ageLK, fakLK, '[ 0.0 0.8 0.0 ]', ...
              '[ 0.0 0.5 0.0 ]', '[ 0.0 0.3 0.0 ]', '[ 0.0 0.1 0.0 ]', stichTag, yMax, ...
              'northwest', modus, withAge80Plus );
end

function f = plotAgesTiled( titel, datum, events, nameLK, nameBL, name, ageLK, ageBL, age, ...
                fakLK, fakBL, fak, step, colors, modus, withAge80Plus, legendLocation, ...
                legendLocationBL, legendLocationLK )

	cPupil = colors( 1, : );
	cYoung = colors( 2, :  );
	cOld   = colors( 3, :  );
	cAged  = colors( 4, :  );

    yMaxLK = calcPlotMax( step, ageLK, fakLK, withAge80Plus );
    yMaxBL = calcPlotMax( step, ageBL, fakBL, withAge80Plus );
    yMax   = calcPlotMax( step, age, fak, withAge80Plus );
    yMax   = max( max( yMaxLK, yMaxBL ), yMax );

    f = figure( 'Name', titel );

    yName = titel;

    tiledlayout( 1, 3 )

    % Ages Bundesrepublik
    nexttile
	plotAges( f, yName, events, name, datum, age, fak, cPupil, cYoung, cOld, cAged, [], yMax, ...
              legendLocation, modus, withAge80Plus );

    % Ages Bundesland
    nexttile
    plotAges( f, yName, events, nameBL, datum, ageBL, fakBL, cPupil, cYoung, cOld, cAged, [], ...
              yMax, legendLocationBL, modus, withAge80Plus );

    % Ages Landkreis
    nexttile
    plotAges( f, yName, events, nameLK, datum, ageLK, fakLK, cPupil, cYoung, cOld, cAged, [], ...
              yMax, legendLocationLK, modus, withAge80Plus );
end

function plotAges( f, yName, events, region, datum, ages, faktor, cPupil, cYoung, cOld, cAged, ...
            stichTag, yMax, legendLocation, modus, withAge80Plus )
    % Alterskasse plotten
    [ kind, erwachsen, alt, greis ] = calcAltersklassen( ages );

	hold on
    grid on

    ax     = f.CurrentAxes;
    ax.Box = 'on';	% Rahmen zeichnen

    % evtl. kein gemeinsames y-Limit berücksichtigen
	if( yMax ~= 0 )
        ax.YLim( 2 ) = yMax;
	end

	if( ~isempty( stichTag ) )
        % erst ab Stichtag beginnen
        ndx = find( datum >= stichTag );

        kind      = kind( ndx );
        erwachsen = erwachsen( ndx );
        alt       = alt( ndx );
        greis     = greis( ndx );

        datum     = datum( ndx );
	end

    plotXYLabels( modus, yName )

    legendStr = {};

    if( ~isempty( kind ) )
        legendStr = [ legendStr, [ region, ' A00-A14' ] ];
        plot( datum, meanFilter( kind * faktor ), 'Linewidth', 2, 'Color', cPupil )
    end

	if( ~isempty( erwachsen ) )
        legendStr = [ legendStr, [ region, ' A15-A59' ] ];
        plot( datum, meanFilter( erwachsen * faktor ), 'Linewidth', 2, 'Color', cYoung )
	end

	if( ~isempty( alt ) && ~isempty( greis ) )
        if( withAge80Plus )
            legendStr = [ legendStr, [ region, ' A60-A79' ] ];
            plot( datum, meanFilter( alt * faktor ), 'Linewidth', 2, 'Color', cOld )

            legendStr = [ legendStr, [ region, ' A80+' ] ];
            plot( datum, meanFilter( greis * faktor ), 'Linewidth', 2, 'Color', cAged )
        else
            legendStr = [ legendStr, [ region, ' A60+' ] ];
            plot( datum, meanFilter( ( alt + greis ) * faktor ), 'Linewidth', 2, 'Color', cOld )
        end
	end

    % Datenpunkte der Einzelfälle darstellen
	if( ~isempty( stichTag )  && ~isempty( kind ) && ~isempty( erwachsen ) ...
            && ~isempty( alt ) && ~isempty( greis ) )
        legendLocation = 'northwest';

        % keine Datenpunkte auf der Grundlinie (Fallanzahl=0) zeichnen
        kind( kind == 0 )           = Inf;
        erwachsen( erwachsen == 0 ) = Inf;
        alt( alt == 0 )             = Inf;
        greis( greis == 0 )         = Inf;

        % Altersklasse 0-14
        legendStr = [ legendStr, ' Einzelfälle A00-A14' ];
        plot( datum, kind * faktor, 'Marker', 'o', 'LineStyle', 'none', 'MarkerEdgeColor', 'k', ...
              'MarkerSize', 5, 'MarkerFaceColor', 'g', 'Linewidth', 0.5 )

        % Altersklasse 15-59
        legendStr = [ legendStr, ' Einzelfälle A15-A59' ];
        plot( datum, erwachsen * faktor, 'Marker', 'o', 'LineStyle', 'none', 'MarkerEdgeColor', 'r', ...
              'MarkerSize', 5, 'MarkerFaceColor', 'y', 'Linewidth', 0.5 )

        if( withAge80Plus )
            % Altersklasse 60-79
            legendStr = [ legendStr, ' Einzelfälle A60-A79' ];
            plot( datum, alt * faktor,  'Marker', 'o', 'LineStyle', 'none', 'MarkerEdgeColor', 'k', ...
                  'MarkerSize', 4, 'MarkerFaceColor', 'm', 'Linewidth', 0.5 )

            % Altersklasse 80+
            legendStr = [ legendStr, ' Einzelfälle A80+' ];
            plot( datum, greis * faktor,  'Marker', 'o', 'LineStyle', 'none', 'MarkerEdgeColor', 'k', ...
                  'MarkerSize', 4, 'MarkerFaceColor', 'k', 'Linewidth', 0.5 )
        else
            % Altersklasse 60+
            legendStr = [ legendStr, ' Einzelfälle A60+' ];
            plot( datum, ( alt + greis ) * faktor,  'Marker', 'o', 'LineStyle', 'none', 'MarkerEdgeColor', 'k', ...
                  'MarkerSize', 4, 'MarkerFaceColor', 'm', 'Linewidth', 0.5 )
        end

        % Events später oder gleich als Stichtag
        eventsM = [];
        for n = 1 : length( events )    % Hier besser find() benutzen!
            if( events{ n }{ 2 } >= stichTag )
                eventsM = [ eventsM; events( n ) ]; %#ok<AGROW>
            end
        end

        % Events plotten
        legendStr = plotEvents( legendStr, eventsM, ax.YLim( 2 ) );
    else
        % Events plotten
        legendStr = plotEvents( legendStr, events, ax.YLim( 2 ) );
	end

	legend( legendStr, 'Location', legendLocation )
end

function [ kind, erwachsen, alt, greis ] = calcAltersklassen( ages )
    len = length( ages );

	kind      = zeros( len, 1 );
	erwachsen = zeros( len, 1 );
    alt       = zeros( len, 1 );
    greis     = zeros( len, 1 );

    for n = 1 : len
        kind( n )      = ages{ n }( 1 ) + ages{ n }( 2 );	% 'A00-A04' + 'A05-A14'
        erwachsen( n ) = ages{ n }( 3 ) + ages{ n }( 4 );   % 'A15-A34' + 'A35-A59'
        alt( n )       = ages{ n }( 5 ) + ages{ n }( 6 );   % 'A60-A79' + 'A80+'
        greis( n )     = ages{ n }( 6 );                    % 'A80+'
    end
end

function f = plotTestanzahl( titel, yMax, testAnzahl ) %#ok<DEFNU>
    f = figure( 'Name', titel );

	hold on
    grid on

    ax     = f.CurrentAxes;
    ax.Box = 'on';              % Rahmen zeichnen

    yName = 'Tägliche Testanzahl';
    plotXYLabels( 3, yName )

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