clc
clear

load( 'res.mat', 'res' )

days = size( res, 1 );
bl   = length( res{ 1, 2 } );
dt   = datetime;
m    = zeros( 16, days );

for n = 1 : days
    dt( n ) = res{ n, 1 };
    d       = res{ n, 2 };

    m( :, n ) = d;
end

hold on
grid on

for n = 1 : 16
    plot( dt, m( n, : ) )
end