module Foo where

import System.Time
import Data.IORef
import Control.Exception (finally)
import Text.ParserCombinators.Parsec
import qualified Data.ByteString.Char8 as C
import Control.Monad
import Control.Concurrent
import Control.Concurrent.MVar

ack :: Int->Int->Int
ack 0 n = n+1
ack m 0 = ack (m-1) 1
ack m n = ack (m-1) (ack m (n-1))

maxx x y
    | x > y = x
    | otherwise = y

fiblist = 0 : 1 : (zipWith (+) fiblist (tail fiblist))
faclist = 1 : (zipWith (*) [1..] faclist)

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


-- simple test of record copying - just for remembering
test3 :: IO ()
test3 = do t0 <- getClockTime >>= toCalendarTime
           let t1 = t0 { ctYear = 2100 } 
           let t2 = t0 { ctYear = ctYear t0 + 100 }
           sequence_ $ map (print.ctYear) [t0,t1,t2]

--  let setRec r field f = r { field=f (field r) }

-- now let's experiment with conversions ClockTime <-> CaledarTime
test4 :: IO ()
test4 = do t0 <- getClockTime
           t1 <- liftM toClockTime $ toCalendarTime t0
           let t2 = toClockTime $ toUTCTime t0
           print (t0, t1, t2, t0==t1, t0==t2)
           -- ...

