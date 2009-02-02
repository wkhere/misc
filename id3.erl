-module(id3).
-import(lists, [reverse/1, map/2]).
-compile(export_all).

read(File) ->
    case file:open(File, [read, binary, raw]) of
	{ok, IO} ->
	    Size = filelib:file_size(File),
	    {ok, Bin} = file:pread(IO, Size - 128, 128),
	    Res = parse(Bin),
	    file:close(IO),
	    Res;
	Error ->
	    {File, Error}
    end.

parse(<<"TAG", Title:30/binary,
       Artist:30/binary, Album:30/binary,
       Year:4/binary, Comment:28/binary,
       0:8, Track:8, _Genre:8>>) ->
    {ok,
     {'ID3v11',
      [{track, Track},
       {title, trim(Title)},
        {artist, trim(Artist)}, {album, trim(Album)},
	{year, Year}, {comment, trim(Comment)}
       ]}};

parse(<<"TAG", Title:30/binary,
       Artist:30/binary, Album:30/binary,
       Year:4/binary, Comment:30/binary,
       _Genre:8>>) ->
    {ok,
      {'ID3v1',
       [{title, trim(Title)},
        {artist, trim(Artist)}, {album, trim(Album)},
	{year, Year}, {comment, trim(Comment)}
       ]}};

 parse(_) ->
     error.

trim(Bin) ->
     list_to_binary(trimws(binary_to_list(Bin))).

trimws(L) ->
    reverse(skipws(reverse(L))).

skipws([$\s|T]) ->
    skipws(T);
skipws([0|T]) ->
    skipws(T);
skipws(L) -> L.
