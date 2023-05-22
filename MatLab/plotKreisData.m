function plotKreisData( kreis, outputDirPrefix, ...
                        saveData, name, blName, lkName, bundesLandId, ...
                        events, datum, landkreisZeitreihen, ...
                        bundeslandZeitreihen, bundesrepublikZeitreihen, ...
                        modus, stichTag )

	% Umrechnung der Fälle in Inzidenzen (pro 100000 Einwohner)
    [ fak, fakBL, fakLK ] = normierungsFaktoren( bundesLandId, kreis );

    % Normierung
    neuNormiert   = bundesrepublikZeitreihen.neuInfektionen * fak;
    totNormiert   = bundesrepublikZeitreihen.todesFaelle * fak;
    neuBLNormiert = bundeslandZeitreihen.neuInfektionen( bundesLandId ) * fakBL;
    totBLNormiert = bundeslandZeitreihen.todesFaelle( bundesLandId ) * fakBL;
    neuLKNormiert = landkreisZeitreihen.neuInfektionen( kreis ) * fakLK;
    totLKNormiert = landkreisZeitreihen.todesFaelle( kreis ) * fakLK;

    ageNew   = bundesrepublikZeitreihen.ageNew;
    ageNewBL = bundeslandZeitreihen.ageNew( bundesLandId );
    ageNewLK = landkreisZeitreihen.ageNew( kreis );
    ageTot   = bundesrepublikZeitreihen.ageTot;
    ageTotBL = bundeslandZeitreihen.ageTot( bundesLandId );
    ageTotLK = landkreisZeitreihen.ageTot( kreis );

    % Mortalität berechnen
    [ ~, mort   ] = mortality( ageNew,   ageTot,   1 );
    [ ~, blMort ] = mortality( ageNewBL, ageTotBL, 1 );
    [ ~, lkMort ] = mortality( ageNewLK, ageTotLK, 1 );

    % Auswertezeitraum
    auswertungStart = datetime( '01.04.2020' );
    auswertungEnd   = datum( end ) - 60;    % 60 Tage vor aktuellem Datum
    ndx             = union( 1 : find( auswertungStart == datum ) - 1, ...
                             find( auswertungEnd == datum ) : length( datum ) );
    mort(   ndx ) = NaN;
    blMort( ndx ) = NaN;
    lkMort( ndx ) = NaN;

	figures = {};

    titel = 'Mortalität der Altersgruppe 60+';
    f     = plotMortality( [ titel, ' [%]' ], datum, mort, name, blMort, ...
                blName, lkMort, lkName, modus );
    figures = [ figures; { f, [ 'Mortalitaet', '-', lkName ] } ];

    % Plots für Landkreis, Bundesland, Deutschland
    titel = 'Inzidenz NeuInfektionen';
    f = plotData( titel, datum, neuNormiert, neuBLNormiert, neuLKNormiert, ...
        '[1.0 0.0 0.0]', '[1.0 0.3 0.3]', '[1.0 0.7 0.7]', name, blName, ...
        lkName, events, [], modus );
    figures = [ figures; { f, [ 'Neuinfektionen-Einwohneranzahl', '-', lkName ] } ];

    % Plots für Landkreis, Bundesland, Deutschland
    titel = 'Inzidenz Todesfälle';
    f = plotData( titel, datum, totNormiert, totBLNormiert, totLKNormiert, ...
        '[0.0 0.0 0.0]', '[0.3 0.3 0.3]', '[0.7 0.7 0.7]', name, blName, ...
        lkName, events, stichTag, modus );
    figures = [ figures; { f, [ 'Todesfälle-Einwohneranzahl', '-', lkName ] } ];

    titel = 'Inzidenz Neuinfektionen Landkreis';
    f = plotAgesLK( titel, datum, events, lkName, ageNewLK, fakLK, ...
                    stichTag, modus );
    figures = [ figures; { f, [ 'NeuinfektionenLandkreis-Altersklassen', '-', lkName ] } ];

    % Ages Neuinfektionen Deutschland, Bundesland, Landkreis
    titel  = 'Inzidenz Neuinfektionen';
    colors = [ '[ 0.0 0.8 0.0 ]'; '[ 0.0 0.5 0.0 ]'; '[ 0.0 0.3 0.0 ]'; '[ 0.0 0.1 0.0 ]' ];
    f = plotAgesTiled( titel, datum, events, lkName, blName, name, ageNewLK, ...
            ageNewBL, ageNew, fakLK, fakBL, fak, 50, colors, modus, ...
            'northwest', 'northwest', 'northwest' );
    figures = [ figures; { f, [ 'Neuinfektionen-Altersklassen', '-', lkName ] } ];

    % Darmstadt=6411, Frankfurt=6412, Gross-Gerau=6433, Odenwaldkreis=6437, Landkreis Offenbach=6438
    switch( kreis )
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
    titel  = 'Inzidenz Todesfälle';
    colors = [ '[0.8 0.8 0.8]'; '[0.4 0.4 0.4]'; '[0.2 0.2 0.2]'; '[0.0 0.0 0.0]' ];
    f = plotAgesTiled( titel, datum, events, lkName, blName, name, ageTotLK, ...
            ageTotBL, ageTot, fakLK, fakBL, fak, step, colors, modus, ...
            'northwest', 'northwest', location );
    figures = [ figures; { f, [ 'Todesfälle-Altersklassen', '-', lkName ] } ];

	if( saveData )
        % Statistikdaten (Kreis, Land, Deutschland) schreiben
        statistik( outputDirPrefix, lkName, kreis, bundesLandId, datum, ...
                   landkreisZeitreihen, blName, bundeslandZeitreihen, ...
                   bundesrepublikZeitreihen, stichTag  )

        saveFigures( figures, outputDirPrefix )
	end
