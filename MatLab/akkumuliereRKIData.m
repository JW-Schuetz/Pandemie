function akkumuliereRKIData( tab, datum, modus, stichTag, fileName, debug )
    % modus=0: Meldedatum, modus=1: Referenzdatum

	load( 'bundesland.mat', 'landkreisKeys', 'landkreisName', 'bundeslandKeys', ...
          'bundeslandName', 'bundeslandLK' )

    % Meldungen jedes Landkreises nach Zeit sortiert in Map ablegen
    landkreisMeldungen = akkumuliereLandkreisMeldungen( tab, landkreisKeys );

    % Landkreise: Meldungen auswerten, Daten (Anzahl Infekt, Tot, Altersklassen) akkumulieren
    [ landkreisZeitreihen, debugInfo ] = processLandkreisMeldungen( datum, landkreisKeys, ...
        landkreisMeldungen, modus, debug );

    % Bundesländer: Daten der Lankreise des Bundeslandes akkumulieren
    bundeslandZeitreihen = processBundeslandDaten( datum, landkreisZeitreihen, bundeslandLK, ...
        bundeslandKeys );

	% Bundesrepublik: Daten der Bundesländer akkumulieren
	bundesrepublikZeitreihen = processBundesrepublikDaten( datum, bundeslandZeitreihen, ...
        bundeslandKeys );

    % Debugging: Ausgabe-Dateinamen anpassen
    if( debug )
        [ token, remain ] = strtok( fileName, '.' );
        fileName = [ token, 'Debug', remain ];
    end

    % Daten der Bundesländer und der Bundesrepublik speichern
	save( fileName, 'datum', 'landkreisKeys', 'landkreisName', 'landkreisMeldungen', ...
          'landkreisZeitreihen', 'bundeslandName', 'bundeslandZeitreihen', ...
          'bundesrepublikZeitreihen', 'modus', 'stichTag', 'debugInfo' )

    home; sprintf( 'akkumuliereRKIData(): fertig' )
end