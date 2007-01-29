import System (getArgs)
import System.IO
import Control.Monad (when)
import Text.Printf (printf)
import Char (ord, chr)
import Data.Bits (xor)

test :: Handle -> IO ()
test h = do
  sz <- hFileSize h
  printf "file size: %d\n" sz
  hIsSeekable h >>= printf "seekable? %s\n" . show
  printf "seek at 0: "
  hSeek h AbsoluteSeek 0 >> ptell
  printf "seek at 5g: "
  hSeek h AbsoluteSeek 5000000000 
  p <- ptell
  when (sz > p) $ do  
           printf "oh, previous size is greater; seek to end: "
           hSeek h SeekFromEnd 0 >> ptell; return ()
  let c = 'x'
  printf "write \"%c\" here: " c
  hPutChar h c >> printf "OK " >> ptell
  printf "peek it back: "
  hSeek h RelativeSeek (-1)
  c1 <- hLookAhead h
  printf "0x%02x, is this expected? %s, " c (show $ c==c1) >> ptell
  hFileSize h >>= printf "finally, file size is: %d\n" 
  where
    ptell :: IO Integer
    ptell =
        do pos <- hTell h; printf "pos=%d\n" pos; return pos
    change :: Char -> Char
    change c = chr $ ord c `xor` 42

main :: IO ()
main =
    getArgs >>= \x -> openBinaryFile (head x) ReadWriteMode >>= test
