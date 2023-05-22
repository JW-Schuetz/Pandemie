function [ kind, erwachsen, alt ] = calcAltersklassen( ages )
    len = length( ages );

	kind      = zeros( len, 1 );
	erwachsen = zeros( len, 1 );
    alt       = zeros( len, 1 );

    for n = 1 : len
        kind( n )      = ages{ n }( 1 ) + ages{ n }( 2 );	% 'A00-A04' + 'A05-A14'
        erwachsen( n ) = ages{ n }( 3 ) + ages{ n }( 4 );   % 'A15-A34' + 'A35-A59'
        alt( n )       = ages{ n }( 5 ) + ages{ n }( 6 );   % 'A60-A79' + 'A80+'
    end
end