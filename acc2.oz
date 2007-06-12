declare [Rel RE] = {Module.link ['reldb.ozf' 'x-oz://contrib/regex']}

declare CompleteAc
fun {CompleteAc R0} R in
   if {Label R0}\=ac then
      raise badarg(invalid record) end
   end
   R = {AdjoinList R0
	[invoiceno#na recDate#na cost#none comment#""]}
   if false=={All [1 value charged chargeDate desc]
	      fun {$ X} {HasFeature R X} end}
   then
      raise badarg(missing mandatory feature) end
   end
   R
end

declare Acs={New Rel.relation init}

{Acs addall( [Ac1 Ac2 Ac3] )}
{Acs exp($)}
%{Acs imp(db(1:nil 42:[scratch] 23:[fact(23 is magic too)]))}
{Acs entries($)}
{Acs init}

declare
Ac1= {CompleteAc
      ac('20070430' value:18666.0 charged:true
	 chargeDate:'20070531' desc:"Outbox za 04"
	 invoiceno:"CO/??/2007")}
Ac2= {CompleteAc
      ac('20070610' value:~817.07 charged:true
	 chargeDate:'20070610' desc:"ZUS")}
Ac3= {CompleteAc
      ac('20070510' value:~817.07 charged:true
	 chargeDate:'20070510' desc:"ZUS")}

declare AcP
proc {AcP ID V CP CD Dsc IN RD C Aux}
   {Acs query(
	   ac(1:ID value:V charged:CP chargeDate:CD desc:Dsc
	      invoiceno:IN recDate:RD cost:C comment:Aux))}
end

declare Re1={RE.make "^Outbox"}

%declare Q1 =
{SearchAll
 proc {$ ?X} I V D in
    %I='20070510'
    {AcP I V _ _ D _ _ _ _}
    V>0.0 =true
    %{List.take D 6}="Outbox"
    {RE.search Re1 D}\=false =true
    X=sol(I V D)
 end}

{SearchAll Q1}
{ExploreAll Q1}

