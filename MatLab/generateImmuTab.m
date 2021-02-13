function newTab = generateImmuTab( fileName, dstDir )
    tab    = {};
	newTab = {};

    % Entscheidung: müssen neue RKI-Daten heruntergeladen werden?
    try
        load( 'immutab.mat', 'tab' )  % evtl. schon vorhandene Tabelle lesen

        if( ~isempty( tab{ 1 } ) )
            % Laden war erfolgreich
            if( ~isempty( find( tab{ 4 } == datetime( 'today' ), 1 ) ) )
                error( 'Fehler: RKI-Daten der Zukunft gelesen!' )
            end

            if( isempty( find( tab{ 4 } == datetime( 'yesterday' ), 1 ) ) )
                 newTab = doIt( tab, fileName, dstDir );
            end
        end
    catch
        % "table.mat" ist nicht vorhanden oder unleserlich
        newTab = doIt( tab, fileName, dstDir );
    end
end

function newTab = doIt( tab, fileName, dstDir )
    % Datei 'RKI_COVID19.csv' (mit curl) herunterladen
    downloadImmuData( fileName )

    % Datei 'RKI_COVID19.csv' lesen
    newTab = readImmuData( fileName, dstDir );

    % Datenstand neuer als der vorhandene?
    if( ~isempty( tab ) )
        if( newTab{ 4 } > tab{ 4 } )
            newTab = {};
        end
    end
end

function downloadImmuData( infile )
    % Daten des RKI mittels curl (https://github.com/curl/curl) downloaden
    % Beschreibung der Daten unter https://www.arcgis.com/home/item.html?id=f10774f1c63e40168479a1feb6c7ca74
    url = [ 'https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/', ...
            'Impfquotenmonitoring.xlsx?__blob=publicationFile' ];

    download( url, infile );

    if( isfile( infile ) == 0 )
        error( 'Fehler: Download fehlgeschlagen!' )
    end
end