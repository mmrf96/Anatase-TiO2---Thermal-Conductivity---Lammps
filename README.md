TiO2 Nanotube Thermal Conductivity (NEMD)
-----------------------------------------

This repository contains the input files and builder codes used to study the
thermal conductivity of anatase TiO2 nanotubes using nonequilibrium molecular
dynamics (NEMD).

Contents:
- TiO2.in          : LAMMPS NEMD input script (with Buckingham coefficients inline)
- 50_10_Full.data  : Example nanotube structure file in LAMMPS format
- nanotube builder/         : MATLAB nanotube builder scripts

How to use:
1. Use the MATLAB nanotube builder scripts (in nannotube builder/) to generate a nanotube
   geometry and save the output in a format suitable for OVITO (e.g., .xyz or .cfg).
2. Open the structure in OVITO and export it as a LAMMPS "data" file.
   The provided example is 50_10_Full.data.
3. Place the exported data file in the same directory as TiO2.in.
4. Run the simulation with LAMMPS, for example:
      lmp_serial -in TiO2.in
   or
      mpirun -np 4 lmp_mpi -in TiO2.in
5. Outputs will include a trajectory (dump file) and a log file with simulation
   details and conductivity results.

Notes:
- The provided 50_10_Full.data and TiO2.in reproduce the setup used in the paper.
- Buckingham potential coefficients are specified directly in TiO2.in.
- Atom types in 50_10_Full.data must match those expected in TiO2.in:
      type 1 = Oxygen (O)
      type 2 = Titanium (Ti)
