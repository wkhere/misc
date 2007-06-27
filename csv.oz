
functor
export parse:Parse
   sep:SepC quote:QuoteC
import
   T at 'testhelper.ozf'
define

   SepC={NewCell &,} QuoteC={NewCell &"}

   fun {Parse I} 
      Sep=@SepC Quote=@QuoteC
      proc {DoParse I S Acc U ?R}
      % Acc U: an accumulator diff list
	 fun {RetAcc} U=nil tok(Acc) end
	 proc {DoAcc C E S} U1 in U=C|U1 R={DoParse E S Acc U1} end
	 proc {SkipAcc E S} R={DoParse E S Acc U} end
	 proc {PopAcc E} Z in R= {RetAcc}|{DoParse E S Z Z} end
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
      Z in {DoParse I inrec Z Z} 
   end
% todo: 
% - parser accepts fields loosely wrt. to quote start, ie. field can be:
%   <SEP>sth "some quote" sth else<SEP>
% - tinker tail-calls

   % the following is for crude testing support
   Tests = [
	    {Parse nil} == [tok(nil)]
	    {Parse ""} == [tok(nil)]
	    {Parse ","} == [tok(nil) tok(nil)]
	    {Parse ",,foo bar, ouch ,1 2\" 2,\"4,double \"\" inside, next,,\"quoted\",,,\"double \"\" inside quotes\" and sided,42"} ==
	    [tok(nil) tok(nil) tok("foo bar") 
	     tok(" ouch ") tok("1 2 2,4") 
	     tok("double \" inside") 
	     tok(" next") tok(nil) tok("quoted") tok(nil) tok(nil) 
	     tok("double \" inside quotes and sided") tok("42")]
	   ]
   Pr=T.pr
   {ForAll Tests proc {$ TC}
		    {Pr "test="#(if TC then "t" else "f" end)} end}
   {T.exit 0}
end
