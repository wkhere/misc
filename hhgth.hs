
-- Mostly taken from 
-- http://www.haskell.org/haskellwiki/Hitchhikers_guide_to_Haskell

module HhgtH where
import Text.ParserCombinators.Parsec

myparse = do
  dirs <- many dirAndSize
  eof
  return dirs

data Dir = Dir Int String deriving Show

dirAndSize =
    do size <- many1 digit
       spaces
       dirName <- anyChar `manyTill` newline
       return (Dir (read size) dirName)

main = do input <- getContents
          let dirs = case parse myparse "stdin" input of
                       Left err -> error $ "input:\n" ++ show input ++
                                   "\nerror:\n" ++ show err
                       Right res -> res
          print dirs
