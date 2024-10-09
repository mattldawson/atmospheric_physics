module held_suarez_wrapper

  use ccpp_kinds, only: kind_phys

interface
    subroutine held_suarez_1994_init_wrapper(pref_in, errmsg, errflg, errmsg_len) bind(C, name="held_suarez_1994_init_wrapper")
      use iso_c_binding
      implicit none
      real(c_double), intent(in) :: pref_in
      character(kind=c_char), intent(inout) :: errmsg(*)
      integer(c_int), intent(out) :: errflg
      integer(c_int), value :: errmsg_len
    end subroutine held_suarez_1994_init_wrapper
    subroutine held_suarez_1994_run_wrapper(pver, ncol, pref_mid_norm, clat, cappa, cpair, pmid, uwnd, vwnd, temp, du, dv, ds, scheme_name, errmsg, errflg, scheme_name_len, errmsg_len) bind(C, name="held_suarez_1994_run_wrapper")
      use iso_c_binding
      implicit none
      integer(c_int), intent(in) :: pver
      integer(c_int), intent(in) :: ncol
      real(c_double), intent(in) :: pref_mid_norm(pver)
      real(c_double), intent(in) :: clat(ncol)
      real(c_double), intent(in) :: cappa(ncol, pver)
      real(c_double), intent(in) :: cpair(ncol, pver)
      real(c_double), intent(in) :: pmid(ncol, pver)
      real(c_double), intent(in) :: uwnd(ncol, pver)
      real(c_double), intent(in) :: vwnd(ncol, pver)
      real(c_double), intent(in) :: temp(ncol, pver)
      real(c_double), intent(inout) :: du(ncol, pver)
      real(c_double), intent(inout) :: dv(ncol, pver)
      real(c_double), intent(inout) :: ds(ncol, pver)
      character(kind=c_char), intent(inout) :: scheme_name(*)
      character(kind=c_char), intent(inout) :: errmsg(*)
      integer(c_int), intent(out) :: errflg
      integer(c_int), value :: scheme_name_len
      integer(c_int), value :: errmsg_len
    end subroutine held_suarez_1994_run_wrapper
end interface


contains

  subroutine held_suarez_1994_init(pref_in, errmsg, errflg)

    real(kind_phys),    intent(in)  :: pref_in
    character(len=512), intent(out) :: errmsg
    integer,            intent(out) :: errflg

    call held_suarez_1994_init_wrapper(pref_in, errmsg, errflg, len(errmsg))

  end subroutine held_suarez_1994_init
  
  subroutine held_suarez_1994_run(pver, ncol, pref_mid_norm, clat, cappa, &
       cpair, pmid, uwnd, vwnd, temp, du, dv, ds, scheme_name, errmsg, errflg)

    !
    ! Input arguments
    !
    integer,  intent(in)  :: pver                    ! Num vertical levels
    integer,  intent(in)  :: ncol                    ! Num active columns
    real(kind_phys), intent(in)  :: pref_mid_norm(:) ! reference pressure normalized by surface pressure
    real(kind_phys), intent(in)  :: clat(:)          ! latitudes(radians) for columns
    real(kind_phys), intent(in)  :: cappa(:,:)       ! ratio of dry air gas constant to specific heat at constant pressure
    real(kind_phys), intent(in)  :: cpair(:,:)       ! specific heat of dry air at constant pressure
    real(kind_phys), intent(in)  :: pmid(:,:)        ! mid-point pressure
    real(kind_phys), intent(in)  :: uwnd(:,:)        ! Zonal wind (m/s)
    real(kind_phys), intent(in)  :: vwnd(:,:)        ! Meridional wind (m/s)
    real(kind_phys), intent(in)  :: temp(:,:)        ! Temperature (K)
    !
    ! Output arguments
    !
    real(kind_phys),   intent(out) :: du(:,:)   ! Zonal wind tend
    real(kind_phys),   intent(out) :: dv(:,:)   ! Meridional wind tend
    real(kind_phys),   intent(out) :: ds(:,:)   ! Heating rate
    character(len=64), intent(out) :: scheme_name
    character(len=512),intent(out):: errmsg
    integer,           intent(out):: errflg
 
    call held_suarez_1994_run_wrapper(pver, ncol, pref_mid_norm, clat, &
        cappa, cpair, pmid, uwnd, vwnd, temp, du, dv, ds, scheme_name, &
        errmsg, errflg, len(scheme_name), len(errmsg))

  end subroutine held_suarez_1994_run

end module held_suarez_wrapper