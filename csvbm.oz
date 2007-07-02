functor
export run:Run
import
   CSV at 'csv.ozf'
   T at 'testhelper.ozf'
   Open System
define
   class File from Open.text Open.file end

   fun {ParseAll F}
      fun {Loop} R in
	 case {F getS($)} of
	    false then nil
	 [] S then R={CSV.parse S} R|{Loop}
	 end
      end
   in
      {Loop}
   end

   fun {Run} F L in
      F= {New File init(name:"bm.csv" flags:[text read])}
      L={ParseAll F}
      {F close} L
   end
   
   {System.showInfo {Length {Flatten {Run}}}#" tokens"}
   {T.exit 0}
end
