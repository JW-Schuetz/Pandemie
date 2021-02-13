function correlateRKIData()
    clc
    clear

    % Statistik der Datenstände einlesen
	load( 'statistikDatenstand.mat', 'datum', 'landkreisKeys', 'landkreisZeitreihenDatenstand', ...
          'letzterDatenstand' )

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

    datum( end + 1 ) = datetime( 'today' );

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

    a = neu;
    b = tot;
    c = xcorr( a, b, 'normalized' );

    hold on
    grid on
    plot( a )
    plot( b )
end