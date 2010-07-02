{-# OPTIONS -fglasgow-exts #-}
module Sandbox where

import System.IO
import System.Time
import Data.IORef
import Control.Exception (finally)
import Text.ParserCombinators.Parsec
import qualified Data.ByteString.Char8 as C
import Control.Monad
import Control.Concurrent
import Control.Concurrent.MVar
import Control.Concurrent.STM
import Control.Concurrent.STM.TVar
import Control.Concurrent.STM.TMVar
import Test.QuickCheck

{- IO () tests here can be run from ghci or compiled using:
   ghc --make  -fforce-recomp -main-is Sandbox.<func> <src>
 -}

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
testRef0 :: IO ()
testRef0 = newIORef 0 >>= \v-> readIORef v >>= 
          \a1-> writeIORef v 42 >> readIORef v >>= \a2-> print (a1,a2)
-- the same using do:
testRef :: IO ()
testRef = do v <- newIORef 0
             a1 <- readIORef v
             writeIORef v 42
             a2 <- readIORef v
             print (a1,a2)

testMVar :: IO ()
testMVar = do
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

-- similar test for STM, now we can wait for a given value!
{- AFAIK 'eot' doesn't have to be TMVar, may be just independent mutex 
   outside the STM, as plain MVar. Version with TMVars is here too, commented.
 -}
testTVar :: IO ()
testTVar = do
  v <- atom $ newTVar 0
  p "forking"
  (th,finish) <- fork (consumer v)
  p $ "got thread "++(show th)
  yield; threadDelay 1000
  p "setting value for consumer"
  atom $ writeTVar v 42
  p "value for consumer set"
  finish
  p "test finished."
    where 
      consumer v = do
             p "consumer: waiting for value"
             x <- atom $ do
                     x <- readTVar v
                     if x==0 then retry else return x
             p $ "consumer: got value "++(show x)
             p "consumer: will finish"
      -- helpers:
      atom = atomically
      p s = do print s; System.IO.hFlush stdout
      fork :: IO () -> IO (ThreadId, IO ())
      fork task = do
             eot <- prefork
             tid <- forkIO $ task `finally` commit eot >> p "EOT"
             return (tid, (unfork eot))
          where
            prefork = newEmptyMVar
            commit eot = putMVar eot ()
            unfork = takeMVar
            --prefork = atom $ newEmptyTMVar
            --commit eot = atom $ putTMVar eot ()
            --unfork eot = atom $ takeTMVar eot

-- play with time - example of record copying - just for remembering
testTime1 :: IO ()
testTime1  = do 
           t0 <- getClockTime >>= toCalendarTime
           let t1 = t0 { ctYear = 2100 } 
           let t2 = t0 { ctYear = ctYear t0 + 100 }
           sequence_ $ map (print.ctYear) [t0,t1,t2]

--  let setRec r field f = r { field=f (field r) }

-- now let's experiment with conversions ClockTime <-> CaledarTime
testTime2 :: IO ()
testTime2 = do 
           t0 <- getClockTime
           t1 <- liftM toClockTime $ toCalendarTime t0
           let t2 = toClockTime $ toUTCTime t0
           print (t0, t1, t2, t0==t1, t0==t2)
           -- ...

-- now for sth completely different

data Foo = Foo Int deriving (Eq,Show)

lift1 f (Foo x) = Foo (f x)
lift2 f (Foo x) (Foo y) = Foo (f x y)

instance Num Foo where
    fromInteger = Foo . fromInteger
    (+) = lift2 (+)
    (*) = lift2 (*)
    negate = lift1 negate
    signum = lift1 signum
    abs = lift1 abs

prop_foo_numop op xs = foldr (lift2 op) 0 (map Foo xs)
                       == Foo (foldr op 0 xs)

testFoo :: IO ()
testFoo = do 
  mapM (quickCheck . prop_foo_numop) [(+), (*)]
  return ()
