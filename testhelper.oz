% functor for testing functors
% todo: provide embedded browser
functor
export
   pr:Pr
   exit:Exit
import
   System(showInfo)
   Application(exit)
   Property(get)
define
   Pr=System.showInfo
   
   proc {Exit ExitCode}
      if {Property.get 'application.url'}\='x-oz://system/OPI.ozf' then
	 {Application.exit ExitCode}
      end
   end
end
