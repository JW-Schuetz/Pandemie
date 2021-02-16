function f = plotInzidenzen( titel, events, cZero, cLow, cHigh, datum, landkreisKeys, ...
                             neuInfektionenLK, limLow, limHigh, modus )
    limLow  = fix( limLow );
    limHigh = fix( limHigh );

    % Anzeigedaten berechnen
    [ datum, without, low, high, kreisanzahl ] = calcInzidenz( datum, landkreisKeys, ...
        neuInfektionenLK, limLow, limHigh );

    % Plotten
    f = figure( 'Name', titel );

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

	legend( legendStr, 'Location', 'southwest' )
end

function [ datum, without, low, high, keyLength ] = calcInzidenz( datum, landkreisKeys, ...
            neuInfektionenLK, limLow, limHigh )
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