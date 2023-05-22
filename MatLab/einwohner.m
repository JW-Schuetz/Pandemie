function einwohner = einwohner()
	load( 'bundesland.mat', 'bundeslandKeys' )

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % laut RKI-Inzidenzen/Fallzahlen am 29.03.2022
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Baden-Württemberg:        11103036
    % Bayern:                   13140224
    % Berlin:                    3664037
    % Brandenburg:               2531107
    % Bremen:                     680138
    % Hamburg:                   1852507
    % Hessen:                    6293202
    % Mecklenburg-Vorpommern:    1610761
    % Niedersachsen:             8003512
    % Nordrhein-Westfalen:      17925312
    % Rheinland-Pfalz:           4098342
    % Saarland:                   984006
    % Sachsen:                   4056977
    % Sachsen-Anhalt:            2180672
    % Schleswig-Holstein:        2910834
    % Thüringen:                 2120237

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % laut Statistischem Bundesamt Stichtag 31.12.2020
    % https://www-genesis.destatis.de/genesis/online?operation=abruftabelleBearbeiten&levelindex=1&levelid=1648562442032&auswahloperation=abruftabelleAuspraegungAuswaehlen&auswahlverzeichnis=ordnungsstruktur&auswahlziel=werteabruf&code=12411-0010&auswahltext=&werteabruf=Werteabruf#abreadcrumb
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Baden-Württemberg:        11103043
    % Bayern:                   13140183
    % Berlin:                    3664088
    % Brandenburg:               2531071
    % Bremen:                     680130
    % Hamburg:                   1852478
    % Hessen:                    6293154
    % Mecklenburg-Vorpommern:    1610774
    % Niedersachsen:             8003421
    % Nordrhein-Westfalen:      17925570
    % Rheinland-Pfalz:           4098391
    % Saarland:                   983991
    % Sachsen:                   4056941
    % Sachsen-Anhalt:            2180684
    % Schleswig-Holstein:        2910875
    % Thüringen:                 2120237

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Ergebnisse der Funktion einwohner()
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Baden-Württemberg:        11103043
    % Bayern:                   13140183
    % Berlin:                    3769495	!!!
    % Brandenburg:               2531071
    % Bremen:                     680130  
    % Hamburg:                   1852478
    % Hessen:                    6293154
    % Mecklenburg-Vorpommern:	 1610774
    % Niedersachsen:             8003421
    % Nordrhein-Westfalen:      17925570 
    % Rheinland-Pfalz:           4098391
    % Saarland:                   983991
    % Sachsen:                   4056941
    % Sachsen-Anhalt:            2180684
    % Schleswig-Holstein:        2910875
    % Thüringen:                 2078267	!!!

    einwohner = 0;
    for n = 1 : length( bundeslandKeys )
        eLand     = einwohnerLand( bundeslandKeys( n ) );
        einwohner = einwohner + eLand;
    end
end