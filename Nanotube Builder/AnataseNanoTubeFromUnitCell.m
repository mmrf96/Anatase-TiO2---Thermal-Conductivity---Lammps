% This code creates a sheet of anatase with length of L_Bulk using the
% coordinates of UnitCell and writes the file SheetCoordinates.txt
%% Initialization
clear
clc
Plot = 0;
%% Reading Unit Cell Coordinates
UnitCell = dlmread('AnataseUnitCell.txt');
L_Unit = [max(UnitCell(:,4)) max(UnitCell(:,5)) max(UnitCell(:,6))];
N_Atoms_Unit_Cell = length(UnitCell(:,1));
N_Atoms_X0 = N_Atoms_Unit_Cell - length( find(UnitCell(:,4)>0) );
N_Atoms_Y0 = N_Atoms_Unit_Cell - length( find(UnitCell(:,5)>0) );
N_Atoms_Z0 = N_Atoms_Unit_Cell - length( find(UnitCell(:,6)>0) );
%% Defining the Desired Length of the Sheet
Radius = 30;
LL = 343;
L_x = Radius * 2 * pi - 1.888;
L_Bulk = [L_x 4 LL]; %[300 4 300];% Dimensions of the Anatase Sheet
%% Calculating the Number of Unit Cell Repetition
N_Repeat = zeros(1,3);
for i=1:3
    N_Repeat(1,i) = floor( L_Bulk(i)/L_Unit(i) );
end
%% Creating the New Coordinates
RC_x = UnitCell(find( UnitCell(:,4)>0 ),:); %#ok<FNDSB>
N_RCX = length(RC_x(:,1));
X_Slab = UnitCell;
for i=2:N_Repeat(1)
    I1 = N_Atoms_Unit_Cell + (i-2)*N_RCX;
    X_Slab(I1+1:I1+N_RCX,:) = RC_x;
    X_Slab(I1+1:I1+N_RCX,4) = X_Slab(I1+1:I1+N_RCX,4) + (i-1)*L_Unit(1);
end

N_Atoms_X_Slab = length(X_Slab(:,1));
RC_y = X_Slab(find( X_Slab(:,5) >0 ),:); %#ok<FNDSB>
N_RCY = length(RC_y(:,1));
XY_Plane = X_Slab;
for i=2:N_Repeat(2)
    I1 = N_Atoms_X_Slab + (i-2)*N_RCY;
    XY_Plane(I1+1:I1+N_RCY,:) = RC_y;
    XY_Plane(I1+1:I1+N_RCY,5) = XY_Plane(I1+1:I1+N_RCY,5) + (i-1)*L_Unit(2);
end

N_Atoms_XY_Plane = length(XY_Plane(:,1));
RC_z = XY_Plane(find( XY_Plane(:,6) >0 ),:); %#ok<FNDSB>
N_RCZ = length(RC_z(:,1));
New_Coord = XY_Plane;
for i=2:N_Repeat(3)
    I1 = N_Atoms_XY_Plane + (i-2)*N_RCZ;
    New_Coord(I1+1:I1+N_RCZ,:) = RC_z;
    New_Coord(I1+1:I1+N_RCZ,6) = New_Coord(I1+1:I1+N_RCZ,6) + (i-1)*L_Unit(3);
end
%% Removing the Last Row in x-Direction to Role the Sheet
L_x = max( New_Coord(:,4) );
Last_Row = find(New_Coord(:,4)==L_x);
New_Coord(Last_Row,:) = [];
New_Coord(:,1) = 1:length(New_Coord(:,1));
%% Removing the Last Row in z-Direction to Neutralize the Tube
L_z = max( New_Coord(:,6) );
Last_Row = find(New_Coord(:,6)==L_z);
New_Coord(Last_Row,:) = [];
New_Coord(:,1) = 1:length(New_Coord(:,1));
%% Plotting the New Atoms
if Plot==1
    figure;
    hold on;
    for i=1:length(New_Coord(:,1))
        if New_Coord(i,2)==1
            plot3(New_Coord(i,4),New_Coord(i,5),New_Coord(i,6),'ko');
        else
            plot3(New_Coord(i,4),New_Coord(i,5),New_Coord(i,6),'r*');
        end
        %     pause;
    end
    xlabel('x');
    ylabel('y');
    zlabel('z');
end
%% Writing Data on a File
File1 = fopen('AnataseSheet.txt','w');
for i=1:length(New_Coord(:,1))
    fprintf(File1,'%i\t%i\t%1.3f\t%1.4e\t%1.4e\t%1.4e\n',i,New_Coord(i,2:6));
end
Sheet2Tube(Plot)
fclose all;