end

function yMax = calcPlotMax( step, age, fak )
    % Diskretisierungs-Schrittweite step
	[ kind, erwachsen, alt ] = calcAltersklassen( age );

    kindMax      = max( meanFilter( kind * fak ) );
    erwachsenMax = max( meanFilter( erwachsen * fak ) );
    maxJung      = max( kindMax, erwachsenMax );

    maxAlt = max( meanFilter( alt * fak ) );
    ageMax = max( maxJung, maxAlt );

    % ACHTUNG: hier ist implizit eine max. Inzidenz von 1000*step implementiert
    for n = 1000 : -1 : -1
        m = step * n;
        if( ageMax > m )
            break
        end
    end

    yMax = m + step;
end

function f = plotAgesLK( titel, datum, events, lkName, ageLK, fakLK, ...
                         stichTag, modus )
    % Figure erzeugen
	f = createFigure( titel );

	yName = 'Inzidenz Neuinfektionen';

    % Maximalwert für die Darstellung bestimmen
    yMax = calcPlotMax( 50, ageLK, fakLK );

	plotAges( f, yName, events, lkName, datum, ageLK, fakLK, '[ 0.0 0.8 0.0 ]', ...
              '[ 0.0 0.5 0.0 ]', '[ 0.0 0.3 0.0 ]', '[ 0.0 0.1 0.0 ]', stichTag, yMax, ...
              'northwest', modus );
end

