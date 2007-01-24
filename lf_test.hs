import System
import System.IO
import Text.Printf

main =
    getArgs >>= \x -> openFile (head x) ReadMode >>= hFileSize 
    >>= printf "hFileSize=%d\n"
