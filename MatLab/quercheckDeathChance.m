% Quercheck: Berechnung über Tabelle

clc
clear

load( 'table.mat', 'tab' )

datenstand = tab{ 2 };
tab        = tab{ 1 };

lkId            = 6437;
auswertungStart = datetime( '01.07.2020' );
auswertungEnd   = datetime( '01.10.2021' );

ndx = ( tab.LandkreisId == lkId );
tab = tab( ndx, : );    % Landkreis lkId

% neue Infektionen Landkreis
ndx    = ( tab.NeuerFall == 1 | tab.NeuerFall == 0 );
tabNeu = tab( ndx, : ); % neue Infektionen

ndx    = ( tabNeu.Meldedatum >= auswertungStart ) & ...
         ( tabNeu.Meldedatum <= auswertungEnd );
tabNeu = tabNeu( ndx, : );  % im Untersuchungszeitraum

ndx    = ( tabNeu.Altersgruppe == 'A60-A79' ) | ( tabNeu.Altersgruppe == 'A80+' );
tabNeu = tabNeu( ndx, : );  % innerhalb der Altersgruppe

neue   = sum( tabNeu.Fallanzahl );

% neue Todesfälle Landkreis
ndx    = ( tab.NeuerTodesfall == 1 | tab.NeuerTodesfall == 0 );
tabTot = tab( ndx, : ); % neuer Todesfall

ndx    = ( tabTot.Meldedatum >= auswertungStart ) & ...
         ( tabTot.Meldedatum <= auswertungEnd );
tabTot = tabTot( ndx, : );  % im Untersuchungszeitraum

ndx    = ( tabTot.Altersgruppe == 'A60-A79' ) | ( tabTot.Altersgruppe == 'A80+' );
tabTot = tabTot( ndx, : );  % innerhalb der Altersgruppe

tote   = sum( tabTot.Fallanzahl );

format1 = '\nLandkreis:\t\t\t%d \nTodesfälle:\t\t%d\nNeuinfektionen:';
format2 = '\t%d\nTodesquote:\t\t%2.1f %%\n';
sprintf( [ format1, format2 ], lkId, tote, neue, tote / neue * 100 )