function f = plotAgesTiled( titel, datum, events, nameLK, nameBL, name, ageLK, ageBL, age, ...
                fakLK, fakBL, fak, step, colors, modus, legendLocation, ...
                legendLocationBL, legendLocationLK )

	cPupil = colors( 1, : );
	cYoung = colors( 2, :  );
	cOld   = colors( 3, :  );
	cAged  = colors( 4, :  );

    yMaxLK = calcPlotMax( step, ageLK, fakLK );
    yMaxBL = calcPlotMax( step, ageBL, fakBL );
    yMax   = calcPlotMax( step, age, fak );
    yMax   = max( max( yMaxLK, yMaxBL ), yMax );

    % Figure erzeugen
    f = createFigure( titel );

    yName = titel;

    tiledlayout( 1, 3 )

    % Ages Bundesrepublik
    nexttile
	plotAges( f, yName, events, name, datum, age, fak, cPupil, cYoung, ...
              cOld, cAged, [], yMax, legendLocation, modus );

    % Ages Bundesland
    nexttile
    plotAges( f, yName, events, nameBL, datum, ageBL, fakBL, cPupil, ...
              cYoung, cOld, cAged, [], yMax, legendLocationBL, modus );

    % Ages Landkreis
    nexttile
    plotAges( f, yName, events, nameLK, datum, ageLK, fakLK, cPupil, ...
              cYoung, cOld, cAged, [], yMax, legendLocationLK, modus );
end

function plotAges( f, yName, events, region, datum, ages, faktor, ...
                   cPupil, cYoung, cOld, ~, stichTag, yMax, ...
                   legendLocation, modus )
    % Alterskasse plotten
    [ kind, erwachsen, alt ] = calcAltersklassen( ages );

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

        datum     = datum( ndx );

        yyaxis left         % bezüglich linker Achse plotten
	end

    plotXYLabels( modus, yName )

    legendStr = {};

    if( ~isempty( kind ) )
        legendStr = [ legendStr, [ region, ' A00-A14' ] ];
        plot( datum, meanFilter( kind * faktor ), 'LineStyle', '-', ...
              'Linewidth', 2, 'Color', cPupil )
    end

	if( ~isempty( erwachsen ) )
        legendStr = [ legendStr, [ region, ' A15-A59' ] ];
        plot( datum, meanFilter( erwachsen * faktor ), 'LineStyle', '-', ...
              'Linewidth', 2, 'Color', cYoung )
	end

	if( ~isempty( alt ) )
        legendStr = [ legendStr, [ region, ' A60+' ] ];
        plot( datum, meanFilter( alt * faktor ), 'LineStyle', '-', ...
              'Linewidth', 2, 'Color', cOld )
	end

    % Datenpunkte der Einzelfälle darstellen
	if( ~isempty( stichTag )  && ~isempty( kind ) && ~isempty( erwachsen ) ...
            && ~isempty( alt ) )
        legendLocation = 'northwest';

        % keine Datenpunkte auf der Grundlinie (Fallanzahl=0) zeichnen
        kind( kind == 0 )           = Inf;
        erwachsen( erwachsen == 0 ) = Inf;
        alt( alt == 0 )             = Inf;

        yyaxis right         % bezüglich rechter Achse plotten

        plotXYLabels( 4, 'Anzahl Einzelfälle' )  % 3:  x-Achsbeschriftung: ''

        % Altersklasse 0-14
        legendStr = [ legendStr, ' Einzelfälle A00-A14' ];
        plot( datum, kind * faktor, 'Marker', 'o', 'LineStyle', 'none', ...
             'MarkerEdgeColor', 'k', 'MarkerSize', 5, ...
             'MarkerFaceColor', 'g', 'Linewidth', 0.5 )

        % Altersklasse 15-59
        legendStr = [ legendStr, ' Einzelfälle A15-A59' ];
        plot( datum, erwachsen * faktor, 'Marker', 'o', 'LineStyle', 'none', ...
              'MarkerEdgeColor', 'r', 'MarkerSize', 5, ...
              'MarkerFaceColor', 'y', 'Linewidth', 0.5 )

        % Altersklasse 60+
        legendStr = [ legendStr, ' Einzelfälle A60+' ];
        plot( datum, alt * faktor, 'Marker', 'o', 'LineStyle', 'none', ...
             'MarkerEdgeColor', 'k', 'MarkerSize', 4, 'MarkerFaceColor', 'm', ...
             'Linewidth', 0.5 )

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
