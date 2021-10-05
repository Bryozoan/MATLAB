function [vP, vP2Sig, vResid, vY2Sig] = MyLineFitter(vX, vY)

    vP = polyfit(vX, vY, 1):
    
    
    vYcalc = polyval(vP, vX);
    vResid = vY - vYcalc;
    
    vY2Sig = 2 * std(vResid);
    
    mBootStat = boot