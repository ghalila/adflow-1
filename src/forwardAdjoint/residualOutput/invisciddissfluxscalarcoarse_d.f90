   !        Generated by TAPENADE     (INRIA, Tropics team)
   !  Tapenade 3.6 (r4159) - 21 Sep 2011 10:11
   !
   !  Differentiation of invisciddissfluxscalarcoarse in forward (tangent) mode:
   !   variations   of useful results: *w *fw
   !   with respect to varying inputs: *p *w *radi *radj *radk
   !   Plus diff mem management of: p:in w:in fw:in radi:in radj:in
   !                radk:in
   !
   !      ******************************************************************
   !      *                                                                *
   !      * File:          inviscidDissFluxScalarCoarse.f90                *
   !      * Author:        Edwin van der Weide                             *
   !      * Starting date: 03-25-2003                                      *
   !      * Last modified: 08-25-2005                                      *
   !      *                                                                *
   !      ******************************************************************
   !
   SUBROUTINE INVISCIDDISSFLUXSCALARCOARSE_D()
   USE BLOCKPOINTERS_D
   USE INPUTDISCRETIZATION
   USE CONSTANTS
   USE ITERATION
   IMPLICIT NONE
   !
   !      ******************************************************************
   !      *                                                                *
   !      * inviscidDissFluxScalarCoarse computes the coarse grid, i.e.    *
   !      * 1st order, artificial dissipation flux for the scalar          *
   !      * dissipation scheme for a given block. Therefore it is assumed  *
   !      * that the pointers in blockPointers already point to the        *
   !      * correct block.                                                 *
   !      *                                                                *
   !      ******************************************************************
   !
   !
   !      Local variables.
   !
   INTEGER(kind=inttype) :: i, j, k
   REAL(kind=realtype) :: sfil, fis0, dis0, ppor, fs, rhoi
   REAL(kind=realtype) :: dis0d, fsd, rhoid
   INTRINSIC ABS
   REAL(kind=realtype) :: abs0
   IF (rfil .GE. 0.) THEN
   abs0 = rfil
   ELSE
   abs0 = -rfil
   END IF
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Begin execution                                                *
   !      *                                                                *
   !      ******************************************************************
   !
   ! Check if rFil == 0. If so, the dissipative flux needs not to
   ! be computed.
   IF (abs0 .LT. thresholdreal) THEN
   fwd = 0.0_8
   RETURN
   ELSE
   ! Set a couple of constants for the scheme.
   fis0 = rfil*vis2coarse
   sfil = one - rfil
   ! Replace the total energy by rho times the total enthalpy.
   ! In this way the numerical solution is total enthalpy preserving
   ! for the steady Euler equations. Also replace the velocities by
   ! the momentum. As only first order halo's are needed, only include
   ! the first order halo's.
   DO k=1,ke
   DO j=1,je
   DO i=1,ie
   wd(i, j, k, ivx) = wd(i, j, k, irho)*w(i, j, k, ivx) + w(i, j&
   &            , k, irho)*wd(i, j, k, ivx)
   w(i, j, k, ivx) = w(i, j, k, irho)*w(i, j, k, ivx)
   wd(i, j, k, ivy) = wd(i, j, k, irho)*w(i, j, k, ivy) + w(i, j&
   &            , k, irho)*wd(i, j, k, ivy)
   w(i, j, k, ivy) = w(i, j, k, irho)*w(i, j, k, ivy)
   wd(i, j, k, ivz) = wd(i, j, k, irho)*w(i, j, k, ivz) + w(i, j&
   &            , k, irho)*wd(i, j, k, ivz)
   w(i, j, k, ivz) = w(i, j, k, irho)*w(i, j, k, ivz)
   wd(i, j, k, irhoe) = wd(i, j, k, irhoe) + pd(i, j, k)
   w(i, j, k, irhoe) = w(i, j, k, irhoe) + p(i, j, k)
   END DO
   END DO
   END DO
   ! Initialize the dissipative residual to a certain times,
   ! possibly zero, the previously stored value. Owned cells
   ! only, because the halo values do not matter.
   DO k=2,kl
   DO j=2,jl
   DO i=2,il
   fwd(i, j, k, irho) = 0.0_8
   fw(i, j, k, irho) = sfil*fw(i, j, k, irho)
   fwd(i, j, k, imx) = 0.0_8
   fw(i, j, k, imx) = sfil*fw(i, j, k, imx)
   fwd(i, j, k, imy) = 0.0_8
   fw(i, j, k, imy) = sfil*fw(i, j, k, imy)
   fwd(i, j, k, imz) = 0.0_8
   fw(i, j, k, imz) = sfil*fw(i, j, k, imz)
   fwd(i, j, k, irhoe) = 0.0_8
   fw(i, j, k, irhoe) = sfil*fw(i, j, k, irhoe)
   END DO
   END DO
   END DO
   fwd = 0.0_8
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Dissipative fluxes in the i-direction.                         *
   !      *                                                                *
   !      ******************************************************************
   !
   DO k=2,kl
   DO j=2,jl
   DO i=1,il
   ! Compute the dissipation coefficients for this face.
   ppor = zero
   IF (pori(i, j, k) .EQ. normalflux) ppor = half
   dis0d = fis0*ppor*(radid(i, j, k)+radid(i+1, j, k))
   dis0 = fis0*ppor*(radi(i, j, k)+radi(i+1, j, k))
   ! Compute and scatter the dissipative flux.
   ! Density.
   fsd = dis0d*(w(i+1, j, k, irho)-w(i, j, k, irho)) + dis0*(wd(i&
   &            +1, j, k, irho)-wd(i, j, k, irho))
   fs = dis0*(w(i+1, j, k, irho)-w(i, j, k, irho))
   fwd(i+1, j, k, irho) = fwd(i+1, j, k, irho) + fsd
   fw(i+1, j, k, irho) = fw(i+1, j, k, irho) + fs
   fwd(i, j, k, irho) = fwd(i, j, k, irho) - fsd
   fw(i, j, k, irho) = fw(i, j, k, irho) - fs
   ! X-momentum.
   fsd = dis0d*(w(i+1, j, k, ivx)-w(i, j, k, ivx)) + dis0*(wd(i+1&
   &            , j, k, ivx)-wd(i, j, k, ivx))
   fs = dis0*(w(i+1, j, k, ivx)-w(i, j, k, ivx))
   fwd(i+1, j, k, imx) = fwd(i+1, j, k, imx) + fsd
   fw(i+1, j, k, imx) = fw(i+1, j, k, imx) + fs
   fwd(i, j, k, imx) = fwd(i, j, k, imx) - fsd
   fw(i, j, k, imx) = fw(i, j, k, imx) - fs
   ! Y-momentum.
   fsd = dis0d*(w(i+1, j, k, ivy)-w(i, j, k, ivy)) + dis0*(wd(i+1&
   &            , j, k, ivy)-wd(i, j, k, ivy))
   fs = dis0*(w(i+1, j, k, ivy)-w(i, j, k, ivy))
   fwd(i+1, j, k, imy) = fwd(i+1, j, k, imy) + fsd
   fw(i+1, j, k, imy) = fw(i+1, j, k, imy) + fs
   fwd(i, j, k, imy) = fwd(i, j, k, imy) - fsd
   fw(i, j, k, imy) = fw(i, j, k, imy) - fs
   ! Z-momentum.
   fsd = dis0d*(w(i+1, j, k, ivz)-w(i, j, k, ivz)) + dis0*(wd(i+1&
   &            , j, k, ivz)-wd(i, j, k, ivz))
   fs = dis0*(w(i+1, j, k, ivz)-w(i, j, k, ivz))
   fwd(i+1, j, k, imz) = fwd(i+1, j, k, imz) + fsd
   fw(i+1, j, k, imz) = fw(i+1, j, k, imz) + fs
   fwd(i, j, k, imz) = fwd(i, j, k, imz) - fsd
   fw(i, j, k, imz) = fw(i, j, k, imz) - fs
   ! Energy.
   fsd = dis0d*(w(i+1, j, k, irhoe)-w(i, j, k, irhoe)) + dis0*(wd&
   &            (i+1, j, k, irhoe)-wd(i, j, k, irhoe))
   fs = dis0*(w(i+1, j, k, irhoe)-w(i, j, k, irhoe))
   fwd(i+1, j, k, irhoe) = fwd(i+1, j, k, irhoe) + fsd
   fw(i+1, j, k, irhoe) = fw(i+1, j, k, irhoe) + fs
   fwd(i, j, k, irhoe) = fwd(i, j, k, irhoe) - fsd
   fw(i, j, k, irhoe) = fw(i, j, k, irhoe) - fs
   END DO
   END DO
   END DO
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Dissipative fluxes in the j-direction.                         *
   !      *                                                                *
   !      ******************************************************************
   !
   DO k=2,kl
   DO j=1,jl
   DO i=2,il
   ! Compute the dissipation coefficients for this face.
   ppor = zero
   IF (porj(i, j, k) .EQ. normalflux) ppor = half
   dis0d = fis0*ppor*(radjd(i, j, k)+radjd(i, j+1, k))
   dis0 = fis0*ppor*(radj(i, j, k)+radj(i, j+1, k))
   ! Compute and scatter the dissipative flux.
   ! Density.
   fsd = dis0d*(w(i, j+1, k, irho)-w(i, j, k, irho)) + dis0*(wd(i&
   &            , j+1, k, irho)-wd(i, j, k, irho))
   fs = dis0*(w(i, j+1, k, irho)-w(i, j, k, irho))
   fwd(i, j+1, k, irho) = fwd(i, j+1, k, irho) + fsd
   fw(i, j+1, k, irho) = fw(i, j+1, k, irho) + fs
   fwd(i, j, k, irho) = fwd(i, j, k, irho) - fsd
   fw(i, j, k, irho) = fw(i, j, k, irho) - fs
   ! X-momentum.
   fsd = dis0d*(w(i, j+1, k, ivx)-w(i, j, k, ivx)) + dis0*(wd(i, &
   &            j+1, k, ivx)-wd(i, j, k, ivx))
   fs = dis0*(w(i, j+1, k, ivx)-w(i, j, k, ivx))
   fwd(i, j+1, k, imx) = fwd(i, j+1, k, imx) + fsd
   fw(i, j+1, k, imx) = fw(i, j+1, k, imx) + fs
   fwd(i, j, k, imx) = fwd(i, j, k, imx) - fsd
   fw(i, j, k, imx) = fw(i, j, k, imx) - fs
   ! Y-momentum.
   fsd = dis0d*(w(i, j+1, k, ivy)-w(i, j, k, ivy)) + dis0*(wd(i, &
   &            j+1, k, ivy)-wd(i, j, k, ivy))
   fs = dis0*(w(i, j+1, k, ivy)-w(i, j, k, ivy))
   fwd(i, j+1, k, imy) = fwd(i, j+1, k, imy) + fsd
   fw(i, j+1, k, imy) = fw(i, j+1, k, imy) + fs
   fwd(i, j, k, imy) = fwd(i, j, k, imy) - fsd
   fw(i, j, k, imy) = fw(i, j, k, imy) - fs
   ! Z-momentum.
   fsd = dis0d*(w(i, j+1, k, ivz)-w(i, j, k, ivz)) + dis0*(wd(i, &
   &            j+1, k, ivz)-wd(i, j, k, ivz))
   fs = dis0*(w(i, j+1, k, ivz)-w(i, j, k, ivz))
   fwd(i, j+1, k, imz) = fwd(i, j+1, k, imz) + fsd
   fw(i, j+1, k, imz) = fw(i, j+1, k, imz) + fs
   fwd(i, j, k, imz) = fwd(i, j, k, imz) - fsd
   fw(i, j, k, imz) = fw(i, j, k, imz) - fs
   ! Energy
   fsd = dis0d*(w(i, j+1, k, irhoe)-w(i, j, k, irhoe)) + dis0*(wd&
   &            (i, j+1, k, irhoe)-wd(i, j, k, irhoe))
   fs = dis0*(w(i, j+1, k, irhoe)-w(i, j, k, irhoe))
   fwd(i, j+1, k, irhoe) = fwd(i, j+1, k, irhoe) + fsd
   fw(i, j+1, k, irhoe) = fw(i, j+1, k, irhoe) + fs
   fwd(i, j, k, irhoe) = fwd(i, j, k, irhoe) - fsd
   fw(i, j, k, irhoe) = fw(i, j, k, irhoe) - fs
   END DO
   END DO
   END DO
   !
   !      ******************************************************************
   !      *                                                                *
   !      * Dissipative fluxes in the k-direction.                         *
   !      *                                                                *
   !      ******************************************************************
   !
   DO k=1,kl
   DO j=2,jl
   DO i=2,il
   ! Compute the dissipation coefficients for this face.
   ppor = zero
   IF (pork(i, j, k) .EQ. normalflux) ppor = half
   dis0d = fis0*ppor*(radkd(i, j, k)+radkd(i, j, k+1))
   dis0 = fis0*ppor*(radk(i, j, k)+radk(i, j, k+1))
   ! Compute and scatter the dissipative flux.
   ! Density.
   fsd = dis0d*(w(i, j, k+1, irho)-w(i, j, k, irho)) + dis0*(wd(i&
   &            , j, k+1, irho)-wd(i, j, k, irho))
   fs = dis0*(w(i, j, k+1, irho)-w(i, j, k, irho))
   fwd(i, j, k+1, irho) = fwd(i, j, k+1, irho) + fsd
   fw(i, j, k+1, irho) = fw(i, j, k+1, irho) + fs
   fwd(i, j, k, irho) = fwd(i, j, k, irho) - fsd
   fw(i, j, k, irho) = fw(i, j, k, irho) - fs
   ! X-momentum.
   fsd = dis0d*(w(i, j, k+1, ivx)-w(i, j, k, ivx)) + dis0*(wd(i, &
   &            j, k+1, ivx)-wd(i, j, k, ivx))
   fs = dis0*(w(i, j, k+1, ivx)-w(i, j, k, ivx))
   fwd(i, j, k+1, imx) = fwd(i, j, k+1, imx) + fsd
   fw(i, j, k+1, imx) = fw(i, j, k+1, imx) + fs
   fwd(i, j, k, imx) = fwd(i, j, k, imx) - fsd
   fw(i, j, k, imx) = fw(i, j, k, imx) - fs
   ! Y-momentum.
   fsd = dis0d*(w(i, j, k+1, ivy)-w(i, j, k, ivy)) + dis0*(wd(i, &
   &            j, k+1, ivy)-wd(i, j, k, ivy))
   fs = dis0*(w(i, j, k+1, ivy)-w(i, j, k, ivy))
   fwd(i, j, k+1, imy) = fwd(i, j, k+1, imy) + fsd
   fw(i, j, k+1, imy) = fw(i, j, k+1, imy) + fs
   fwd(i, j, k, imy) = fwd(i, j, k, imy) - fsd
   fw(i, j, k, imy) = fw(i, j, k, imy) - fs
   ! Z-momentum.
   fsd = dis0d*(w(i, j, k+1, ivz)-w(i, j, k, ivz)) + dis0*(wd(i, &
   &            j, k+1, ivz)-wd(i, j, k, ivz))
   fs = dis0*(w(i, j, k+1, ivz)-w(i, j, k, ivz))
   fwd(i, j, k+1, imz) = fwd(i, j, k+1, imz) + fsd
   fw(i, j, k+1, imz) = fw(i, j, k+1, imz) + fs
   fwd(i, j, k, imz) = fwd(i, j, k, imz) - fsd
   fw(i, j, k, imz) = fw(i, j, k, imz) - fs
   ! Energy
   fsd = dis0d*(w(i, j, k+1, irhoe)-w(i, j, k, irhoe)) + dis0*(wd&
   &            (i, j, k+1, irhoe)-wd(i, j, k, irhoe))
   fs = dis0*(w(i, j, k+1, irhoe)-w(i, j, k, irhoe))
   fwd(i, j, k+1, irhoe) = fwd(i, j, k+1, irhoe) + fsd
   fw(i, j, k+1, irhoe) = fw(i, j, k+1, irhoe) + fs
   fwd(i, j, k, irhoe) = fwd(i, j, k, irhoe) - fsd
   fw(i, j, k, irhoe) = fw(i, j, k, irhoe) - fs
   END DO
   END DO
   END DO
   ! Replace rho times the total enthalpy by the total energy and
   ! store the velocities again instead of the momentum. As only
   ! the first halo cells are included, this must be done here again.
   DO k=1,ke
   DO j=1,je
   DO i=1,ie
   rhoid = -(one*wd(i, j, k, irho)/w(i, j, k, irho)**2)
   rhoi = one/w(i, j, k, irho)
   wd(i, j, k, ivx) = wd(i, j, k, ivx)*rhoi + w(i, j, k, ivx)*&
   &            rhoid
   w(i, j, k, ivx) = w(i, j, k, ivx)*rhoi
   wd(i, j, k, ivy) = wd(i, j, k, ivy)*rhoi + w(i, j, k, ivy)*&
   &            rhoid
   w(i, j, k, ivy) = w(i, j, k, ivy)*rhoi
   wd(i, j, k, ivz) = wd(i, j, k, ivz)*rhoi + w(i, j, k, ivz)*&
   &            rhoid
   w(i, j, k, ivz) = w(i, j, k, ivz)*rhoi
   wd(i, j, k, irhoe) = wd(i, j, k, irhoe) - pd(i, j, k)
   w(i, j, k, irhoe) = w(i, j, k, irhoe) - p(i, j, k)
   END DO
   END DO
   END DO
   END IF
   END SUBROUTINE INVISCIDDISSFLUXSCALARCOARSE_D
