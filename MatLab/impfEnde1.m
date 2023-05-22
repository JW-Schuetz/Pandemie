function datum = impfEnde1( impfAnzahl, impfDatum, impfStart, writeIt )
    impfTage = days( impfDatum - impfStart ) + 1;
    datum    = impfStart + 2 * einwohner / impfAnzahl * impfTage;

    if( writeIt )
        writeImpfEnde( '../DatumImpfende1.txt', datum );
    end
end