These codes simulate the phase-field model of the system of lipid/pore mixture subjected under applied electric field. Allen-Cahn equations are implemented along with electric field solver. The file "manager.f90" is the highest level of control, co-ordinating, so to speak, the sequence to calls to to solvers, initializations, etc. The module solver_mod.f90 contains the  solver routines. The module util_mod.f90 contains functions called upon to do various i/o.

Input variables are given in input file.

Note 1: For initfile the variable takes either "yes" or "no". If it's yes the initname would be the name of the file contains the initial profile of order parameter. Otherwise, the code will do the random mixtures of values with ave=0.5.

To compile the codes into an executable, type: "make"
To run, type ./<name_of_executable>