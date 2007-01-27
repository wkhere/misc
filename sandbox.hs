module Foo where

import Data.IORef
import Control.Exception (finally)
import Control.Concurrent
import Control.Concurrent.MVar

-- IORef test:
test1_1 :: IO ()
test1_1 = newIORef 0 >>= \v-> readIORef v >>= 
          \a1-> writeIORef v 42 >> readIORef v >>= \a2-> print (a1,a2)
-- the same using do:
test1_2 :: IO ()
test1_2 = do v <- newIORef 0
             a1 <- readIORef v
             writeIORef v 42
             a2 <- readIORef v
             print (a1,a2)

test2 :: IO ()
test2 = do
  eot <- newEmptyMVar
  mV <- newEmptyMVar :: IO (MVar Int)
  print "obtained empty mV"
  th <- forkIO $ consumer mV `finally` putMVar eot () >> print "EOT"
  print $ "got thread "++(show th)
  putMVar mV 42
  print "have put a value"
  takeMVar eot
  --killThread th
  print "test finished."
    where
      consumer v = do x <- takeMVar v
                      print $ "consumer got:" ++ (show x)
                      print "consumer will finish"



