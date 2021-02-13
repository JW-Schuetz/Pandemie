function einwohner = einwohner()
	load( 'bundesland.mat', 'bundeslandKeys' )

    einwohner = 0;
    for n = 1 : length( bundeslandKeys )
        einwohner = einwohner + einwohnerLand( bundeslandKeys( n ) );
    end
end