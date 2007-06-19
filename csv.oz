
functor
export parseLine:ParseLine
define
   proc {Assert P Desc}
      if P==false then {Exception.raiseError 'assert failed'} end
   end 
   fun {DiffLNilP L U} U=nil L==nil end

   Sep=&; Quote=&"

   fun {ParseLine I} Z in {Parse I inrec Z Z} end

   proc {Parse I S Acc U ?R}
   % Acc U: an accumulator diff list
      fun {RetAcc} U=nil tok(Acc) end
      proc {DoAcc C E S} U1 in U=C|U1 R={Parse E S Acc U1} end
      proc {SkipAcc E S} R={Parse E S Acc U} end
      proc {PopAcc E} Z in R= {RetAcc}|{Parse E S Z Z} end
   in
      case S of inrec then
	 case I of nil then R={RetAcc}|nil
	 [] !Sep|E then {PopAcc E}
	 [] !Quote|!Quote|E then {DoAcc !Quote E S}
	 [] !Quote|E then {SkipAcc E quoted} 
	 [] C|E then {DoAcc C E S}
	 end
      [] quoted then
	 case I of nil then
	    raise csvParseError('missing closing quote for token' {String.toAtom {RetAcc}}) end
	 [] !Quote|!Quote|E then {DoAcc !Quote E S}
	 [] !Quote|E then {SkipAcc E inrec}
	 [] C|E then {DoAcc C E S}
	 end
      end
   end
% todo: 
% - parser accepts fields loosely wrt. to quote start, ie. field can be:
%   <SEP>sth "some quote" sth else<SEP>
% - tinker tail-calls

   Test1 = {ParseLine ";;foo bar; ouch ;1 2\" 2;\"4;double \"\" inside; next;;\"quoted\";;;\"double \"\" inside quotes\" and sided;42"}
end
