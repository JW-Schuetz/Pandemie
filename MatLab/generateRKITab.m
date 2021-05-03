function newTab = generateRKITab( fileName, dstDir, version, idpos, inputFormat )
    tab    = {};
	newTab = {};

    % Entscheidung: müssen neue RKI-Daten heruntergeladen werden?
    try
        load( 'table.mat', 'tab' )  % evtl. schon vorhandene Tabelle lesen

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
                 newTab = doIt( tab, fileName, dstDir, version, inputFormat, idpos, false );
            end
        end
    catch
        % "table.mat" ist nicht vorhanden oder kann nicht gelesen werden
        newTab = doIt( tab, fileName, dstDir, version, inputFormat, idpos, false );
    end
end

function newTab = doIt( tab, fileName, dstDir, version, inputFormat, idpos, debug )
    % Datei 'RKI_COVID19.csv' (mit curl) herunterladen
    downloadRKIData( fileName )

    switch idpos
        case 4
            % Assembly meines Präprozessors laden
            NET.addAssembly( 'D:\Projekte\Pandemie\DotNet\PreProcess\bin\Release\PreProcess.dll' );

            % Klasse RKI konstruieren
            rki = RKI.RKIPreProcess(fileName);
            % csv-Datei mit Hash versehen -> RKI_COVID19_Hashed.csv
            datenstand = rki.PreProcessFile;
            % "Hashed" csv-Dateinamen holen
            fileName = rki.HashedName;

        otherwise
            datenstand = '';
    end

    % Datei 'RKI_COVID19.csv' lesen
    newTab = readRKIRawData( fileName, dstDir, version, inputFormat, ...
                idpos, debug, datenstand );

    % sind neue Datensätze vorhanden?
    if( ~isempty( tab ) )
        if( size( newTab{ 1 }, 1 ) <= size( tab{ 1 }, 1 ) )
            error( [ 'Fehler: die neuen RKI-Daten enthalten nicht mehr Datensätze ' ...
                     'als die alten RKI-Daten!' ] )
        end
    end

    % falls nötig Zuordnung der Landkreise zu den Bundesländern lesen
    staticRKIData( newTab )
end

function downloadRKIData( infile )
    % Daten des RKI mittels curl (https://github.com/curl/curl) downloaden
    % Beschreibung der Daten unter https://www.arcgis.com/home/item.html?id=f10774f1c63e40168479a1feb6c7ca74
    url = [ 'https://www.arcgis.com/sharing/rest/content/items/', ...
            'f10774f1c63e40168479a1feb6c7ca74/data' ];
    download( url, infile );

    if( isfile( infile ) == 0 )
        error( 'Fehler: Download der Fallzahlen fehlgeschlagen!' )
    end
end