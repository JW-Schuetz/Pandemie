clc
clear

load( 'rkiMap.mat', 'landkreisKeys', 'landkreisName', 'landkreisMeldungen', ...
      'landkreisZeitreihen', 'bundeslandName', 'bundeslandZeitreihen', ...
      'bundesrepublikZeitreihen', 'modus', 'stichTag', 'debugInfo' )

bund = bundesrepublikZeitreihen;
sum( bund.neuInfektionen )  % liefert 1494009 (richtig)

dirName = '';
load( [ dirName, 'table.mat' ], 'tab' )

datenstand = tab{ 2 };
tab        = tab{ 1 };

lk = 6437;

% Teil 1: Berechnung über 'rkiMap.mat' und landkreisMeldungen
lkMeldungen = landkreisMeldungen( lk );

startDate = datetime( '01.01.2020' );
datum     = generateDateArray( startDate, datenstand - 1 );
numDays   = length( datum );

neu = zeros( numDays, 1 );
an  = cell( numDays, 1 );
gn  = cell( numDays, 1 );
for d = 1 : numDays
    an( d ) = { zeros( 7, 1 ) };
    gn( d ) = { zeros( 2, 1 ) };
end

for m = 1 : size( lkMeldungen, 1 )
    lkm = lkMeldungen( m, : );              % aktuelle Meldung

	dat = lkm.Meldedatum;
    tag = daysdif( datum( 1 ), dat ) + 1;	% Index des Meldungstages

    if ismember( lkm.NeuerFall, [ 0, 1 ] )
        fallAnzahl = double( lkm.Fallanzahl );

        neu( tag ) = neu( tag ) + fallAnzahl;
        an{ tag }  = fillAgeBins( lkm.Altersgruppe, an{ tag }, fallAnzahl );
        gn{ tag }  = fillGenderBins( lkm.Geschlecht, gn{ tag }, fallAnzahl );
    end
end

datum( end )    % liefert 12-Dec-2021 (richtig)
sum( neu )      % liefert 7566 (richtig)
neu( end )      % liefert 14 (richtig)

sum( neu( end - 7 : end ) )  % liefert 373 (richtig)

mneu = meanFilter( neu( 1 : end ) );
mneu( end ) * 100000 / einwohnerKreis( lk )     % liefert 385.7171 (richtig)

% Teil 2: Berechnung über Tabelle
tab = tab( tab.LandkreisId == lk, : );

% FIDs Neuinfekte
neu       = tab.NeuerFall;
neuerfall = ( neu == 1 | neu == 0 );
tabNeu    = tab( neuerfall, : );

sum( tabNeu.Fallanzahl )    % Fallzahlen insgesamt, liefert 7566 (richtig)

neuerfall = neu == 1;
tabNeu    = tab( neuerfall, : );

sum( tabNeu.Fallanzahl )    % liefert 14 (richtig)

n = 1;