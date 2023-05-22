function [ mortMax, mort ] = mortality( ageNew, ageTot, normToBeUsed )

        % Altersklassen: nur die Alten 60+
        [ ~, ~, altNew ] = calcAltersklassen( ageNew );
        [ ~, ~, altTot ] = calcAltersklassen( ageTot );

        % sind überhaupt Daten da?
        if( sum( altNew ) == 0 )
            % fehlende Daten: kennzeichnen mit 0%
            mort    = zeros( ndxEnd - ndxStart );
            mortMax = 0;
            return
        end

        N    = length( ageNew );
        mort = Inf * ones( N, 1 );

        valNew  = 0;
        valTot  = 0;

        for n = 1 : N
            valNew = valNew + altNew( n );
            valTot = valTot + altTot( n );

            if( valNew ~= 0 )
                mort( n ) = 100 * valTot / valNew;
            else
                mort( n ) = NaN;
            end
        end

        ndx  = ( mort ~= Inf );
        mort = mort( ndx );

        switch( normToBeUsed )
            case 0
                % Ende der Zeitreihe
                mortMax = mort( end );
            case 1
                % Maximum der Zeitreihe
                mortMax = max( mort );
        end
end