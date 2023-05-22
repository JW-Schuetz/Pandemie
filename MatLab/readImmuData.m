function datenstand = readImmuData( infile, immuVersion )
    % Sheet 4 auswerten
    sheet4 = 4;
    names  = { 'Dat',  'Erst',  'Zweit', 'Gesamt' };
    types  = { 'char', 'int32', 'int32', 'int32'  };
    opts   = spreadsheetImportOptions( 'Sheet', sheet4, 'NumVariables', length( names ), ...
                'VariableNames', names, 'VariableTypes', types, 'DataRange', 'A2' );

	switch immuVersion
        case 0       % aktuell
            names  = { 'Dat',  'Erst',  'Zweit', 'Auffrisch', 'Gesamt' };
            types  = { 'char', 'int32', 'int32', 'int32', 'int32'  };
            opts   = spreadsheetImportOptions( 'Sheet', sheet4, 'NumVariables', length( names ), ...
                     'VariableNames', names, 'VariableTypes', types, 'DataRange', 'A2' );

        otherwise    % historisch
            names  = { 'Dat',  'Erst',  'Zweit', 'Gesamt' };
            types  = { 'char', 'int32', 'int32', 'int32'  };
            opts   = spreadsheetImportOptions( 'Sheet', sheet4, 'NumVariables', length( names ), ...
                     'VariableNames', names, 'VariableTypes', types, 'DataRange', 'A2' );
    end

    tabSheet3 = readtable( infile, opts );

    % alle Datensätze lesen
    dat    = tabSheet3{ :, 'Dat' }; 
    erst   = tabSheet3{ :, 'Erst' };
    zweit  = tabSheet3{ :, 'Zweit' };
    gesamt = tabSheet3{ :, 'Gesamt' };

    % Index der gültigen
    dat = datetime( dat );
	ndx = ~isnat( dat );

    % die gültigen Datensätze sind
    datum           = dat( ndx );
    erstimpfungen   = double( erst( ndx ) );
    zweitimpfungen  = double( zweit( ndx ) );
    gesamtimpfungen = double( gesamt( ndx ) );

    % Daten in MatLab-Datei schreiben
	save( 'ImpfStatistik.mat', 'datum', 'erstimpfungen', 'zweitimpfungen', 'gesamtimpfungen' )

    datenstand = datum( end );
end