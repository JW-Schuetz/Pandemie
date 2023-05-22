function [ dataBase, keys ] = makeDataBase( Table )
% Nummern der Table-Entries:
%   1     'ObjectId'
%   2     'BundeslandId'
%   3     'Bundesland'
%   4     'Landkreis'
%   5     'Altersgruppe'
%   6     'Geschlecht'
%   7     'Fallanzahl'
%   8     'TodesfallAnzahl'
%   9     'Meldedatum'
%   10    'LandkreisId'
%   11    'Datenstand'
%   12    'NeuerFall'
%   13    'NeuerTodesfall'
%   14    'Referenzdatum'
%   15    'NeuGenesen'
%   16    'GenesenAnzahl'
%   17    'IstErkrankungsbeginn'
%   18    'Altersgruppe2'

    keys     = Table.ObjectId;
    dataBase = containers.Map( 'KeyType', 'int32', 'ValueType', 'any' );

    % keys der Map initialisieren
    old = 100;
    len = length( keys );

    for n = 1 : len
        fortSchritt = fix( 100 * n / len );
        if( fortSchritt ~= old )
            home; sprintf( '%s: Füge Tabelleneintrag %d zur Datenbank hinzu. Fortschritt: %3.0f Prozent', ...
                           'makeDataBase()', n, fortSchritt )
            old = fortSchritt;
        end

        dataBase( keys( n ) ) = Table( n, [ 2, 3, 4, 5, 6, 7, 8, 9, 10, 14 ] );
    end

	home; sprintf( 'makeDataBase(): fertig' )
end