function plotRKIData()
    clc
    clear

	events = { ...
        { 'Veranstaltungsverbot',   datetime( '09.03.2020' ) };
        { 'Kontaktverbot',          datetime( '23.03.2020' ) };
%       { 'Toennies-Ausbruch',      datetime( '17.06.2020' ) };
        { 'Grenzöffnungen',         datetime( '21.06.2020' ) };
        { 'Lockdown (Soft)',        datetime( '01.11.2020' ) };
        { 'Lockdown (Hard)',        datetime( '16.12.2020' ) };
        { '1. Lockerung Schulen',   datetime( '22.02.2021' ) }
	};

    % Auswerteparameter
    auto           = 1;     % automatische Konversion in PDF-Dateien (mit LyX)
    withTestanzahl = 0;     % nur Anzahl der Tests plotten
    withAge80Plus  = 0;     % Plot separate Altersklasse 80+
    saveData       = 1;     % erzeugte Grafiken/Statistik speichern

    % Eingangsdaten
    inputFileName = 'rkiMap.mat';

    % Zielordner für die erzeugten Dateien (im Fall saveData=true)
    if( auto )
        outputDirPrefix = 'D:\Projekte\Pandemie\LyX\';
        kreisName       = { 'Odenwald', 'Darmstadt', 'Frankfurt', 'Gross-Gerau', 'LK-Offenbach' };
    else
        outputDirPrefix = 'D:\VBSharedFolder\Debian\Pandemie\'; %#ok<UNRCH>
    end

    % Auswertegebiet Bundesland, Hessen=6
    bundesLandId = 6;

	% Odenwaldkreis=6437, Darmstadt=6411, Frankfurt=6412, Gross-Gerau=6433, LK Offenbach=6438
    kreisId = [ 6437, 6411, 6412, 6433, 6438 ];

    if( withTestanzahl )
        % Anzahl der Tests ist kreisinvariant
        doItAll( inputFileName, outputDirPrefix, withTestanzahl, withAge80Plus, saveData, ...
                 kreisId, 1, bundesLandId, events ) %#ok<UNRCH>

        withTestanzahl = 0;
    end

    for k = 1 : length( kreisId )
        doItAll( inputFileName, outputDirPrefix, withTestanzahl, ...
                 withAge80Plus, saveData, kreisId, k, bundesLandId, events )

        if( auto )
            % Grafiken in PDF wandeln
            exe   = 'D:/Projekte/LyX/build-2.4.x/LYX_INSTALLED/bin/LyX.exe';
            kreis = sprintf( '%s', kreisName{ k } );
            name  = sprintf( 'Aktuelle-Zahlen-%s', kreis );

            cmd = sprintf( '%s -e pdf2 ../LyX/%s.lyx', exe, name );
            [ state, msg ] = system( cmd );
            if( state )
                error( 'Kommando \"%s\" scheiterte mit der Meldung: \"%s\"', ...
                       cmd, msg )
            end

            cmd = sprintf( 'move /Y ../LyX/%s.pdf ..', name );
            [ state, msg ] = system( cmd );
            if( state )
                error( 'Kommando \"%s\" scheiterte mit der Meldung: \"%s\"', ...
                       cmd, msg )
            end
        end
    end
end