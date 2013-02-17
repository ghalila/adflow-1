   !        Generated by TAPENADE     (INRIA, Tropics team)
   !  Tapenade 3.6 (r4159) - 21 Sep 2011 10:11
   !
   !  Differentiation of adjustinflowangle in forward (tangent) mode:
   !   variations   of useful results: liftdirection dragdirection
   !                veldirfreestream
   !   with respect to varying inputs: liftdirection dragdirection
   !                alpha beta
   !
   !      ******************************************************************
   !      *                                                                *
   !      * File:          adjustInflowAngle.f90                           *
   !      * Author:        C.A.(Sandy) Mader                               *
   !      * Starting date: 07-13-2011                                      *
   !      * Last modified: 07-13-2011                                      *
   !      *                                                                *
   !      ******************************************************************
   !
   SUBROUTINE ADJUSTINFLOWANGLE_D(alpha, alphad, beta, betad, liftindex)
   USE INPUTPHYSICS
   USE CONSTANTS
   IMPLICIT NONE
   !Subroutine Vars
   REAL(kind=realtype), INTENT(IN) :: alpha, beta
   REAL(kind=realtype), INTENT(IN) :: alphad, betad
   INTEGER(kind=inttype), INTENT(IN) :: liftindex
   !Local Vars
   REAL(kind=realtype), DIMENSION(3) :: refdirection
   REAL(kind=realtype), DIMENSION(3) :: refdirectiond
   ! Velocity direction given by the rotation of a unit vector
   ! initially aligned along the positive x-direction (1,0,0)
   ! 1) rotate alpha radians cw about y or z-axis
   ! 2) rotate beta radians ccw about z or y-axis
   refdirection(:) = zero
   refdirectiond(1) = 0.0_8
   refdirection(1) = one
   veldirfreestreamd = 0.0_8
   CALL GETDIRVECTOR_D(refdirection, alpha, alphad, beta, betad, &
   &                veldirfreestream, veldirfreestreamd, liftindex)
   ! Drag direction given by the rotation of a unit vector
   ! initially aligned along the positive x-direction (1,0,0)
   ! 1) rotate alpha radians cw about y or z-axis
   ! 2) rotate beta radians ccw about z or y-axis
   refdirection(:) = zero
   refdirectiond(1) = 0.0_8
   refdirection(1) = one
   CALL GETDIRVECTOR_D(refdirection, alpha, alphad, beta, betad, &
   &                dragdirection, dragdirectiond, liftindex)
   ! Lift direction given by the rotation of a unit vector
   ! initially aligned along the positive z-direction (0,0,1)
   ! 1) rotate alpha radians cw about y or z-axis
   ! 2) rotate beta radians ccw about z or y-axis
   refdirection(:) = zero
   refdirectiond(liftindex) = 0.0_8
   refdirection(liftindex) = one
   CALL GETDIRVECTOR_D(refdirection, alpha, alphad, beta, betad, &
   &                liftdirection, liftdirectiond, liftindex)
   END SUBROUTINE ADJUSTINFLOWANGLE_D
