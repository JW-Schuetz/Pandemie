function createStatistikDatenstand
    clc
    clear

	startDate = datetime( '01.01.2020' );

    initializeStatistikDatenstand

    directory = 'Tabellen\';
    list = dir( [ directory, 'table*.mat' ] );

    if( isempty( list ) )
        error( 'Keine Dateien gefunden' )
    end

    for n = 1 : length( list )
        inputFile = list( n ).name
        load( [ directory, inputFile ], 'tab' )

        updateStatistikDatenstand( tab, startDate )
    end
end