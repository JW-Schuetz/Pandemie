function findBestWorstMortality()
    clc
    clear

    % Datenbasis einlesen
	load( 'rkiMap.mat', 'datum', 'landkreisKeys', 'landkreisName', ...
          'landkreisZeitreihen', 'bundeslandName', 'bundeslandZeitreihen', ...
          'bundesrepublikZeitreihen' )
	load( 'bundesland.mat', 'bundeslandKeys' )

    % Untersuchungszeitraum auswählen
    auswertungStart = datetime( '01.04.2020' );
    ndxStart        = find( auswertungStart == datum );
    auswertungEnd   = datetime( '01.10.2021' );
    ndxEnd          = find( auswertungEnd == datum );
    normToBeUsed    = 1;    % Ende der Zeitreihe=0, Maximum der Zeitreihe=1

	% Bundesrepublik bestimmen
    perfBR = calcDeathChanceBR( bundesrepublikZeitreihen, ...
        ndxStart, ndxEnd );
	sprintf( '%s\t\t%2.1f', 'Bundesrepublik:', perfBR )

    % Ranking der Bundesländer bestimmen (die besten vorne, die schlechtesten hinten)
    perfBL = calculateRanking( bundeslandKeys, bundeslandZeitreihen, ...
        ndxStart, ndxEnd, normToBeUsed );

    len       = length( perfBL );
    bestTwo1  = cell2mat( perfBL( 1 : 2, 1 ) );
    bestTwo2  = cell2mat( perfBL( 1 : 2, 2 ) );
    worstTwo1 = cell2mat( perfBL( len - 1 : len, 1 ) );
    worstTwo2 = cell2mat( perfBL( len - 1 : len, 2 ) );

    s   = 'Die besten zwei Bundesländer:';
    len = length( bestTwo1 );
    for n = 1 : len
        lkName = bundeslandName( bestTwo1( n ) );
        s = [ s, sprintf( '\r%d\t - %s\t\t%2.1f', bestTwo1( n ), ...
              lkName{ 1 }, bestTwo2( n ) ) ]; %#ok<AGROW>
    end

    s   = [ s, sprintf( '\r\rDie schlechtesten zwei Bundesländer:' ) ];
    len = length( worstTwo1 );
    for n = 1 : len
        lkName = bundeslandName( worstTwo1( n ) );
        s = [ s, sprintf( '\r%d\t - %s\t\t%2.1f', worstTwo1( n ), ...
              lkName{ 1 }, worstTwo2( n ) ) ]; %#ok<AGROW>
    end

    sprintf( s )

    % Ranking der LK bestimmen (die besten vorne, die schlechtesten hinten)
    perfLK = calculateRanking( landkreisKeys, landkreisZeitreihen, ...
        ndxStart, ndxEnd, normToBeUsed );

    % Odenwaldkreis
    lkIdOdenwald = 6437;
    ndx          =  cell2mat( perfLK( :, 1 ) ) == lkIdOdenwald ;
    sprintf( '\rOdenwaldkreis: %2.1f\r', cell2mat( perfLK( ndx, 2 ) ) )

    len        = length( perfLK );
    bestFive1  = cell2mat( perfLK( 1 : 5, 1 ) );
    bestFive2  = cell2mat( perfLK( 1 : 5, 2 ) );
    worstFive1 = cell2mat( perfLK( len - 4 : len, 1 ) );
    worstFive2 = cell2mat( perfLK( len - 4 : len, 2 ) );

    s   = 'Die besten fünf Kreise:';
    len = length( bestFive1 );
    for n = 1 : len
        lkName = landkreisName( bestFive1( n ) );
        s = [ s, sprintf( '\r%d\t - %s\t\t%2.1f', bestFive1( n ), ...
              lkName{ 1 }, bestFive2( n ) ) ]; %#ok<AGROW>
    end

    s   = [ s, sprintf( '\r\rDie schlechtesten fünf Kreise:' ) ];
    len = length( worstFive1 );
    for n = 1 : len
        lkName = landkreisName( worstFive1( n ) );
        s = [ s, sprintf( '\r%d\t - %s\t\t%2.1f', worstFive1( n ), ...
              lkName{ 1 }, worstFive2( n ) ) ]; %#ok<AGROW>
    end

    sprintf( s )
end

%##########################################################################
%#  Mit Maximumsnorm im Zeitraum vom 01.07.2020 - 01.07.2021 ermittelt    #
%##########################################################################
%      Bundesrepublik:		15.7

%      Die besten zwei Bundesländer (absteigend): 
%      13	 - Mecklenburg-Vorpommern		10.6
%      11	 - Berlin                       12.0

%      Die schlechtesten zwei Bundesländer (absteigend): 
%      9	 - Bayern		17.3
%      2	 - Hamburg		18.1

%      Odenwaldkreis: 31.3

%      Die besten fünf Kreise (absteigend): 
%      7232	 - LK Bitburg-Prüm		4.8
%      7320	 - SK Zweibrücken		5.3
%      8436	 - LK Ravensburg		6.5
%      9764	 - SK Memmingen         6.5
%      10042 - LK Merzig-Wadern		7.6

%      Die schlechtesten fünf Kreise (absteigend): 
%      9662	 - SK Schweinfurt		28.8
%      9461	 - SK Bamberg           30.3
%      12072 - LK Teltow-Fläming	30.4
%      3103	 - SK Wolfsburg         31.1
%      6437	 - LK Odenwaldkreis		31.3
%##########################################################################

%##########################################################################
%#  Mit Endnorm im Zeitraum vom 01.07.2020 - 01.07.2021 ermittelt         #
%##########################################################################
%      Bundesrepublik:		10.6
% 
%      Die besten zwei Bundesländer:
%      13	 - Mecklenburg-Vorpommern		9.0
%      10	 - Saarland		9.4
%      
%      Die schlechtesten zwei Bundesländer:
%      2	 - Hamburg		11.6
%      6	 - Hessen		11.8
% 
%      Odenwaldkreis: 14.8
% 
%      Die besten fünf Kreise:
%      7232	 - LK Bitburg-Prüm                  4.7
%      7320	 - SK Zweibrücken                   4.8
%      9764	 - SK Memmingen                     4.8
%      7131	 - LK Ahrweiler                     5.5
%      13071 - LK Mecklenburgische Seenplatte	5.5
%      
%      Die schlechtesten fünf Kreise:
%      1062	 - LK Stormarn          15.9
%      12053 - SK Frankfurt (Oder)	16.1
%      3153	 - LK Goslar            16.2
%      3360	 - LK Uelzen            17.9
%      9565	 - SK Schwabach         19.4
%##########################################################################