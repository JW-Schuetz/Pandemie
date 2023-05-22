function datum = generateDateArray( startDate, endDate )
% lückenloses datestring array erzeugen

    % Anzahl der Tage
    numDays = datenum( endDate ) - datenum( startDate );

    % Datums-Array
    datum      = datetime;
    datum( 1 ) = startDate;

    for n = 2 : numDays + 1
        datum( n ) = datum( n - 1 ) + 1;
    end

    datum = datum';
end