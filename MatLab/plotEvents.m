function legendStr = plotEvents( legendStr, events, yMax )
    if( ~isempty( events ) )
        for n = 1 : length( events )
            e = events{ n };
            legendStr = [ legendStr, e( 1 ) ]; %#ok<AGROW>

            plot( [ e{ 2 }, e{ 2 } ], [ 0, yMax ], 'Marker', 'none', ...
                  'LineStyle', '-', 'Color', 'b', 'Linewidth', 0.5 )
        end
    end
end