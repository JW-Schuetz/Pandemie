function [ newTab, downLoadTime ] = generateRKITab( fileName, dstDir, idpos, inputFormat )
	newTab       = {};
    downLoadTime = NaN;

    % Entscheidung: müssen neue RKI-Daten heruntergeladen werden?
    try
        load( 'lastTable.mat', 'tab' )  % evtl. schon vorhandene Tabelle lesen

        if( ~isempty( tab ) )
            % Laden war erfolgreich
            % Es sind die Fälle denkbar:
            % Meldungen von heute -> File von morgen (das sollte nicht passieren :-))
            % Meldungen von gestern -> File von heute, also aktuell
            % keine Meldungen von heute und gestern -> File veraltet
            if( ~isempty( find( tab{ 1 }.Meldedatum == datetime( 'today' ), 1 ) ) )
                error( 'Fehler: RKI-Daten der Zukunft gelesen!' )
            end

            if( isempty( find( tab{ 1 }.Meldedatum == datetime( 'yesterday' ), 1 ) ) )
                [ newTab, downLoadTime ] = doIt( fileName, dstDir, inputFormat, idpos );
            end
        end
    catch
        % "table.mat" ist nicht vorhanden oder kann nicht gelesen werden
        [ newTab, downLoadTime ] = doIt( fileName, dstDir, inputFormat, idpos );
    end
end

function [ newTab, downLoadTime ] = doIt( fileName, dstDir, inputFormat, idpos )

    withDownLoad = 1;
    if( withDownLoad )
        % Datei 'RKI_COVID19.csv' (mit curl) herunterladen
        downLoadTime = downloadRKIData( fileName );
    else
        downLoadTime = Inf; %#ok<UNRCH>
    end

    % Datei 'RKI_COVID19.csv' lesen
    newTab = readRKIRawData( fileName, dstDir, inputFormat, idpos );

    % falls nötig Zuordnung der Landkreise zu den Bundesländern lesen
    staticRKIData( newTab )
end

function downLoadTime = downloadRKIData( fileName )
    % Daten des RKI mittels curl (https://github.com/curl/curl) downloaden
    % Beschreibung der Daten unter https://www.arcgis.com/home/item.html?id=f10774f1c63e40168479a1feb6c7ca74
    url = [ 'https://www.arcgis.com/sharing/rest/content/items/', ...
            'f10774f1c63e40168479a1feb6c7ca74/data' ];

    startTime = datetime( 'now' );
    download( url, fileName );
    downLoadTime = seconds( diff( [ startTime, datetime( 'now' ) ] ) );

    if( isfile( fileName ) == 0 )
        error( 'Fehler: Download der Fallzahlen fehlgeschlagen!' )
    end
end