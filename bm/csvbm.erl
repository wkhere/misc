-module(csvbm).
-import(csv).
-export([start/0]).

start() ->
    {ok, L} = csv:parse("bm.csv"),
    L1 = lists:flatten(L),
    N = length(L1),
    io:format("~b tokens~n", [N]),
    init:stop().
