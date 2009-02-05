/*
==== Io blocks vs methods

# define block with: f:=block(42)
# f evaluates to method whih you can call by: f call
Io> f type
==> Block
Io> getSlot("f") == f
==> true  # so getSlot(block) evaluates to method as well
Io> f code
==> block(42)
# now define method: m:=method(23)
# m evaluated gets called so returns 23
Io> m type
==> Number
# use getSlot to avoid call of m:
Io> getSlot("m")
==> method(
    23
)
Io> getSlot("m") type
==> Block
Io> getSlot("m") code
==> method(23)

# block->method: b setScope(newobj); newobj m := method(b call)
# method->method: newobj m := otherObj getSlot("m")

===== Io local vars
DO:
Io> m:=method(x, x1:=x+1; x1)  # setSlot on method obj, OK
==> method(x, 
    x1 := x + 1; x1
)
DON'T:
Io> m:=method(x, x1=x+1; x1)   # updateSlot on method obj, slot missing
==> method(x, 
    x1 = x + 1; x1
)
DON'T:
Io> m:=method(x, x1:=x+1, x1)  # setSlot is a parameter name
==> method(x, setSlot, 
    x1
)
To refer to object slot inside method, use self:
Movie := Object clone
Movie init := method(self cast := List clone)
Or use = with the assumption that the slot was created
http://iota.flowsnake.org/methods-and-blocks.html:
"Well, by default a message is sent to Locals, but if Locals does not
respond to it (as with "Number"), it is sent to self instead"

===== Io questions
- How to interrupt current op but don't exit the interpreter?

===== Io tokyoc experiments
# version: 1f743b89030398
- Different interpreters can't open the same tc db
- cursor reflects the changes of its db
- second db object doesn't reflect the changes even after first sync'ed (SUX)
  but its cursor works (bugs?)

==== singleton
GeorgeClooney := FamousActor clone
GeorgeClooney clone = GeorgeClooney

*/

# count := 100
# r := 100
tailCallTest := method(
  b := method(x, if(x > r, return x); b(x + 1))
  t1 := Date secondsToRun(count repeat(b(1)))
  writeln((count*r/t1) round, " recursive calls per second")
  
  b := method(x, if(x > r, return x); tailCall(x + 1))
  t2 := Date secondsToRun(count repeat(b(1)))
  writeln((count*r/t2) round, " tail calls per second")
  
  writeln("tail calls are ", (t1/t2) round, " times faster")
  t1/t2
)

# PDB usage:
# PDB path = "file"; PDB open; ...
# But objects are stored without their definition...
# Raw tokyo is more cool as it has trancactions (but for the same ux process)

