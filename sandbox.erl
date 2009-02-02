-module(sandbox).
-compile(export_all).

foo(X) ->
  1+X.

dumbrecv() ->
    receive 
	X -> io:format("!got ~p~n",[X])
    end.         

%% list comprehension example:

search_strings(StringList, S) ->
    [ X || X<-StringList, P<-[string:str(X,S)], P>0]. 

search_codepath(S) ->
    search_strings(code:get_path(), S).

search_codepath() ->
    search_codepath("/misc").

