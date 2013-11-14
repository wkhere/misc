defmodule Sandbox do
    def test_default_arg(a // 42) do {a} end
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
end
