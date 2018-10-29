module types

  use constant
  
  implicit none
  
  type :: nodeStruct
     real(dp) :: x,y
     integer, dimension(4) :: connect
  end type nodeStruct

  type :: edgeStruct
     integer :: node1,node2
     integer :: neigh
     integer :: normal    !1=left 2=bottom 3=right 4=top
     character(len=20) :: boundType
     real(dp), dimension(:), allocatable :: bound
  end type edgeStruct

  type :: cellStruct
     real(dp) :: dx,dy
     real(dp) :: xc,yc
     type(edgeStruct), dimension(:), allocatable :: edge
  end type cellStruct
  
  type :: meshStruct
     integer :: np,nc
     type(nodeStruct), dimension(:), allocatable :: node
     type(cellStruct), dimension(:), allocatable :: cell
  end type meshStruct

  type :: solStruct
     integer :: nvar,nsolUser
     character(len=20), dimension(:), allocatable :: name,nameUser
     real(dp), dimension(:,:), allocatable :: val,user
  end type solStruct

  abstract interface
     
     subroutine sub_f (u,f)
       use constant
       real(dp), dimension(:), intent(in) :: u
       real(dp), dimension(:,:), intent(inout) :: f
     end subroutine sub_f
     
     subroutine sub_flux (u1,u2,f_equa,dir,F,Smax)
       use constant
       real(dp), dimension(:), intent(in) :: u1,u2
       procedure (sub_f), pointer, intent(in) :: f_equa
       integer, intent(in) :: dir
       real(dp), dimension(:), intent(inout) :: F
       real(dp), intent(out) :: Smax
     end subroutine sub_flux

     subroutine sub_time (mesh,sol,f_ptr,flux_ptr,order,cfl,t)
       use constant
       import meshStruct
       import solStruct
       type(meshStruct), intent(in) :: mesh
       type(solStruct), intent(inout) :: sol
       procedure (sub_f), pointer, intent(in) :: f_ptr
       procedure (sub_flux), pointer, intent(in) :: flux_ptr
       integer, intent(in) :: order
       real(dp), intent(in) :: cfl
       real(dp), intent(inout) :: t
     end subroutine sub_time

     subroutine sub_fquadra (x,y,t,s)
       use constant
       real(dp), intent(in) :: x,y,t
       real(dp), intent(out) :: s
     end subroutine sub_fquadra
     
  end interface

end module types
