function datum = impfEnde( impfAnzahl, impfDatum, writeIt )
    impfStart = datetime( '27.12.2020' );
    impfTage  = days( impfDatum - impfStart );
    datum     = impfStart + 2 * einwohner / impfAnzahl * impfTage;

    if( writeIt )
        d = day( datum );
        m = month( datum );
        y = year( datum );
        datumTxt = sprintf( '%02d.%02d.%4d', d, m, y );

        fID = fopen( '../DatumImpfende.txt', 'w' );
        fwrite( fID, [ '          ', datumTxt ] );
        fclose( fID );
    end
end