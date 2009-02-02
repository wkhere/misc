% -*-oz-*-
test(a:23
     b:'foo'
     c:"foo"#"bar")

declare Soft Hard Contrast Suit
fun {Soft} choice beige [] coral end end
fun {Hard} choice mauve [] ochre end end
proc {Contrast C1 C2}
   choice C1={Soft} C2={Hard} [] C1={Hard} C2={Soft} end
end
fun {Suit}
   Shirt Pants Socks in
   {Contrast Shirt Pants}
   {Contrast Pants Socks}
   if Shirt==Socks then fail end
   sol(Shirt Pants Socks)
end

declare P
{Search.one.depth Suit 1 P}

declare X=fact(foo bar)
X.1

declare [Dict]={Module.link ['x-oz://system/adt/Dictionary.ozf']}
declare D={Dict.new}
{D.put foo quuxz}
declare R={D.toRecord 'dict'}

declare D={Dictionary.new}
{Dictionary.put D foo barbaz}
declare R={Dictionary.toRecord dict D}
{Browse R}
{Record.toDictionary R}

% Remote example
declare R F M
R={New Remote.manager init}
F=functor export x:X define X=6*7 end
M={R apply(F $)}

M.x

{R close}

{Property.get 'distribution.virtualsites'}
{Property.get 'time.run'}
{DPStatistics.siteStatistics}
{DPInit.getSettings}

% tailcall test
declare F
fun {F L A}
   %%fun {F1 L A} {F L A} end in 
   case L of nil then A
   [] X|Xs then {F Xs A+X}
   end
end

{F [1 2 3 4] 10}

declare F
fun {F N A}
   if N>1 then
      {F N-1 A+N}
   else A end
end 

{F 100 1}#c

declare Loop
proc {Loop I}
   if I==10 then skip
   else {Loop I+1}
   end
end
