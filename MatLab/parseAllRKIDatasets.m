function parseAllRKIDatasets()
% Liest alle im Archiv vorhandenen "*.csv" (bzw. "*.zip") Dateien ein und erzeugt
% die entsprechende "*.mat" Datei "table-dd.MM.yyyy.mat", falls sie noch nicht
% existiert. Die Dateien werden in das Verzeichnis "Tabellen" geschrieben.
% Die entpackten "*.csv" Dateien werden wieder gelöscht.

    clc
    clear

    files      = {};
    todelete   = {};
	datum      = {};

    endDatum   = datetime( '21.10.2020' );  % ab 22.10.2020 habe ich eigene tab-Files
    patt       = 'RKI_COVID19_';
    lenPatt    = length( patt );
    srcDir     = 'D:\Projekte\CSV-Dateien-mit-Covid-19-Infektionen-';
    dstDir     = 'Tabellen\';

    d = dir( srcDir );
    for n = 1 : length( d )
        name = d( n ).name;
        if( d( n ).isdir && ( name( 1 ) ~= '.' ) )
            subdir = [ srcDir, '\', d( n ).name ];
            sd     = dir( subdir );

            for m = 1 : length( sd )
                if( ~sd( m ).isdir )
                    [ ~, remainder ] = strtok( sd( m ).name, '.' );
                    if( strcmp( remainder, '.csv' ) )
                        name    = [ subdir, '\', sd( m ).name ];

                        % Datumsanteil des Filenamens als String
                        loc     = strfind( name, patt );
                        loc     = loc + lenPatt;
                        dateStr = name( loc : end - 4 );

                        datum = [ datum; dateStr ]; %#ok<AGROW>
                        files = [ files; name ]; %#ok<AGROW>
                    end

                    if( strcmp( remainder, '.zip' ) )
                        zname = [ subdir, '\', sd( m ).name ];
                        token = strtok( zname, '.' );
                        name  = [ token, '.csv' ];

                        if( isfile( name ) ~= 1 )
                            unzip( zname, [ subdir, '\' ] )
                        end

                        % Datumsanteil des Filenamens als String
                        loc     = strfind( name, patt );
                        loc     = loc + lenPatt;
                        dateStr = name( loc : end - 4 );

                        datum    = [ datum; dateStr ]; %#ok<AGROW>
                        files    = [ files; name ]; %#ok<AGROW>
                        todelete = [ todelete; name ]; %#ok<AGROW>
                    end
                end
            end
        end
    end

    % nach Datum sortieren
    [ datum, ndx ] = sort( datum );
    files = files( ndx );

    len   = length( datum );
    idpos = zeros( len, 1 );
    inputFormat = cell( length( ndx ), 1 );
    for n = 1 : len
        inputFormat{ n } = 'yyyy/MM/dd HH:mm:ss';   % Defaut-Format
    end

    ndx = 1 : 14;	 idpos( ndx ) = 3; inputFormat( ndx ) = { 'yyyy-MM-dd' };
    ndx = 15;        idpos( ndx ) = 2; inputFormat( ndx ) = { 'dd/MM/yyyy' };
    ndx = 16;        idpos( ndx ) = 1; inputFormat( ndx ) = { 'MM/dd/yyyy' };
    ndx = 17;        idpos( ndx ) = 0; inputFormat( ndx ) = { 'dd.MM.yyyy' };
    ndx = 18 : 20;	 idpos( ndx ) = 1; inputFormat( ndx ) = { 'yyyy-MM-dd' };
    ndx = 21 : 22;	 idpos( ndx ) = 1; inputFormat( ndx ) = { 'MM/dd/yyyy' };
    ndx = 23 : 30;	 idpos( ndx ) = 1; inputFormat( ndx ) = { 'yyyy-MM-dd' };
    ndx = 31;        idpos( ndx ) = 0; inputFormat( ndx ) = { 'dd.MM.yyyy' };
    ndx = 32 : 33;	 idpos( ndx ) = 1; inputFormat( ndx ) = { 'yyyy-MM-dd' };
    ndx = 34 : 37;	 idpos( ndx ) = 0; inputFormat( ndx ) = { 'yyyy/MM/dd' };
    ndx = 38 : 39;   idpos( ndx ) = 1; inputFormat( ndx ) = { 'dd.MM.yyyy hh:mm:ss' };
    ndx = 40 : len;  idpos( ndx ) = 0; inputFormat( ndx ) = { 'yyyy/MM/dd' };

    for n = 1 : len
        % ab (endDatum + 1) sind eigene Datensätze vorhanden
        if( datum{ n } <= endDatum )
            files{ n }

            try
                tab = readRKIRawData( files{ n }, dstDir, 1, inputFormat{ n }, idpos( n ), 0 );
                if( tab{ 2 } ~= datetime( datum{ n } ) )
                    error( 'Datenstand: Datumsformat falsch' )
                end
            catch
                error( 'Crash in readRKIRawData(): n = %d', n )
            end
        end
    end

    % erzeugte Dateien wieder löschen
	len = length( todelete );
    for n = 1 : len
        delete( todelete{ n } )
    end
end