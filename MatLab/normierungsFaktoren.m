function [ fak, fakBL, fakLK ] = normierungsFaktoren( bundesLandId, kreisId )
	einwohnerFaktor = 100000;

    fak   = einwohnerFaktor / einwohner;
    fakBL = einwohnerFaktor / einwohnerLand( bundesLandId );
    fakLK = einwohnerFaktor / einwohnerKreis( kreisId );
end