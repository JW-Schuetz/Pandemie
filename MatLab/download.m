function download( url, infile )
    % Verbesserungsmöglichkeit:
    % zunächst die Grösse des neuen Remotefiles bestimmen
    % nur herunterladen, falls das neue File grösser als das letzte ist

    % Remotedatei herunterladen
    state = system( sprintf( 'curl -L %s > %s', url, infile ) );

	errstr = 'Download %s gescheitert - Status: %d';
    if( state ~= 0 )
        error( errstr, infile )
    end

    d = dir( infile );
    if( d.bytes < 1000 )
        delete( sprintf( '%s', infile ) )
        error( errstr, infile )
    end
end