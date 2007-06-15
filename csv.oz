
declare Assert
proc {Assert P Desc}
   if P==false then {Exception.raiseError 'assert failed'} end
end 
declare DiffLNilP = fun {$ L U} U=nil L==nil end

declare Parse Parse_
fun {Parse_ I} Z in {Parse I start Z Z str} end
proc {Parse I S Acc U L ?R}
   fun {RetAcc L}
      U=nil if Acc==nil then nil else L(Acc) end
   end
in
   %todo: add states
   case I
   of nil then R={RetAcc L}
   [] &"|&"|E then Z in R= {RetAcc L}|dquote|{Parse E S Z Z L}  
   [] &"|E then Z in R= {RetAcc L}|quote|{Parse E S Z Z quoted}
   [] C|E then U1 in U=C|U1 R={Parse E S Acc U1 L}
   end
end

{Parse_ "foobar\"some thing\"\""}

declare X F
fun {F Acc} A T T1 in
   A#T=Acc
   T=q|T1
   A#T1
end

declare L1={F {F X#X}}
local A T in A#T=L1 T=nil A end

declare F fun {F X#Y} [X Y] end
{F q#e}
