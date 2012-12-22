   !        Generated by TAPENADE     (INRIA, Tropics team)
   !  Tapenade 3.4 (r3375) - 10 Feb 2010 15:08
   !
   !
   !      ******************************************************************
   !      *                                                                *
   !      * File:          precision.F90                                   *
   !      * Author:        Edwin van der Weide                             *
   !      * Starting date: 12-09-2002                                      *
   !      * Last modified: 06-25-2005                                      *
   !      *                                                                *
   !      ******************************************************************
   !
   MODULE PRECISION_SPATIAL_D

   IMPLICIT NONE
   !#endif
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Definition of the kinds used for the integer and real types.   *
   !      * Due to MPI, it is a bit messy to use the compiler options -r8  *
   !      * and -r4 and therefore the kind construction is used here,      *
   !      * where the precision is set using compiler flags of -d type.    *
   !      *                                                                *
   !      * This is the only file of the code that should be changed when  *
   !      * a user wants single precision instead of double precision. All *
   !      * other routines use the definitions in this file whenever       *
   !      * possible. If other definitions are used, there is a good       *
   !      * reason to do so, e.g. when calling the cgns or MPI functions.  *
   !      *                                                                *
   !      * The actual types used are determined by compiler flags like    *
   !      * -DUSE_LONG_INT and -DUSE_SINGLE_PRECISION. If these are        *
   !      * omitted the default integer and double precision are used.     *
   !      *                                                                *
   !      ******************************************************************
   !

   SAVE 
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Definition of the integer type used in the entire code. There  *
   !      * might be a more elegant solution to do this, but be sure that  *
   !      * compatability with MPI must be guaranteed. Note that dummyInt  *
   !      * is a private variable, only used for the definition of the     *
   !      * integer type. Note furthermore that the parameters defining    *
   !      * the MPI types are integers. This is because of the definition  *
   !      * in MPI.                                                        *
   !      *                                                                *
   !      ******************************************************************
   !
   !#ifdef USE_LONG_INT
   ! Long, i.e. 8 byte, integers are used as default integers
   !       integer(kind=8), private :: dummyInt
   !       integer, parameter       :: sumb_integer  = mpi_integer8
   !       integer, parameter       :: sizeOfInteger = 8
   !#else!
   !
   ! Standard 4 byte integer types are used as default integers.
   INTEGER(kind=4), PRIVATE :: dummyint
   INTEGER, PARAMETER :: sumb_integer=mpi_integer4
   INTEGER, PARAMETER :: sizeofinteger=4
   !#endif
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Definition of the float type used in the entire code. The      *
   !      * remarks mentioned before the integer type definition also      *
   !      * apply here.                                                    *
   !      *                                                                *
   !      ******************************************************************
   !
   !#ifdef USE_SINGLE_PRECISION!
   !
   !       ! Single precision reals are used as default real types.!
   !
   !      real(kind=4), private :: dummyReal
   !       integer, parameter    :: sumb_real  = mpi_real4
   !       integer, parameter    :: sizeOfReal = 4!
   !
   !       real(kind=4), private :: dummyCGNSReal
   !#elif USE_QUADRUPLE_PRECISION
   ! Quadrupole precision reals are used as default real types.
   ! This may not be supported on all platforms.
   ! As cgns does not support quadrupole precision, double
   ! precision is used instead.
   !       real(kind=16), private :: dummyReal
   !       integer, parameter     :: sumb_real  = mpi_real16!
   !       integer, parameter     :: sizeOfReal = 16
   !
   !       real(kind=8), private :: dummyCGNSReal
   !#else
   ! Double precision reals are used as default real types.
   REAL(kind=8), PRIVATE :: dummyreal
   INTEGER, PARAMETER :: sumb_real=mpi_real8
   INTEGER, PARAMETER :: sizeofreal=8
   REAL(kind=8), PRIVATE :: dummycgnsreal
   !#endif
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Definition of the porosity type. As this is only a flag to     *
   !      * indicate whether or not fluxes must be computed, an integer1   *
   !      * is perfectly okay.                                             *
   !      *                                                                *
   !      ******************************************************************
   !
   INTEGER(kind=1), PRIVATE :: dummypor
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Definition of the cgns periodic type.                          *
   !      *                                                                *
   !      ******************************************************************
   !
   REAL, PRIVATE :: dummycgnsper
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Definition of the kind parameters for the integer and real     *
   !      * types.                                                         *
   !      *                                                                *
   !      ******************************************************************
   !
   INTEGER, PARAMETER :: inttype=kind(dummyint)
   INTEGER, PARAMETER :: portype=kind(dummypor)
   INTEGER, PARAMETER :: realtype=kind(dummyreal)
   INTEGER, PARAMETER :: cgnsrealtype=kind(dummycgnsreal)
   INTEGER, PARAMETER :: cgnspertype=kind(dummycgnsper)
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Definition of the reals use by the visualization package PV3.  *
   !      * Note that PV3 expects all of its information to be passed back *
   !      * as 4-byte (float) reals.                                       *
   !      *                                                                *
   !      ******************************************************************
   !
   INTEGER(kind=4), PRIVATE :: dummyintpv3
   REAL(kind=4), PRIVATE :: dummyrealpv3
   INTEGER, PARAMETER :: intpv3type=kind(dummyintpv3)
   INTEGER, PARAMETER :: realpv3type=kind(dummyrealpv3)
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Definition of the integer types and their corresponding sizes  *
   !      * in a PLOT3D file and corresponding solution file.              *
   !      *                                                                *
   !      ******************************************************************
   !
   INTEGER(kind=4), PRIVATE :: dummyintplot3d
   INTEGER(kind=4), PRIVATE :: dummyrecordintplot3d
   INTEGER, PARAMETER :: intplot3dtype=kind(dummyintplot3d)
   INTEGER, PARAMETER :: intrecordplot3dtype=kind(dummyrecordintplot3d)
   INTEGER(kind=inttype), PARAMETER :: nbytesperintplot3d=4
   INTEGER(kind=inttype), PARAMETER :: nbytesperrecordintplot3d=4
   INTEGER, PARAMETER :: sumb_integerplot3d=mpi_integer4
   INTEGER, PARAMETER :: sumb_integerrecordplot3d=mpi_integer4
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Set the parameter debug, depending on the compiler option.     *
   !      *                                                                *
   !      ******************************************************************
   !
   !#ifdef DEBUG_MODE
   !       logical, parameter :: debug = .true.
   !#else
   LOGICAL, PARAMETER :: debug=.false.
   END MODULE PRECISION_SPATIAL_D
