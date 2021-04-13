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
            endDat( cnt ) = impfEnde( sum( gesamtimpfungen( 1 : n ) ), ...
                                datum( n ), datum( 1 ), false );
            cnt = cnt + 1;
        end
    end

    % in Stunden umrechnen für die Regression
    N    = length( dat );
    stdX = zeros( N, 1 );
    stdY = zeros( N, 1 );
    for n = 2 : N
        stdX( n ) = hours( dat( n ) - dat( 1 ) );
        stdY( n ) = hours( endDat( n ) - endDat( 1 ) );
    end

    % Datei "DatumImpfende.txt" aktualisieren
    impfEnde( sum( gesamtimpfungen( 1 : end ) ), datum( end ), ...
                datum( 1 ), true );

	if( nargin ~= 0 )
        f = figure( 'Name', titel );
	else
        f = figure( 'Name', 'Impfstatistik' );
	end

	hold on
    grid on

    ax     = f.CurrentAxes;
    ax.Box = 'on';              % Rahmen zeichnen

	xlabel( 'Datum', 'FontSize', 12, 'FontWeight', 'normal' )
    ylabel( 'Geschätztes Datum Impfende', 'FontSize', 12, 'FontWeight', 'normal' )

    plot( dat, endDat, 'Color', 'k', 'Linewidth', 2 )
    plot( datetime( 'today' ), datetime( 'today' ), 'Color', 'r', ...
        'Marker', 'o', 'MarkerFaceColor', 'r' )

    % Regression rechnen und plotten
 	[ ax, ay ] = Regression( stdX, stdY );
% 	plot( [ dat( 1 ), dat( end ) ], [ ax*stdX(1) + ay, ax*stdY( end ) + ay ], ...
%             'g', 'Marker', 'o' )
end