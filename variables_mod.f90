MODULE VARIABLES
IMPLICIT NONE

!GLOBAL VARIABLES
integer               :: i,j, k, Nx, Ny , t_loop, il
integer               :: file_skip, tmax
integer, parameter    :: Nmax=2200,idum=92923932
real*8                :: dt, dx, epsilon, gamma, M, W2, dx2_in, ave_psi
real*8                :: PSI(0:Nmax,0:Nmax)
real*8                :: grad2(0:Nmax,0:Nmax)
real*8                :: RHS(0:Nmax,0:NMax)
character(len=9)      :: cn
character(len=3)	  :: initfile
character(len=14)	  :: initname
character(len=3)	  :: elecfield
double complex 		  :: PSIt(0:Nmax,0:Nmax)
double complex 		  :: PSIc(0:Nmax,0:Nmax)

CONTAINS

subroutine read_globals

	INTEGER 		  :: num_lines, ios, k
	character(len=1)  :: junk	
	
	!read initial parameters from file 
	open(1,file='input')
		read(1,*) dx          !space step
		read(1,*) dt          !time step
		read(1,*) epsilon     !small length scale
		read(1,*) gamma       !line tension coeff.
		read(1,*) file_skip   ! how often to print
		read(1,*) tmax        !how many total time steps to take
		read(1,*) Nx          !system size in the x direction
		read(1,*) Ny          !system size in the y direction 
		read(1,*) initfile	  !check if it reads the initial condition from a data file (= "yes" or "no")
		read(1,*) initname    !determining the initial condition
		read(1,*) elecfield	  !switch to turn on/off the electric field (= "on" or "off")
	close(1)

	!initialize specific parameters 
	PSI=0.0d0
	
	W2 = (epsilon*gamma)
	
	M=1.0d0
	
	dx2_in = 1 / dx**2
	
	!test that system sizes do not exceed declared dimensions (avoid this using dynamic allocation)
	if(Nx+1.gt.Nmax.or.Ny+1.gt.Nmax)then 
		print*, 'One of the system dimensions exceeds array dimensions'
		stop
	endif
	
	!teset if the system size given in initial file is the same as it defined in Nx and Ny
	num_lines = 0
	if (initfile =='yes') then
		open(0, file=initname, status='unknown')
		do k=1,1000000
			read(0,*, IOSTAT=ios) junk
			if (ios /= 0) exit
			if (k == 1000000) then
				print*, 'Error: Maximum number of records exceeded'
				print*, ''
				print*, 'Runing failure!'
				STOP
			endif
			num_lines = num_lines + 1 !number of lines in the file
		enddo
		rewind(0) 
		if (mod(num_lines, Nx*Ny) /= 0) then
			print*, 'Error: The system size of the initial file does not'
			print*, 'maatch with your domain size Nx and Ny'
			print*, ''
			print*, 'Runing failure!'
			STOP
		endif 
	endif
	
	print*,'Global data:'
	print*,'_________________________________'
	print 10, gamma, dt, dx, tmax, file_skip, Nx, Ny
10  FORMAT(' gamma = ',F8.4,/ ' dt = ',F6.4,/' dx = ',F6.4,/ ' tmax = ',I6,/ ' file_skip = ',I6,/ ' Nx = ',I6,/ ' Ny = ',I6)
	print*, 'Initil File = ', initfile
	if (initfile == 'yes') then
		print*, 'Filename = ', initname
	else
		print*, 'Initial = RANDOMSEED'
	endif
	print*, 'Electric field = ', elecfield
	print*,'_________________________________'

end subroutine read_globals


END MODULE VARIABLES
