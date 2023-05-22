function zeitreihen = processBundesrepublikDaten( datum, bundeslandZeitreihen, bundeslandKeys )
    % Anzahl der Tage
    numDays = length( datum );

    % bundesweit
	zeitreihen.neuInfektionen = zeros( numDays, 1 );
	zeitreihen.todesFaelle    = zeros( numDays, 1 );
    zeitreihen.ageNew         = cell( numDays, 1 );
    zeitreihen.ageTot         = cell( numDays, 1 );

    for n = 1 : numDays
        zeitreihen.ageNew( n ) = { zeros( 7, 1 ) };
        zeitreihen.ageTot( n ) = { zeros( 7, 1 ) };
    end

    keyLength = length( bundeslandKeys );

    for k = 1 : keyLength
        key = bundeslandKeys( k );

        zeitreihen.neuInfektionen = zeitreihen.neuInfektionen + bundeslandZeitreihen.neuInfektionen( key );
        zeitreihen.todesFaelle    = zeitreihen.todesFaelle + bundeslandZeitreihen.todesFaelle( key );
        zeitreihen.ageNew         = mergeBins( zeitreihen.ageNew, bundeslandZeitreihen.ageNew( key ) );
        zeitreihen.ageTot         = mergeBins( zeitreihen.ageTot, bundeslandZeitreihen.ageTot( key ) );
   end

    home; sprintf( 'processBundesrepublikDaten(): fertig' )
end
