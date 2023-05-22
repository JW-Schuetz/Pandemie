function f = plotMortality( titel, datum, mort, name, blMort, ...
                            blName, lkMort, lkName, modus )
    % Figure erzeugen
    f = createFigure( titel );

    box on
    hold on
    grid on

    plotXYLabels( modus, titel )

	legendStr = {};

    plot( datum, mort,   'Color', 'k', 'Linewidth', 2 )
    legendStr = [ legendStr, name ];

    plot( datum, blMort, 'Color', 'r', 'Linewidth', 2 )
    legendStr = [ legendStr, blName ];

    plot( datum, lkMort, 'Color', 'b', 'Linewidth', 2 )
    legendStr = [ legendStr, lkName ];

	legend( legendStr )

    m( 1 ) = max( mort );
    m( 2 ) = max( blMort );
    m( 3 ) = max( lkMort );
    ylim( [ 0, 1.1 * max( m ) ] )
    xlim( [ datum( 1 ), datum( end ) ] )

%	errorbar( x, y, neg, pos )
end