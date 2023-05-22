function f = plotData( titel, datum, d, bl, lk, cd, cbl, clk, Name, blName, lkName, ...
                       events, stichTag, modus )
    % Figure erzeugen
    f = createFigure( titel );
    f.Name = titel;
    yName  = titel;

    % Mittelwerte
    md  = meanFilter( d );
    mbl = meanFilter( bl );
    mlk = meanFilter( lk );

	if( ~isempty( stichTag ) )
        % Grafik Todesfälle in zwei Bereiche teilen: "links" von Ende Januar bis einschliesslich
        % Stichtag und "rechts" von einschliesslich Stichtag bis heute.
        ndxL = find( datum < stichTag );
        ndxH = setdiff( 1 : length( datum ), ndxL );

        ndx  = find( datum == stichTag );
        ndxL = union( ndx, ndxL );

        % Datum
        datumL = datum( ndxL );
        datumH = datum( ndxH );

        % Mittelwerte
        mdL  = md( ndxL );
        mdH  = md( ndxH );
        mblL = mbl( ndxL );
        mblH = mbl( ndxH );
        mlkL = mlk( ndxL );
        mlkH = mlk( ndxH );

        % Deutschland
        dL = d( ndxL );
        dH = d( ndxH );

        % Bundesland
        blL = bl( ndxL );
        blH = bl( ndxH );

        % Landkreis
        lkL = lk( ndxL );
        lkH = lk( ndxH );

        % Events
        eventsL = [];
        eventsH = [];
        for n = 1 : length( events )    % Hier besser find() benutzen!
            if( events{ n }{ 2 } < stichTag )
                eventsL = [ eventsL; events( n ) ]; %#ok<AGROW>
            else
                eventsH = [ eventsH; events( n ) ]; %#ok<AGROW>
            end
        end

        % geteilter Zeitraum
        tiledlayout( 1, 2 )

        nexttile
        plotDataTile( f, yName, datumL, dL, mdL, blL, mblL, lkL, mlkL, cd, cbl, clk, Name, ...
                      blName, lkName, stichTag, eventsL, 'Northwest', modus );

        nexttile
        plotDataTile( f, yName, datumH, dH, mdH, blH, mblH, lkH, mlkH, cd, cbl, clk, Name, ...
                      blName, lkName, stichTag, eventsH, 'Northwest', modus );
    else
        % ungeteilter Zeitraum
        plotDataTile( f, yName, datum, d, md, bl, mbl, lk, mlk, cd, cbl, clk, Name, ...
                      blName, lkName, stichTag, events, 'Northwest', modus );
	end
end