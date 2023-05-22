function bins = fillAgeBins( age, bins, count )
    switch( age )
        case 'A00-A04'
            bins( 1 ) = bins( 1 ) + count;
        case 'A05-A14'
            bins( 2 ) = bins( 2 ) + count;
        case 'A15-A34'
            bins( 3 ) = bins( 3 ) + count;
        case 'A35-A59'
            bins( 4 ) = bins( 4 ) + count;
        case 'A60-A79'
            bins( 5 ) = bins( 5 ) + count;
        case 'A80+'
            bins( 6 ) = bins( 6 ) + count;
        case 'unbekannt'
            bins( 7 ) = bins( 7 ) + count;
        otherwise
    end
end