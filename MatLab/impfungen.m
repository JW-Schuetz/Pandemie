function impfungen()
	load( 'bundesland.mat', 'bundeslandKeys', 'bundeslandName' )

	keyLength = length( bundeslandKeys );
    names     = cell( keyLength, 1 );
    for n = 1 : keyLength
        names( n ) = bundeslandName( bundeslandKeys( n ) );
    end

    names          = string( names );
    [ names, ndx ] = sort( names );

    names

% 04.01.2020
% 27.454
% 66.258
% 17.758
% 3.309
% 1.903
% 4.140
% 33.405
% 11.494
% 5.394
% 53.841
% 7.248
% 4.149
% 4.866
% 13.366
% 9.557
% 810

% 03.01.2020
% 20.045
% 39.005
% 13.137
% 3.219
% 1.741
% 3.042
% 24.791
% 11.494
% 3.945
% 33.375
% 6.898
% 3.316
% 4.000
% 11.771
% 7.964
% 810

% 02.01.2020
% 17.086
% 37.955
% 11.114
% 3.219
% 1.741
% 2.759
% 21.373
% 11.494
% 3.566
% 24.924
% 5.112
% 2.716
% 3.290
% 11.146
% 7.270
% 810
end