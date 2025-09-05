function [rr,tt] = Line2Circle(xx,yy,Radius,Lx,Thickness)
    rr = Radius + (yy-Thickness/2);
    tt = (xx / Lx) * 2*pi;
end