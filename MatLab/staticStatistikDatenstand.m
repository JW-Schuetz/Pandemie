function [ datum, neu, tot ] = staticStatistikDatenstand()
    % Hier werden die mir in den csv-Datensätzen fehlenden Tage bereitgestellt.
    % Nur die täglichen Neuinfektionen und die täglichen Todesfälle, deutschlandweit.

    % zwei Zeitfenster fehlen:
    datum1 = generateDateArray( datetime( '03.03.2020' ), datetime( '26.03.2020' ) );
    datum2 = generateDateArray( datetime( '04.04.2020' ), datetime( '05.04.2020' ) );

    n = 1;
    neu1( n ) = 0;      tot1( n ) = 0;   n = n + 1;     % 03.03.2020
    neu1( n ) = 262;	tot1( n ) = 0;   n = n + 1;
    neu1( n ) = 400;	tot1( n ) = 0;   n = n + 1;
    neu1( n ) = 639;	tot1( n ) = 0;   n = n + 1;
    neu1( n ) = 795;	tot1( n ) = 0;   n = n + 1;
    neu1( n ) = 902;	tot1( n ) = 0;   n = n + 1;
    neu1( n ) = 1139;	tot1( n ) = 2;   n = n + 1;
    neu1( n ) = 1296;	tot1( n ) = 2;   n = n + 1;
    neu1( n ) = 1567;	tot1( n ) = 3;   n = n + 1;
    neu1( n ) = 2369;	tot1( n ) = 5;   n = n + 1;
    neu1( n ) = 3062;	tot1( n ) = 5;   n = n + 1;
    neu1( n ) = 3795;	tot1( n ) = 8;   n = n + 1;
    neu1( n ) = 4838;	tot1( n ) = 12;  n = n + 1;
    neu1( n ) = 6012;	tot1( n ) = 12;  n = n + 1;
    neu1( n ) = 7156;	tot1( n ) = 12;  n = n + 1;
    neu1( n ) = 8198;	tot1( n ) = 12;  n = n + 1;
    neu1( n ) = 10999;	tot1( n ) = 20;  n = n + 1;
    neu1( n ) = 13957;	tot1( n ) = 31;  n = n + 1;
    neu1( n ) = 16662;	tot1( n ) = 47;  n = n + 1;
    neu1( n ) = 18610;	tot1( n ) = 55;  n = n + 1;
    neu1( n ) = 22672;	tot1( n ) = 86;  n = n + 1;
    neu1( n ) = 27436;	tot1( n ) = 114; n = n + 1;
    neu1( n ) = 31554;	tot1( n ) = 149; n = n + 1;
    neu1( n ) = 36508;	tot1( n ) = 198;                % 26.03.2020

    n = 1;
    neu2( n ) = 85778;	tot2( n ) = 1158; n = n + 1;	% 04.04.2020
    neu2( n ) = 91714;	tot2( n ) = 1342;               % 05.04.2020

    % Zeitbereich 1
    len1 = length( datum1 ) - 1;
    neu  = zeros( len1, 1 );
    tot  = zeros( len1, 1 );

    for n = 2 : len1 + 1
        neu( n - 1 ) = neu1( n ) - neu1( n - 1 );
        tot( n - 1 ) = tot1( n ) - tot1( n - 1 );
    end

    % Zeitbereich 2
    len2 = length( datum2 ) - 1;
    neu  = [ neu; zeros( len2, 1 ) ];
    tot  = [ tot; zeros( len2, 1 ) ];

    for n = 2 : len2 + 1
        neu( len1 + n - 1 ) = neu2( n ) - neu2( n - 1 );
        tot( len1 + n - 1 ) = tot2( n ) - tot2( n - 1 );
    end

    % Datum Mergen
	datum = [ datum1( 2 : end ); datum2( 2 : end ) ];
end