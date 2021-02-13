function download( url, infile )
    errstr = 'Download %s gescheitert!';
    state = system( sprintf( 'curl -L %s > %s', url, infile ) );

    if( state ~= 0 )
        error( errstr, infile )
    end

    d = dir( infile );
    if( d.bytes < 1000 )
        delete( sprintf( '%s', infile ) )
        error( errstr, infile )
    end
end