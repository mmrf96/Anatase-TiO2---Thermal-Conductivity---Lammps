function [] = Sheet2Tube(Plot)
% x -> Theta , z -> z , y -> r , Lattice [a,b,c] = [37.76 37.76 94.86]
% Radius = (max(x) + Lattice.a ) / 2*pi
    %% Readin File && Definitions
    coor = dlmread('AnataseSheet.txt');
    sz = length(coor(:,1));
    XX = zeros(1,sz);
    YY = zeros(1,sz);
    ZZ = zeros(1,sz);
    Cylind = zeros(sz,3);
    Cartesian_Coordinate = zeros(sz,3);
    Lx = max(coor(:,4))+ 1.888;
    LL = max(coor(:,6));
    Radius = Lx / (2*pi);
    Thickness = max(coor(:,5));

    %% Making Tube
    for i=1:sz
        xx = coor(i,4);
        yy = coor(i,5);
        [rr,tt] = Line2Circle(xx,yy,Radius,Lx,Thickness);
        Cylind(i,1) = rr;
        Cylind(i,2) = tt;
    end
    Cylind(:,3) = coor(:,6);

    %% Changing Coordinates
    for i=1:sz
        [xx,yy,zz] = Cylind2Cartez(Cylind(i,1),Cylind(i,2),Cylind(i,3));
        Cartesian_Coordinate(i,:) = [xx yy zz];
    end
    Xlo = min(Cartesian_Coordinate(:,1));
    Xhi = max(Cartesian_Coordinate(:,1));
    Ylo = min(Cartesian_Coordinate(:,2));
    Yhi = max(Cartesian_Coordinate(:,2));
    Zlo = min(Cartesian_Coordinate(:,3));
    Zhi = max(Cartesian_Coordinate(:,3));
    Box = [Xlo Xhi Ylo Yhi Zlo Zhi];

    %% Writing File
%     FileName = ['TiO2_TubeL', num2str(LL), 'R', num2str(Radius)];
    FileName = 'TiO2_Tube';
    f3 = fopen(FileName,'w');
    fprintf(f3,'ITEM: TIMESTEP\n0\nITEM: NUMBER OF ATOMS\n');
    fprintf(f3,'%i\n',sz);
    fprintf(f3,'ITEM: BOX BOUNDS\n');
    fprintf(f3,'%f\t%f\n%f\t%f\n%f\t%f\n',Box);
    fprintf(f3,'\nITEM: ATOMS id type x y z\n');
    for i=1:sz
        fprintf(f3,'%i\t%i\t',coor(i,1),coor(i,2));
        if coor(i,2)==1
            fprintf(f3,'-1.098\t');
        else
            fprintf(f3,' 2.196\t');
        end
        fprintf(f3,'%5.3f\t%5.3f\t%5.3f\n',Cartesian_Coordinate(i,1),Cartesian_Coordinate(i,2),Cartesian_Coordinate(i,3));
    end
    fclose all;
    %% Plotting
    if Plot==1
        figure;
        hold on;
        for i=1:length(Cartesian_Coordinate(:,1))
            if coor(i,2)==1
                plot3(Cartesian_Coordinate(i,1),Cartesian_Coordinate(i,2),Cartesian_Coordinate(i,3),'ko');
            else
                plot3(Cartesian_Coordinate(i,1),Cartesian_Coordinate(i,2),Cartesian_Coordinate(i,3),'r*');
            end
        %     pause;
        end
        xlabel('x');
        ylabel('y');
        zlabel('z');
    end
end