defmodule Sandbox do
  def test_default_arg(a \\ 42) do {a} end
  def id(a) do a end
  def test_bind(a) do
    x = 111
    binding
  end

  defmacro mirror(body) do
    quote do
      unquote body
    end
  end

  def p(kwargs) do
    IO.inspect kwargs
  end

  def p2(arg1, kwargs) do
    IO.puts "a1=#{inspect arg1}, kw=#{inspect kwargs}"
    arg1
  end

  def p3(arg1, kwargs, body) do
    IO.puts "a1=#{inspect arg1}, kw=#{inspect kwargs}, body=#{inspect body}"
    arg1
  end

  def syntax_test do
    p(a: 1, b: 4)
    p a: 1, b: 4
    d = [x: 1, y: 2]
    d |> id
    |> p
    |> p2(y: 10, z: 1)
    |> p2(y: 10, z: 1)
    # syntax: 
    # |> p2 y: 10, z: 1
    # |> ...
    # was compilable, but the effect was like:
    # |> p2(y: 10, z: (1 |> ...))
    # so the parens are needed to stay sane.. 
    |> p2(style: "foo", content: [
      xx: 2,
      yy: 3
    ])
    |> p3(style: "bar") do
      42; 23
      # anaphoric macro here?
    end
    :ok
  end

  def tailcall_canon(0), do: :zero
  def tailcall_canon(n) do
    tailcall_canon(n-1)
  end

  def tailcall_no_way(0), do: 0
  def tailcall_no_way(n) do
    1+tailcall_no_way(n-1)
  end

  def tailcall_if(0), do: 0
  def tailcall_if(n) do
    if n > 5 do
      :over5
    else
      tailcall_if(n-1)
      # ^ disasm shows this is a tailcall
    end
  end

end
