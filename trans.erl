-module(trans).
-compile(export_all).

init() ->
    init([]).

init(Troops) ->
    put(troops, Troops),
    loop().

loop() ->
    %% ...
    ok.

add_troop(Mod) ->
    L = get(troops),
    put(troops, Mod|L).

send(Module, Node) ->
    {Mod, Bin, Filename} = code:get_object_code(Module),
    Filedesc = io_lib:write(node()) ++ ":" ++ Filename,    
    %% todo: cipher Filedesc
    {module, Mod} = rpc:call(Node, code, load_binary, [Mod, Filedesc, Bin]),
    %%rpc:call(Node, c, m, [Mod]),
    {sent, Mod}.
