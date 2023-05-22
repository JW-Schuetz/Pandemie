function writeImpfEnde( file, datum )
    d = day( datum );
    m = month( datum );
    y = year( datum );

    datumTxt = sprintf( '%02d.%02d.%4d', d, m, y );
    fID      = fopen( file, 'w' );
    fwrite( fID, [ '          ', datumTxt ] );
    fclose( fID );
end