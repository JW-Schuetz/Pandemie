function tab = readImmuData( infile, dstdir )
    % Sheet 1
    opts = spreadsheetImportOptions( 'Sheet', 1, 'NumVariables', 1, 'VariableNames', ...
            'Erläuterung', 'DataRange', 'A1', 'PreserveVariableNames', true );

    tabSheet1 = readtable( infile, opts );

    % Zeile 5 parsen, da steht das Datenstands-Datum drin
    txt             = tabSheet1{ 5, : };
	[ tok, remain ] = strtok( txt, '.' );

    tok    = tok{ 1 };
    remain = remain{ 1 };
    len    = length( tok );
    d      = tok( len - 1 : len );
    m      = remain( 2 : 3 );
    y      = remain( 5 : 6 );

    datenstand = datetime( [ d, '.', m, '.20', y ] );

    % Sheet 2
    names    = { 'Bundesland', 'Anzahl', 'Differenz', 'Pro100Tausend', 'AltersIndikation', ...
                 'BerufsIndikation', 'MedizinischeIndikation', 'Pflegeheimbewohner' };
    selected = { 'Bundesland', 'Anzahl', 'Pro100Tausend', 'AltersIndikation', ...
                 'BerufsIndikation', 'MedizinischeIndikation', 'Pflegeheimbewohner' };
    types    = { 'char', 'int32', 'int32', 'double', 'int32', 'int32', 'int32', 'int32' };
    opts     = spreadsheetImportOptions( 'Sheet', 2, 'NumVariables', 8, 'VariableNames', ...
                    names, 'SelectedVariableNames', selected, 'VariableTypes', types, ...
                    'DataRange', '2:17' );

    tabSheet2 = readtable( infile, opts );

    % Sheet 3
    names = { 'Datum', 'Anzahl' };
    types = { 'datetime', 'int32' };

    opts = spreadsheetImportOptions( 'Sheet', 3, 'NumVariables', 2, 'VariableNames', names, ...
            'VariableTypes', types, 'DataRange', 'A2' );

    tabSheet3 = readtable( infile, opts );

    % Datenstand separat ablegen
    tab = { tabSheet1, tabSheet2, tabSheet3, datenstand };

	tableName = 'immutab';

    % Speichern zur weiteren Verwendung
    fileName = [ tableName, '.mat' ];
    save( fileName, 'tab' )

    % Kopie speichern
    [ tok, remain ] = strtok( fileName, '.' );
    newName = [ dstdir, tok, '-', datestr( datenstand, 'dd.mm.yyyy' ), remain ];
    copyfile( fileName, newName );
end