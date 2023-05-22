function tab = readRKIRawData( infile, dstdir, inputFormat, idpos )
% dstdir:       Zielverzeichnis
% inputFormat:  ZeitFormat
% idpos:        Position der Meldungs-Ids (0 aktuell, ~0 historisch, 4 mit Hash)

    % Meldedatum: Datum, wann der Fall dem Gesundheitsamt bekannt geworden ist (also der positive Test)
    % Datenstand: Datum, wann der Datensatz zuletzt aktualisiert worden ist
    % Referenzdatum: Erkrankungsdatum bzw. wenn das nicht bekannt ist, das Meldedatum
    % IstErkrankungsbeginn: 1, wenn das Refdatum der Erkrankungsbeginn ist, 0 sonst

	% Spalten-Namen und Spalten-Typen
	namesPos0 = { 'ObjectId', 'BundeslandId', 'Bundesland', 'Landkreis', 'Altersgruppe', ...
                  'Geschlecht', 'Fallanzahl', 'TodesfallAnzahl', 'Meldedatum', ...
                  'LandkreisId', 'Datenstand', 'NeuerFall', 'NeuerTodesfall', ...
                  'Referenzdatum', 'NeuGenesen', 'GenesenAnzahl', 'IstErkrankungsbeginn', ...
                  'Altersgruppe2' ...
                };
	typesPos0 = { 'uint32', 'int8', 'char', 'char', 'categorical', ...
                  'categorical', 'uint32', 'uint32', 'datetime', ...
                  'int16', 'char', 'int8', 'int8', ...
                  'datetime', 'logical', 'uint32', 'logical', ...
                  'categorical' ...
                };
    selected0 = { 'BundeslandId', 'Bundesland', 'Landkreis', 'Altersgruppe', 'Geschlecht', ...
                  'Fallanzahl', 'TodesfallAnzahl', 'Meldedatum', 'LandkreisId', 'Datenstand', ...
                  'NeuerFall', 'NeuerTodesfall', 'Referenzdatum', ...
                };
	namesPos1 = { 'BundeslandId', 'Bundesland', 'Landkreis', 'Altersgruppe', ...
                  'Geschlecht', 'Fallanzahl', 'TodesfallAnzahl', 'FID', 'Meldedatum', ...
                  'LandkreisId', 'Datenstand', 'NeuerFall', 'NeuerTodesfall', ...
                  'Referenzdatum', 'NeuGenesen', 'GenesenAnzahl' ...
                };
	typesPos1 = { 'int8', 'char', 'char', 'categorical', ...
                  'categorical', 'uint32', 'uint32', 'uint32', 'datetime', ...
                  'int16', 'char', 'int8', 'int8', ...
                  'datetime', 'logical', 'uint32' ...
                };
	namesPos2 = { 'ID', 'BundeslandId', 'Bundesland', 'Landkreis', 'Altersgruppe', ...
                  'Geschlecht', 'Fallanzahl', 'TodesfallAnzahl', 'ObjectId', 'Meldedatum', ...
                  'LandkreisId', 'Datenstand', 'NeuerFall', 'NeuerTodesfall', ...
                  'Referenzdatum', 'NeuGenesen', 'GenesenAnzahl' ...
                };
	typesPos2 = { 'uint32', 'int8', 'char', 'char', 'categorical', ...
                  'categorical', 'uint32', 'uint32', 'uint32', 'datetime', ...
                  'int16', 'char', 'int8', 'int8', ...
                  'datetime', 'logical', 'uint32' ...
                };
	namesPos3 = { 'BundeslandId', 'Bundesland', 'Landkreis', 'Altersgruppe', ...
                  'Geschlecht', 'Fallanzahl', 'TodesfallAnzahl', 'FID', 'Meldedatum', ...
                  'LandkreisId', 'Datenstand', 'NeuerFall', 'NeuerTodesfall'
                };
	typesPos3 = { 'int8', 'char', 'char', 'categorical', ...
                  'categorical', 'uint32', 'uint32', 'uint32', 'datetime', ...
                  'int16', 'char', 'int8', 'int8'
                };
    selected3 = { 'BundeslandId', 'Bundesland', 'Landkreis', 'Altersgruppe', 'Geschlecht', ...
                  'Fallanzahl', 'TodesfallAnzahl', 'Meldedatum', 'LandkreisId', 'Datenstand', ...
                  'NeuerFall', 'NeuerTodesfall' ...
                };
	namesPos4 = { 'Hash', 'BundeslandId', 'Bundesland', 'Landkreis', 'Altersgruppe', ...
                  'Geschlecht', 'Fallanzahl', 'TodesfallAnzahl', 'Meldedatum', ...
                  'LandkreisId', 'Datenstand', 'NeuerFall', 'NeuerTodesfall', ...
                  'Referenzdatum', 'NeuGenesen', 'GenesenAnzahl', 'IstErkrankungsbeginn', ...
                  'Altersgruppe2' ...
                };
	typesPos4 = { 'char', 'int8', 'char', 'char', 'categorical', ...
                  'categorical', 'uint32', 'uint32', 'datetime', ...
                  'int16', 'char', 'int8', 'int8', ...
                  'datetime', 'logical', 'uint32', 'logical', ...
                  'categorical' ...
                };
    selected4 = { 'BundeslandId', 'Bundesland', 'Landkreis', 'Altersgruppe', 'Geschlecht', ...
                  'Fallanzahl', 'TodesfallAnzahl', 'Meldedatum', 'LandkreisId', ...
                  'NeuerFall', 'NeuerTodesfall' ...
                };

    switch idpos
        case 0
                names      = namesPos0;
                types      = typesPos0;
                selected   = selected0;
                optsFormat = { 'Meldedatum', 'Referenzdatum' };

        case 1
                names      = namesPos1;
                types      = typesPos1;
                selected   = selected0;
                optsFormat = { 'Meldedatum', 'Referenzdatum' };

        case 2
                names      = namesPos2;
                types      = typesPos2;
                selected   = selected0;
                optsFormat = { 'Meldedatum', 'Referenzdatum' };

        case 3
                names      = namesPos3;
                types      = typesPos3;
                selected   = selected3;
                optsFormat = 'Meldedatum';

        case 4
                names      = namesPos4;
                types      = typesPos4;
                selected   = selected4;
                optsFormat = 'Meldedatum';

        otherwise
            error( 'idpos unbekannt' )
    end

    opts = delimitedTextImportOptions( 'Delimiter', ',', 'DataLines', 2, ...
            'VariableNames', names, 'SelectedVariableNames', selected, 'VariableTypes', ...
            types, 'Encoding', 'UTF-8' );
    opts = setvaropts( opts, optsFormat, 'InputFormat', inputFormat );
    opts = setvaropts( opts, optsFormat, 'DatetimeFormat', 'dd.MM.yyyy' );
    opts = setvaropts( opts, { 'Altersgruppe', 'Geschlecht' }, 'Ordinal', true );

    % Workaround für den Fall, dass die csv nicht mehr vorhanden ist aber
    % die Kopie der tab-Datei bereits erzeugt wourde
    workAround = false;
    if( workAround )
        tab = load( 'D:\Projekte\Pandemie\Tabellen\table-26.04.2022.mat' ); %#ok<UNRCH>
        tab = tab.tab;
        return
    else
        tab = readtable( infile, opts );
        % Datenstand extrahieren zur weiteren Verwendung
        datenstand  = tab.Datenstand;
        uDatenstand = unique( datenstand );
        if( size( uDatenstand, 1 ) ~= 1 )
            error( 'Fehler: Datenstand ist innerhalb des Datensatzes nicht einheitlich' )
        end
    end

	datenstand = datetime( strtok( uDatenstand{ 1 }, 'U' ), 'InputFormat', ...
                           'dd.MM.yyyy, hh:mm' );

    % Datenstand wird in der Tabelle nicht mehr benötigt, ebenso die beiden
    % Variablen 
    tab.Datenstand = [];

    % Datenstand separat ablegen
    tab = { tab, datenstand };

    % Speichern
    saveLastTable( tab, dstdir, datenstand )

    home; sprintf( 'readRKIRawData(): fertig' )
end

function saveLastTable( tab, dstdir, datenstand )
    % Speichern zur weiteren Verwendung
    fileName = 'LastTable.mat';

    save( fileName, 'tab' )

    % Kopie speichern
    newName = [ dstdir, 'table', '-', datestr( datenstand, 'dd.mm.yyyy' ), '.mat' ];
    copyfile( fileName, newName );
end