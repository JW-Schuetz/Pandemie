function legendStr = plotRegion( region, datum, data, meanData, color, ...
                        lineWidth, legendStr, stichTag, mec, mfc )
    % Wochenmittelwerte plotten
    if( ~isempty( data ) )
        plot( datum, meanData, 'Color', color, 'Linewidth', lineWidth )
        legendStr = [ legendStr, region ];
    end

    % Datenpunkte plotten
	if( ~isempty( stichTag ) && ~isempty( data ) )
        % erst nach Stichtag beginnen
        ndx   = find( datum > stichTag );
        datum = datum( ndx );
        data  = data( ndx );

        data( data == 0 ) = Inf;    % keine Datenpunkte auf der Grundlinie zeichnen

        if( ~isempty( data ) )
            legendStr   = [ legendStr, [ 'Einzelfälle ', region ] ];
            plot( datum, data, 'MarkerEdgeColor', mec, 'Linewidth', 0.5, ...
                  'Marker', 'o', 'MarkerSize', 5, 'MarkerFaceColor', mfc, ...
                  'LineStyle', 'none' )
        end
	end
end