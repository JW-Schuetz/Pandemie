function f = impfStatistik( titel )
	load( 'ImpfStatistik.mat', 'datum', 'gesamtimpfungen' )

    statistikStart = datetime( '01.02.2021' );

    endDat = datetime();
    dat    = datetime();
    cnt    = 1;

    N = length( datum );
    for n = 1 : N
        if( datum( n ) >= statistikStart )
            dat( cnt )    = datum( n );
            endDat( cnt ) = impfEnde1( sum( gesamtimpfungen( 1 : n ) ), ...
                                datum( n ), datum( 1 ), false );
            cnt = cnt + 1;
        end
    end

    % Datei "DatumImpfende1.txt" aktualisieren
    impfEnde1( sum( gesamtimpfungen( 1 : end ) ), datum( end ), ...
                datum( 1 ), true );

    [ r1, r2 ] = regression( dat, endDat );

    % Datei "DatumImpfende2.txt" aktualisieren
    impfEnde2(  r1( 2 ) );

	if( nargin ~= 0 )
        f = plotIt( titel, dat, endDat, r1, r2 );
	else
        f = plotIt( 'Impfstatistik', dat, endDat, r1, r2 );
	end
end

function [ r1, r2 ] = regression( dat, endDat )
    % in Stunden umrechnen für die Regression
    N    = length( dat );
    stdX = zeros( N, 1 );
    stdY = zeros( N, 1 );
    for n = 1 : N
        stdX( n ) = hours( dat( n ) - dat( 1 ) );
        stdY( n ) = hours( endDat( n ) - dat( 1 ) );
    end

    % Regressionsgerade rechnen [Stunden]: r = a * x + b
 	[ a, b ] = Regression( stdX, stdY );

    % (x,y) für heute: r = stdX( end ) -> x_0 = ( stdX( end ) - b ) / a
    x0 = ( stdX( end ) - b ) / a;
    y0 = stdX( end );

    % Start und Endpunkt der Regressionsgeraden [Stunden]
    r1 = [ stdX( 1 ), x0 ];
    r2 = [ a * stdX( 1 ) + b, y0 ];

    % Start und Endpunkt der Regressionsgeraden [Datum]
    r1 = dat( 1 ) + hours( r1 );
    r2 = dat( 1 ) + hours( r2 );
end

function f = plotIt( title, dat, endDat, r1, r2 )
    % Plotten der Ergebnisse
	f = figure( 'Name', title );

	hold on
    grid on

    ax     = f.CurrentAxes;
    ax.Box = 'on';              % Rahmen zeichnen

	xlabel( 'Datum', 'FontSize', 12, 'FontWeight', 'normal' )
    ylabel( 'Geschätztes Datum Impfende', 'FontSize', 12, 'FontWeight', 'normal' )

    plot( dat, endDat, 'Color', 'k', 'Linewidth', 2 )
    plot( r1, r2, 'Color', 'r', 'Linewidth', 1 )
    plot( r1( 2 ), r2( 2 ), 'Color', 'r', ...
          'Marker', 'o', 'MarkerFaceColor', 'r' )

    iend = [ 'Impfende: ', datestr( r1( 2 ),'dd-mm-yyyy' ) ];
	legend( { 'Datum Impfende', 'Regressionsgerade', iend }, ...
        'Location', 'northeast' )
end