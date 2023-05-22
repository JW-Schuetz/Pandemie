function generateImmuData( fileName, dstDir, immuVersion )
	[ ~, extention ] = strtok( fileName, '.' );
	name = [ dstDir, 'Impfquoten', '-', datestr( datetime( 'yesterday' ), ...
                'dd.mm.yyyy' ), extention ];

    % existiert das gestrige File bereits?
    if( ~isfile( name ) )
        downloadImmuData( fileName )

        datenstand = readImmuData( fileName, immuVersion );

        % Heruntergaladenes File umbenennen
        newName = [ dstDir, 'Impfquoten', '-', datestr( datenstand, ...
                        'dd.mm.yyyy' ), extention ];
        movefile( fileName, newName );
    end
end

function downloadImmuData( infile )
    % Daten des RKI mittels curl (https://github.com/curl/curl) downloaden
    % Beschreibung der Daten unter https://www.arcgis.com/home/item.html?id=f10774f1c63e40168479a1feb6c7ca74
    url = [ 'https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/', ...
            'Impfquotenmonitoring.xlsx?__blob=publicationFile' ];

    download( url, infile );

    if( isfile( infile ) == 0 )
        error( 'Fehler: Download der Impfquoten fehlgeschlagen!' )
    end
end