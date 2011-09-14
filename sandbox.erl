-module(sandbox).
-compile(export_all).
-compile({parse_transform, ct_expand}).

long_string() ->
    "OM MANI PEME 

    HUNG
    ".
long_string_ct() ->
    ct_expand:term( 
    "OM MANI PEME 

    HUNG
    ").
%% Same asm as above - ct_expand didn't need to call anything.


compiled_regex() -> re:compile("foo(bar)?").
compiled_regex_ct() -> ct_expand:term(re:compile("foo(bar)?")).
%% Here we have difference - ct stored regex compilation output as a
%% function body.

