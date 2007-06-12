functor
export
   relation:Relation
   choose:Choose
define
   proc {Choose ?X Ys}
      choice Ys=X|_
      [] Yr in Ys=_|Yr {Choose X Yr} end
   end

   class Relation
   % impl: switch to gdbm if files will be really portable,
   % otherwise just pickle the exported record
      attr d
      meth init 
	 d := {NewDictionary}
      end 
      meth add(I)
	 if {IsDet I.1} then 
	    Is = {Dictionary.condGet @d I.1 nil} in 
	    {Dictionary.put @d I.1 {Append Is [I]}}
	 else 
	    raise databaseError(nonground(I)) end 
	 end 
      end
      meth addall(Is)
	 for I in Is do {self add(I)} end
      end
      meth query(I)
	 if {IsDet I} andthen {IsDet I.1} then 
	    {Choose I {Dictionary.condGet @d I.1 nil}}
	 else
	    {Choose I {Flatten {Dictionary.items @d}}}
	 end 
      end
      meth entries($)
	 {Dictionary.entries @d}
      end
      meth exp($) {Dictionary.toRecord 'db' @d} end
      meth imp(NRec)
	 d := {Record.toDictionary {Adjoin {self exp($)} NRec}}
      end
   end
end
