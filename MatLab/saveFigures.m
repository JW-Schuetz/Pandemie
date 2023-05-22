function saveFigures( figures, outputDirPrefix )
    % alle Figures speichern
    for n = 1 : size( figures, 1 )
        f = figures{ n, 1 };

        saveas( f, [ outputDirPrefix, figures{ n, 2 } ], 'epsc' );
    end

    close all
end
