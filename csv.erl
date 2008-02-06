-module(csv).
-import(lists, [reverse/1]).
-export([parse/1, parse/2]).
%-compile(export_all). %tmp
-record(opts, {sep, quote, token_trans}).
-define(default_quote, $\").
-define(default_sep, $\,).

complement_opts(Opts) ->
    Default = {opts, ?default_sep, ?default_quote, fun(A)->A end},
    F = fun(Idx)-> 
		E=element(Idx, Opts),   
		case E of undefined -> element(Idx, Default);
		    _ -> E end
	end,
    list_to_tuple(lists:map(F, lists:seq(1, record_info(size, opts)))).


parse(X) ->
    parse(X, #opts{}).

parse(Filename, Opts) when is_list(Filename) ->
    {ok, Bin} = file:read_file(Filename),
    parse(Bin, Opts);

parse(Bin, Opts) when is_binary(Bin) ->
    parse(Bin, [], [], [], complement_opts(Opts)).

parse(<<Sep, Rest/binary>>, Field, Line, Acc, 
      #opts{sep=Sep, token_trans=F} = Opts) ->
    Token = F(reverse(Field)),
    parse(Rest, [], [Token|Line], Acc, Opts);

parse(<<$\n, Rest/binary>>, Field, Line, Acc, 
      #opts{token_trans=F} = Opts) ->
    Token = F(reverse(Field)),
    Tokens = [Token|Line],
    parse(Rest, [], [], [reverse(Tokens)|Acc], Opts);

parse(<<$\r,$\n, Rest/binary>>, Field, Line, Acc, Opts) ->
    parse(<<$\n, Rest>>, Field, Line, Acc, Opts);

parse(<<Quote, Rest/binary>>, Field, Line, Acc, 
      #opts{quote=Quote} = Opts) ->
    parseq(Rest, Field, Line, Acc, Opts);

parse(<<Char, Rest/binary>>, Field, Line, Acc, Opts) ->
    parse(Rest, [Char|Field], Line, Acc, Opts);

parse(<<>>, [], [], Acc, _) ->
    {ok, reverse(Acc)};

parse(<<>>, Field, Line, Acc, Opts) ->
    parse(<<$\n>>, Field, Line, Acc, Opts).


parseq(<<Quote, Quote, Rest/binary>>, Field, Line, Acc, 
       #opts{quote=Quote} = Opts) ->
    parseq(Rest, [Quote|Field], Line, Acc, Opts);

parseq(<<Quote, Rest/binary>>, Field, Line, Acc, 
       #opts{quote=Quote} = Opts) ->
    parse(Rest, Field, Line, Acc, Opts);

parseq(<<Char, Rest/binary>>, Field, Line, Acc, Opts) ->
    parseq(Rest, [Char|Field], Line, Acc, Opts).

% todo: test cases
