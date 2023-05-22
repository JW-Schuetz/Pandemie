function bins = fillGenderBins( gender, bins, count )
    switch( gender )
        case 'M'
            bins( 1 ) = bins( 1 ) + count;
        case 'W'
            bins( 2 ) = bins( 2 ) + count;
        otherwise
    end
end