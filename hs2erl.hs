module Hs2Erl where
import Foreign.Erlang

x = 42

run mynode othernode = do
   self <- createSelf mynode
   mbox <- createMBox self
   res <- rpcCall mbox othernode "erlang" "node" []
   return res

-- unfortunately it doesn't work.. wtf?
-- todo: contact maintainer

main = run "hs@localhost" "x0@xray" >>= print

