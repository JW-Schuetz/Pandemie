function testPlotMort()
    clc
    clear

    % RKI-Datenbasis einlesen
    load( 'rkiMap.mat', 'datum', 'landkreisKeys', 'landkreisName', ...
          'landkreisZeitreihen', 'bundeslandName', 'bundeslandZeitreihen', ...
          'bundesrepublikZeitreihen', 'modus' )

    name = 'Deutschland';

    land   = 6;
    blName = bundeslandName( land );
    blName = blName{ 1 };

    % Bundesrepublik-Alterszeitreihen
    ageN = bundesrepublikZeitreihen.ageNew;
    ageT = bundesrepublikZeitreihen.ageTot;

    % Bundesland-Alterszeitreihen
    blAgeN = bundeslandZeitreihen.ageNew( land );
    blAgeT = bundeslandZeitreihen.ageTot( land );

    % LK Bitburg-Prüm (4.8%), Odenwaldkreis (40.3%), SK Suhl (100%)
    kreise = [ 7232, 6437, 16054 ];

    for lk = 1 : length( kreise )
        kreis  = kreise( lk );
        lkName = landkreisName( kreis );
        lkName = lkName{ 1 };
        lkName = alias( lkName );

        % Landkreis-Alterszeitreihen
        lkAgeN = landkreisZeitreihen.ageNew( kreis );
        lkAgeT = landkreisZeitreihen.ageTot( kreis );

        % Mortalität berechnen
        [ ~, mort   ] = mortality( ageN,   ageT,   0 );
        [ ~, blMort ] = mortality( blAgeN, blAgeT, 0 );
        [ ~, lkMort ] = mortality( lkAgeN, lkAgeT, 0 );

        % Auswertezeitraum
        auswertungStart = datetime( '01.04.2020' );
        auswertungEnd   = datetime( '01.10.2021' );
        ndx             = union( 1 : find( auswertungStart == datum ) - 1, ...
                                 find( auswertungEnd == datum ) : length( datum ) );

        mort(   ndx ) = NaN;
        blMort( ndx ) = NaN;
        lkMort( ndx ) = NaN;

        titel = 'Mortalität der Altersgruppe 60+';
        f     = plotMortality( [ titel, ' [%]' ], datum, mort, name, blMort, ...
                    blName, lkMort, lkName, modus );
        f.WindowState = 'maximized';
    end
end