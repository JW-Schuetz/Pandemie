function plotRKIData()
    clc
    clear

	events = { ...
        { 'Veranstaltungsverbot', datetime( '09.03.2020' ) };
        { 'Kontaktverbot',        datetime( '23.03.2020' ) };
%       { 'Toennies-Ausbruch',    datetime( '17.06.2020' ) };
        { 'Grenzöffnungen',       datetime( '21.06.2020' ) };
        { 'Lockdown (Soft)',      datetime( '01.11.2020' ) };
        { 'Lockdown (Hard)',      datetime( '16.12.2020' ) }
	};

    % Auswerteparameter
    auto           = 0;
    withTestanzahl = 0;     % nur Anzahl der Tests plotten
    withAge80Plus  = 0;     % Plot separate Altersklasse 80+
    saveData       = 1;     % erzeugte Grafiken/Statistik speichern

    % Eingangsdaten
    inputFileName = 'rkiMap.mat';

    % Zielordner für die erzeugten Dateien (im Fall saveData=true)
    if( auto )
        outputDirPrefix = 'D:\Projekte\Pandemie\LyX\'; %#ok<UNRCH>
        kreisName       = { 'Odenwald', 'Darmstadt', 'Frankfurt', 'Gross-Gerau', 'LK Offenbach' };
    else
        outputDirPrefix = 'D:\VBSharedFolder\Debian\Pandemie\';
    end

    % Auswertegebiet Bundesland, Hessen=6
    bundesLandId = 6;

	% Odenwaldkreis=6437, Darmstadt=6411, Frankfurt=6412, Gross-Gerau=6433, LK Offenbach=6438
    kreisId = [ 6437, 6411, 6412, 6433, 6438 ];

    if( withTestanzahl )
        % Anzahl der Tests ist kreisinvariant
        doItAll( inputFileName, outputDirPrefix, withTestanzahl, withAge80Plus, saveData, ...
                 kreisId( 1 ), bundesLandId, events ) %#ok<UNRCH>
        withTestanzahl = 0;
    end

    for k = 1 : length( kreisId )
        doItAll( inputFileName, outputDirPrefix, withTestanzahl, withAge80Plus, saveData, ...
                 kreisId( k ), bundesLandId, events )

        if( auto )
            % Grafiken in PDF wandeln
            cmd   = '"C:/Program Files (x86)/LyX 2.3/bin/LyX.exe"'; %#ok<UNRCH>
            kreis = sprintf( '%s', kreisName{ k } );
            name  = sprintf( 'Aktuelle-Zahlen-%s', kreis );
            state = system( sprintf( '%s -E %s.pdf %s.lyx', cmd, name, name ) );
            if( state )
                error( 'Kommando scheiterte!' )
            end
        end
    end
end