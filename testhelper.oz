% functor for testing functors
% todo: provide embedded browser
functor
export
   assert:Assert
   diffLNilP:DiffLNilP
   pr:Pr
   exit:Exit
import
   System(showInfo)
   Application(exit)
   Property(get)
define
   proc {Assert P Desc}
      if P==false then {Exception.raiseError 'assert failed'} end
   end 

   fun {DiffLNilP L U} U=nil L==nil end

   Pr=System.showInfo
   
   proc {Exit ExitCode}
      if {Property.get 'application.url'}\='x-oz://system/OPI.ozf' then
	 {Application.exit ExitCode}
      end
   end
end
