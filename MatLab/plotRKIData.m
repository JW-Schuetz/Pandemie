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

    % Eingangsdaten
    inputFileName = 'rkiMap.mat';

    % Zielordner für die erzeugten Dateien (im Fall saveData=true)
    outputDirPrefix = 'D:\VBSharedFolder\Debian\Pandemie\';

    % Auswerteparameter
    withTestanzahl = false;     % nur Anzahl der Tests plotten
    withAge80Plus  = false;     % Plot separate Altersklasse 80+
    saveData       = true;      % erzeugte Grafiken/Statistik speichern

    % Auswertegebiet Bundesland, Hessen=6
    bundesLandId = 6;

	% Darmstadt=6411, Frankfurt=6412, Gross-Gerau=6433, Odenwaldkreis=6437, Landkreis Offenbach=6438
    kreisId = [ 6437, 6411, 6412, 6433, 6438 ];

    for k = 1 : length( kreisId )
        kreisId( k )

        doItAll( inputFileName, outputDirPrefix, withTestanzahl, withAge80Plus, saveData, ...
                 kreisId( k ), bundesLandId, events )

        % Anzahl der Tests ist kreisinvariant
        if( withTestanzahl )
            break
        end
    end
end