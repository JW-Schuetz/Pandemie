function age1 = mergeBins( age1, age2 )
    len = length( age1 );

    if( len ~= length( age2 ) )
        error( 'megeBins(): Die Daten sind inkompatibel' )
    end

    for n = 1 : len
        age1{ n } = age1{ n } + age2{ n };
    end
end