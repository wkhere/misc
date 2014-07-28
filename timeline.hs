module Main where
import Text.ParserCombinators.Parsec
import Text.Printf

eot = eof >> return ' '
--eol = newline <|> (eof >> return ' ')
--tilEol = manyTill (noneOf "\n") eol 

p = do
  dateS <- manyTill (noneOf ":") (char ':')
  skipMany $ oneOf " \t"
  t11 <- count 2 digit
  char ':'
  t12 <- count 2 digit
  spaces
  char '-'
  spaces
  t21 <- count 2 digit 
  char ':'
  t22 <- count 2 digit 
  char '=' <|> space <|> eot
  return $ concat [dateS, ": ", t11, ":", t12, "-", t21, ":", t22, " = ", 
                   hrDesc (toMins t11 t12) (toMins t21 t22),
                   "h"]
    where
      toMins c1 c2 = (read c1::Integer)*60 + (read c2::Integer)
      hrDesc t1 t2 = 
          chop0 $ printf "%.2f" ((fromInteger(tmDiff t1 t2)/60)::Float)
          where
            chop0 s = reverse $
                      dropWhile (=='.') $ dropWhile (=='0') $ reverse s
            tmDiff t1 t2 = if t1 < t2 then t2-t1
                           else t2+24*60-t1

doParseLine = runParser p () ""

procLine :: String -> String
procLine s =
    case (doParseLine s) of
      Left e -> s -- ignore the error, output line as it was
      Right s1 -> s1
      
main = interact (unlines . (map procLine) . lines)
