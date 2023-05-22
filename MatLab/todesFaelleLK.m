function tab = todesFaelleLK( landkreisId )
% Todesfälle der letzten 7 Tage

    load( 'table.mat', 'tab' )

    tab = tab{ 1 };

    tab       = tab( tab.LandkreisId == landkreisId, : );
    tot       = tab.NeuerTodesfall;
    todesfall = or( tot == 0, tot == 1 );
    tab       = tab( todesfall, : );

    % -6 meint die letzten 7 Tage: -6, -5, -4, -3, -2, -1, 0
    ndx	= days( tab.Meldedatum - datetime( 'yesterday' ) ) >= -6;
    tab	= tab( ndx, : );

    % sortieren nach Meldedatum
    [ ~, ndx ] = sort( tab.Meldedatum );
    tab        = tab( ndx, : );
end