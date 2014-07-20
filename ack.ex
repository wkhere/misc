# idea:
#   measure some parallelization with a heavy stuff like Ackermann,
#   one using simple :rpc.pmap and the other using explicit loop
#   w/ :erlang.system_info(logical_processors)
defmodule Ackermann do
  def a(0, n), do: n + 1
  def a(m, 0) when m > 0, do: a(m-1, 1)
  def a(m, n) when m > 0 and n > 0, do: a(m-1, a(m, n-1))
end
