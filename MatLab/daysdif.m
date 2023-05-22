function numDays = daysdif( datStart, datEnd )
    % Anzahl der Tage zwischen zwei Zeitpunkten
	numDays = datenum( datEnd ) - datenum( datStart );
end