import Monad
import System

data Sheep = Sheep {name::String, mother::Maybe Sheep, father::Maybe Sheep}
--           deriving Show

instance Show Sheep where show s = show (name s)

-- traceFamily is a generic function to find an ancestor
traceFamily :: Sheep -> [ (Sheep -> Maybe Sheep) ] -> Maybe Sheep
traceFamily s l = foldM getParent s l
  where getParent s f = f s

