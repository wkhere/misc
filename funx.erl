-module(funx).
-compile(export_all).

f(Fun) when is_function(Fun,1) ->
    fun()-> Fun(Fun) end.

spawnf(Fun) ->
    spawn(f(Fun)).

