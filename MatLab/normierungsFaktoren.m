function [ fak, fakBL, fakLK ] = normierungsFaktoren( varargin )
	einwohnerFaktor = 100000;

    switch ( size( varargin, 2 ) )
        case 0
            fak = einwohnerFaktor / einwohner;

        case 1
            bundesLandId = varargin{ 1 };

            fak   = einwohnerFaktor / einwohner;
            fakBL = einwohnerFaktor / einwohnerLand( bundesLandId );

        otherwise
            bundesLandId = varargin{ 1 };
            kreisId      = varargin{ 2 };

            fak   = einwohnerFaktor / einwohner;
            fakBL = einwohnerFaktor / einwohnerLand( bundesLandId );
            fakLK = einwohnerFaktor / einwohnerKreis( kreisId );
    end
end