program test_held_suarez
  !use held_suarez_1994
  use held_suarez_wrapper

  implicit none

  ! Run the tests
  call test_initialize_held_suarez()
  call test_update_held_suarez()

contains

  subroutine test_initialize_held_suarez
    use ccpp_kinds, only: kind_phys

    ! Declare variables
    real(kind_phys) :: pref_in
    character(len=512) :: errmsg
    integer :: errflg

    ! Test case 1: Normal input
    pref_in = 1000.0
    call held_suarez_1994_init(pref_in, errmsg, errflg)
    print *, 'Test case 1:'
    print *, '  pref_in = ', pref_in
    print *, '  errmsg  = ', trim(errmsg)
    print *, '  errflg  = ', errflg
    if (errflg /= 0) then
        print *, '  Test case 1 failed: errflg should be 0'
    else
        print *, '  Test case 1 passed'
    end if

    ! Test case 2: Edge case input (e.g., zero pressure)
    pref_in = 0.0
    call held_suarez_1994_init(pref_in, errmsg, errflg)
    print *, 'Test case 2:'
    print *, '  pref_in = ', pref_in
    print *, '  errmsg  = ', trim(errmsg)
    print *, '  errflg  = ', errflg
    if (errflg /= 0) then
        print *, '  Test case 2 failed: errflg should be 0'
    else
        print *, '  Test case 2 passed'
    end if

  end subroutine test_initialize_held_suarez

  subroutine test_update_held_suarez
    use ccpp_kinds, only: kind_phys
    implicit none

    ! Declare variables
    integer :: pver, ncol
    real(kind_phys), allocatable :: pref_mid_norm(:)
    real(kind_phys), allocatable :: clat(:)
    real(kind_phys), allocatable :: cappa(:,:)
    real(kind_phys), allocatable :: cpair(:,:)
    real(kind_phys), allocatable :: pmid(:,:)
    real(kind_phys), allocatable :: uwnd(:,:)
    real(kind_phys), allocatable :: vwnd(:,:)
    real(kind_phys), allocatable :: temp(:,:)
    real(kind_phys), allocatable :: du(:,:)
    real(kind_phys), allocatable :: dv(:,:)
    real(kind_phys), allocatable :: ds(:,:)
    character(len=64) :: scheme_name
    character(len=512) :: errmsg
    integer :: errflg

    ! Initialize test data
    pver = 3
    ncol = 2

    allocate(pref_mid_norm(pver))
    allocate(clat(ncol))
    allocate(cappa(ncol, pver))
    allocate(cpair(ncol, pver))
    allocate(pmid(ncol, pver))
    allocate(uwnd(ncol, pver))
    allocate(vwnd(ncol, pver))
    allocate(temp(ncol, pver))
    allocate(du(ncol, pver))
    allocate(dv(ncol, pver))
    allocate(ds(ncol, pver))

    ! Fill test data with some values
    pref_mid_norm = [0.9, 0.5, 0.1]
    clat = [0.0, 0.5]
    cappa = reshape([0.286, 0.286, 0.286, 0.286, 0.286, 0.286], shape(cappa))
    cpair = reshape([1004.0, 1004.0, 1004.0, 1004.0, 1004.0, 1004.0], shape(cpair))
    pmid = reshape([900.0, 500.0, 100.0, 900.0, 500.0, 100.0], shape(pmid))
    uwnd = reshape([10.0, 5.0, 2.0, 10.0, 5.0, 2.0], shape(uwnd))
    vwnd = reshape([5.0, 2.5, 1.0, 5.0, 2.5, 1.0], shape(vwnd))
    temp = reshape([290.0, 280.0, 270.0, 290.0, 280.0, 270.0], shape(temp))

    ! Call the subroutine
    call held_suarez_1994_run(pver, ncol, pref_mid_norm, clat, cappa, cpair, pmid, uwnd, vwnd, temp, du, dv, ds, scheme_name, errmsg, errflg)

    ! Print results
    print *, 'scheme_name = ', trim(scheme_name)
    print *, 'errmsg = ', trim(errmsg)
    print *, 'errflg = ', errflg
    print *, 'du = ', du
    print *, 'dv = ', dv
    print *, 'ds = ', ds

    ! Check results (add your own checks here)
    if (errflg /= 0) then
        print *, 'Test failed: errflg should be 0'
    else
        print *, 'Test passed'
    end if

    ! Deallocate arrays
    deallocate(pref_mid_norm)
    deallocate(clat)
    deallocate(cappa)
    deallocate(cpair)
    deallocate(pmid)
    deallocate(uwnd)
    deallocate(vwnd)
    deallocate(temp)
    deallocate(du)
    deallocate(dv)
    deallocate(ds)
  end subroutine test_update_held_suarez

end program test_held_suarez
