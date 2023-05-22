function initializeStatistikDatenstand
	load( 'bundesland.mat', 'landkreisKeys' )

    % leere Maps erzeugen
    landkreisZeitreihenDatenstand.neuInfektionen = containers.Map( 'KeyType', 'int32', ...
        'ValueType', 'any' );
    landkreisZeitreihenDatenstand.todesFaelle    = containers.Map( 'KeyType', 'int32', ...
        'ValueType', 'any' );

    letzterDatenstand = datetime( '01.01.1900', 'InputFormat', 'dd.MM.yyyy' );

	defaultEntry = zeros( 1, 1 );

    len = length( landkreisKeys );
    for n = 1 : len
        key = landkreisKeys( n );

        landkreisZeitreihenDatenstand.neuInfektionen( key ) = defaultEntry;
        landkreisZeitreihenDatenstand.todesFaelle( key )    = defaultEntry;
    end

	save( 'statistikDatenstand.mat', 'landkreisKeys', 'landkreisZeitreihenDatenstand', ...
          'letzterDatenstand' )

    home; sprintf( 'InitializeStatistik(): fertig!' )
end