function f = plotDatenstand( titel, datum, fak, Name, events )
    % Statistik der Datenstände einlesen
	load( 'statistikDatenstand.mat', 'landkreisKeys', 'landkreisZeitreihenDatenstand', ...
          'letzterDatenstand' )

    % Datumsarray bis zum letzten Datenstand erweitern
	datum = generateDateArray( datum( 1 ), letzterDatenstand );

    % Deutschland Neuinfektionen und Todesfälle über dem Datenstand
    tage  = daysdif( datum( 1 ), letzterDatenstand ) + 1;
    neu   = zeros( 1, tage );
    tot   = zeros( 1, tage );

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

    f = figure( 'Name', titel );

    % geteilter Zeitraum
    tiledlayout( 1, 2 )

    nexttile

    yName = 'Tägliche Neuinfektionen';
    plotDataTile( f, yName, datum, neu, neuMean, [], [], [], [], '[1.0 0.0 0.0]', 0, 0, Name, ...
                  '', '', [], events, 'northwest', 2 );
    nexttile

    yName = 'Tägliche Todesfälle';
    legendStr = plotDataTile( f, yName, datum, tot, totMean, [], [], [], [], '[0.0 0.0 0.0]', ...
                    0, 0, Name, '', '', [], events, 'northwest', 2 );

    % geschätzte Obergrenze der täglichen Todesfälle Altersgruppe 60+
	legendStr = [ legendStr, 'Erwartete Todesfallanzahl 60+' ];
    plot( xlim, 6.22 * [ 1, 1 ], 'Color', '[0.5 0.5 0.5]', 'Linewidth', 2, 'LineStyle', '--' )

    % geschätzte Obergrenze der täglichen Todesfälle Altersgruppe 80+
%     legendStr = [ legendStr, 'Erwartete Todesfallanzahl 80+' ];
%     plot( xlim, 4.56 * [ 1, 1 ], 'Color', '[0.0 0.0 0.0]', 'Linewidth', 2, 'LineStyle', '--' )

    ax = f.CurrentAxes;
	legendStr = plotEvents( legendStr, events, ax.YLim( 2 ) );

	legend( legendStr, 'Location', 'west' )
end