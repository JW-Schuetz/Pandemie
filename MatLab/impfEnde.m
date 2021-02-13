function datum = impfEnde( impfAnzahl, impfDatum )
    impfStart = datetime( '27.12.2020' );
    impfTage  = days( impfDatum - impfStart );
    datum     = impfStart + 2 * einwohner / impfAnzahl * impfTage;
end