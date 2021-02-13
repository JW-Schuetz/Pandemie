function [ data, winWidth ] = meanFilter( data, varargin )
% Achtung: das Ergebnis ist mit der Fensterbreite gewichtet!
% Mittelwertfilter, Fensterbreite 7: meanFilter( data )
% Mittelwertfilter, mit/ohne Einschwingen: meanFilter( data, 1/0 )
% Mittelwertfilter, mit/ohne Einschwingen, Fensterbreite N: meanFilter( data, 1/0, N )

    winWidth = 7;       % Default: 7-Tages Mittelwert-Filter
    noEngage = false;   % Default: mit Darstellung des Einschwingens

	switch nargin
        case 3
            winWidth = varargin{ 2 };
            noEngage = varargin{ 1 };
        case 2
            noEngage = varargin{ 1 };
        otherwise
	end

	data = filter( ones( 1, winWidth ), 1, data );

	% Einschwingen des Filters evtl. nicht darstellen
    if( winWidth ~= 1 ) % für winWidth = 1 existiert kein Einschwingen
        if( noEngage )
            data( 1 ) = 0;
            data( 2 : find( data, 1 ) + winWidth ) = Inf;
        end
    end
end