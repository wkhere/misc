-module(txtwindow).
-compile(export_all).
-import(lists, [reverse/1]).
-include_lib("eunit/include/eunit.hrl").

%% an attempt to port my ttytrek/window.pl

%% following 2 funs are to emulate Prolog terms, so i can copypaste
%% test case data; besides, it looks better
tok(Content, Size) -> {tok,Content,Size}.
word(Chars) -> {word,Chars}.
-compile({inline, [tok/2, word/1]}).


cw(S) ->
    cw(S, 0, [], []).

cw([], _, [], WAcc) ->
    reverse(WAcc);

cw([], I, CAcc, WAcc) ->
    LastWord = tok(word(reverse(CAcc)),I),
    reverse([ LastWord | WAcc ]);

cw([$\n|S], _, [], WAcc) ->
    cw(S, 0, [], [ tok(lf,0) | WAcc ]); 

cw([$\n|S], I, CAcc, WAcc) ->
    Word = tok(word(reverse(CAcc)),I),
    cw(S, 0, [], [ tok(lf,0), Word | WAcc ]);

cw([$ |S], _, [], WAcc) ->
    cw(S, 0, [], [ tok(spc,1) | WAcc ]);

cw([$ |S], I, CAcc, WAcc) ->
    Word = tok(word(reverse(CAcc)),I),
    cw(S, 0, [], [ tok(spc,1), Word | WAcc ]);

cw([C|S], I, CAcc, WAcc) ->
    cw(S, I+1, [C|CAcc], WAcc).


cw_test_() ->
    Spc = tok(spc,1),
    LF = tok(lf,0),
    [ ?_assertEqual( [], cw("") ),
      ?_assertEqual( [Spc], cw(" ") ),
      ?_assertEqual( [Spc,Spc], cw("  ") ),
      ?_assertEqual( [LF], cw("\n") ),
      ?_assertEqual( [LF,LF], cw("\n\n") ),
      ?_assertEqual( [tok(word("foo"),3)],
                     cw("foo") ),
      ?_assertEqual( [ tok(word("foo"),3), tok(spc,1),
                       tok(word("quux"),4) ],
                     cw("foo quux") ),
      ?_assertEqual( [ tok(word("a"),1), tok(spc,1), tok(word("b"),1),
                       tok(spc,1), tok(word("c"),1) ],
                     cw("a b c") ),
      ?_assertEqual( [ tok(word("one"),3), tok(lf,0), 
                       tok(word("two"),3) ],
                     cw("one\ntwo") ),
      ?_assertEqual( [ tok(word("ab"),2), tok(spc,1), tok(lf,0),
                       tok(word("c"),1) ],
                     cw("ab \nc") ),
      ?_assertEqual( [ tok(word("ab"),2), tok(lf,0), tok(spc,1),
                       tok(word("c"),1) ],
                     cw("ab\n c") ),
      ?_assertEqual( [ tok(word("ab"),2), tok(lf,0), tok(lf,0), tok(spc,1), 
                       tok(lf,0), tok(spc,1), tok(lf,0), tok(word("c"),1) ],
                     cw("ab\n\n \n \nc") ),
    []].
