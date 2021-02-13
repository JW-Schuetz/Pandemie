function datum = readImmuDate( srcDir, infile )
    fileName = [ srcDir, infile ];

    opts  = detectImportOptions( fileName, 'Sheet', 1 );
    datum = readtable( fileName, opts ).Var2( 1 );
end