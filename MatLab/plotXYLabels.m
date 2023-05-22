function plotXYLabels( modus, name )
    switch modus
        case 0
            xlabel( 'Meldedatum', 'FontSize', 12, 'FontWeight', 'normal' )
        case 1
            xlabel( 'Referenzdatum', 'FontSize', 12, 'FontWeight', 'normal' )
        case 2
            xlabel( 'Datenstandsdatum', 'FontSize', 12, 'FontWeight', 'normal' )
        case 3
            xlabel( 'Datum', 'FontSize', 12, 'FontWeight', 'normal' )
        otherwise
    end
    ylabel( name, 'FontSize', 12, 'FontWeight', 'normal' )
end