-module(mnesia2).
-compile(export_all).

view_backup(File) ->
    View = fun(X, Acc) ->
		   io:format("~p~n",[X]),
		   {[X], 1+Acc}
	   end,
    mnesia:traverse_backup(File, mnesia_backup, dummy, read_only, View, 0).


unique_string() ->
    {A,B,C} = now(),
    io_lib:format("~p~p~p",[A,B,C]).

mvnode(Node1) ->
    mvnode(Node1, "/tmp/backup_" ++ atom_to_list(Node1) 
        ++ "." ++ unique_string()).

mvnode(Node1, To_file) ->
    mvnode(node(), Node1, To_file).

mvnode(Node0, Node1, To_file) ->
    mvnode(Node0, Node1, To_file++".orig", To_file).

mvnode(Node0, Node1, From_file, To_file) ->
    mnesia:backup(From_file),
    mvnode_from_backup(Node0, Node1, From_file, To_file).

mvnode_from_backup(Node0, Node1, From_file, To_file) ->
    {ok,_} = mvnode_in_backup(mnesia_backup, Node0, Node1, From_file, To_file),
    {ok, {target_backup, list_to_binary(To_file)}}.
%% btw to restore backup on a virgin node i can use
%% mnesia:install_fallback in the stopped state then use
%% mnesia:restore (untested if backup describes multi-node db)


mvnode_in_backup(Mod, From, To, Source, Target) ->
    Switch =
        fun(Node) when Node == From -> To;
           (Node) when Node == To -> throw({error, already_exists});
           (Node) -> Node
        end,
    Convert =
        fun({schema, db_nodes, Nodes}, Acc) ->
                {[{schema, db_nodes, lists:map(Switch,Nodes)}], Acc};
           ({schema, version, Version}, Acc) ->
                {[{schema, version, Version}], Acc};
           ({schema, cookie, Cookie}, Acc) ->
                {[{schema, cookie, Cookie}], Acc};
           ({schema, Tab, CreateList}, Acc) ->
                Keys = [ram_copies, disc_copies, disc_only_copies],
                OptSwitch =
                    fun({Key, Val}) ->
                            case lists:member(Key, Keys) of
                                true -> {Key, lists:map(Switch, Val)};
                                false-> {Key, Val}
                            end
                    end,
                {[{schema, Tab, lists:map(OptSwitch, CreateList)}], Acc};
           (Other, Acc) ->
                {[Other], Acc}
        end,
    mnesia:traverse_backup(Source, Mod, Target, Mod, Convert, switched).
