function einwohner = einwohnerLand( bundeslandId )
	load( 'bundesland.mat', 'bundeslandKeys', 'bundeslandLK', 'bundeslandName' )

    % ist key vorhanden?
    if( ~isempty( ismember( bundeslandId, bundeslandKeys ) ) )
        lkKeys = bundeslandLK( bundeslandId );

        einwohner = 0;
        for n = 1 : length( lkKeys )
            einwohner = einwohner + einwohnerKreis( lkKeys( n ) );
        end
    else
        name = bundeslandName( bundeslandId );
        error( 'Bundesland %d - %s fehlt', bundeslandId, name{ 1 } );
    end
end