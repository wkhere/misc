
declare Assert
proc {Assert P Desc}
   if P==false then {Exception.raiseError 'assert failed'} end
end 
declare DiffLNilP = fun {$ L U} U=nil L==nil end

declare Sep=&; Quote=&" Parse Parse_
fun {Parse_ I} Z in {Parse I inrec str Z Z} end
proc {Parse I S L Acc U ?R}
   % Acc U: an accumulator diff list
   fun {RetAcc L} U=nil Acc end
   proc {DoAcc C E S} U1 in U=C|U1 R={Parse E S L Acc U1} end
   proc {SkipAcc E S} R={Parse E S L Acc U} end
in
   case S of inrec then
      case I of nil then R={RetAcc L}
      [] !Sep|E then Z in R= tok({RetAcc L})|{Parse E S L Z Z}
      [] !Quote|!Quote|E then {DoAcc !Quote E S}
      [] !Quote|E then {SkipAcc E quoted} 
      [] C|E then {DoAcc C E S}
      end
   [] quoted then
      case I of nil then
	 raise csvParseError('missing closing quote for token' {String.toAtom {RetAcc L}}) end
      [] !Quote|!Quote|E then {DoAcc !Quote E S}
      [] !Quote|E then {SkipAcc E inrec}
      [] C|E then {DoAcc C E S}
      end
   end
end
% todo: above works only if input ends with separator
% it also accepts fields loosely wrt. to quote start, ie. field can be:
%   <SEP>sth "some quote" sth else<SEP>

{Parse_ ";;foo bar; ouch ;1 2\" 2;\"4;double \"\" inside; next;;\"quoted\";;;\"double \"\" inside quotes\" and sided;"}

