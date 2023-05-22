function legendStr = plotDataTile( f, yName, datum, d, meanD, bl, meanBL, ...
                        lk, meanLK, cd, cbl, clk, Name, blName, lkName, ...
                        stichTag, events, legendLocation, modus )
	hold on
    grid on

    ax     = f.CurrentAxes;
    ax.Box = 'on';              % Rahmen zeichnen

    plotXYLabels( modus, yName )

	mec = 'k';    % Marker Edge Color
    mfc = 'r';    % Marker Face Color

	legendStr = {};

    if( ~isempty( d ) )
        legendStr = plotRegion( Name, datum, d, meanD, cd, 3, legendStr, ...
                        [], mec, mfc );
    end

    if( ~isempty( bl ) )
        legendStr = plotRegion( blName, datum, bl, meanBL, cbl, 2, ...
                        legendStr, [], mec, mfc  );
    end

    if( ~isempty( lk ) )
        legendStr = plotRegion( lkName, datum, lk, meanLK, clk, 1, ...
                        legendStr, stichTag, mec, mfc );
    end

    % Legende und Events darstellen (falls der aufrufende Kontext das nicht macht)
    if( nargout == 0 )
        legendStr = plotEvents( legendStr, events, ax.YLim( 2 ) );
        legend( legendStr, 'Location', legendLocation )
    end
end