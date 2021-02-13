function simple_SIR_Modell()
    clc
    clear

    P        = 80*10^6;     % population
    I0Dach   = 1;           % infected
    ImaxDach = 0.0001 * P;	% allowed max. infected
    Imax     = 0.0001;

    S0Dach = P - ImaxDach;
    S0     = S0Dach / P;

    arg    = log( ( 1 - Imax ) / S0Dach ) - 1;
    rImax  = wrightOmega( arg ) / ( 1 - Imax );

    alpha  = 2.0;
    beta   = alpha / rImax;
    yStart = [ P - I0; I0; 0.0 ];

    options  = odeset( 'NonNegative', 1 );
    [ t, y ] = ode45( @( t, y ) sir( t, y, alpha, beta ), [ 0; 0.01 ], yStart, options );

    hold on
    grid on
    plot( t, y(:,1), '-k' )
    plot( t, y(:,2), '-r' )
    plot( t, y(:,3), '-g' )

	legend( 'Infizierbar', 'Infiziert', 'Gesundet (oder tot)', 'Location', 'northwest' )
end

function dydx = sir( t, y, alpha, beta )
    a = alpha * y(1) * y(2);
    b = beta * y(2);

    dydx = [ -a; a - b; b ];
end