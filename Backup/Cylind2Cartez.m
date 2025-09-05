function [XX,YY,ZZ] = Cylind2Cartez(RR,Theta,zz)
    XX = RR * cos(Theta);
    YY = RR * sin(Theta);
    ZZ = zz;
end