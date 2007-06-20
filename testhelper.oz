% functor for testing functors
% todo: provide embedded browser
functor
export
   pr:Pr
   br:Br brClose:BrClose
   exit:Exit
import
   System(showInfo)
   Application(exit)
   Property(get)
   Browser
   Tk
define
   W = {New Tk.toplevel tkInit(bg:ivory)}
   {Tk.send wm(geometry W "500x300")}
   Ret F = {New Tk.frame tkInit(parent:W
			      bd:3
			      bg:white
			      relief:groove
			      %return:Ret
			     )}
   {Tk.send pack(F fill:both padx:0 pady:0 expand:true)}
   B = {New Browser.'class' init(origWindow:F)}
   {B option(representation strings:true)}
   {B option(layout size:10)}
   {B createWindow}
   Br = proc {$ X} {B browse(X)} end
   Pr = System.showInfo

   proc {BrClose}
      {B close}
      %{F close}
   end
   proc {Exit ExitCode}
      if {Property.get 'application.url'}\='x-oz://system/OPI.ozf' then
	 {BrClose}
	 {Application.exit ExitCode}
      end
   end
end
