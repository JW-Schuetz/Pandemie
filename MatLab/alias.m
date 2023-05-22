function alias = alias( name )
    list = { ...
        %  offizieller Kreisname,  mein Aliasname
        { 'LK Odenwaldkreis',     'Odenwaldkreis'  };
        { 'SK Frankfurt am Main', 'Frankfurt-Main' };
        { 'SK Darmstadt',         'Darmstadt'      };
        { 'LK Groß-Gerau',        'Gross-Gerau'    };
        { 'LK Offenbach',         'LK-Offenbach'   };
        { 'LK Darmstadt-Dieburg', 'LK-Dieburg'     };
    };

    for n = 1 : length( list )
        if( strcmp( list{ n }{ 1 }, name ) == 1 )
            alias = list{ n }{ 2 };
            return
        end
    end

    alias = name;
end
