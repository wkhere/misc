-module(port_test).
-compile(export_all).

start(Cmd) ->
    spawn(?MODULE, init, [Cmd]).

init(Cmd) ->
    process_flag(trap_exit, true),
    Port = open_port({spawn, Cmd}, [{line, 80}, in,
				    stderr_to_stdout, exit_status]),
    loop(Port).

loop(Port) ->
    receive
	stop -> Port ! {self(), close};
	{Port, Any} -> io:format("FROM PORT: ~p~n", [Any]);
	Any -> io:format("~p~n", [Any])
    end,
    loop(Port).
