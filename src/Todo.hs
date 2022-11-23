{-# LANGUAGE GADTs #-}
module Todo where
import Data.Time
import Data.Either.Combinators (maybeToRight)
import Data.Map

newtype DueDate = DueDate UTCTime deriving (Eq,Show,Ord)

newtype Description = Description String deriving (Eq,Show)

data Input = Input String (Maybe String) deriving (Eq,Show)
data Todo = Todo Description (Maybe DueDate) deriving (Eq,Show)


persist :: Todo -> IO () 
persist = undefined

data Error = DescriptionEmpty | PastDueDate | InvalidDateFormat deriving (Eq,Show) 

serialise :: Error -> String 
serialise = show 

render :: Error -> IO ()
render = putStrLn . serialise 

parse :: UTCTime -> Input -> Either Error Todo 
--parse (Input [] _ ) = Left DescriptionEmpty
--parse (Input d Nothing) = Right (Todo (Description d) Nothing) 
--parse (Input d (Just s)) =  undefined 
parse now = undefined 

parseDate :: String -> Maybe UTCTime
parseDate = undefined

data Action = Persist Todo | Render Error  | GetCurrentTime (UTCTime -> Action)  

run :: Action -> IO () 
run (Persist t) = persist t 
run (Render e) = render e 
run (GetCurrentTime f) = getCurrentTime >>= run . f 

program' :: Input -> Action
program' input = 
   GetCurrentTime (\ now -> 
    case parse now input of 
     Right todo -> Persist todo  
     Left e -> Render e )

program :: Input -> IO ()
program = run . program' 

original :: Input -> IO ()
original input = 
   getCurrentTime >>= (\ now -> 
    case parse now input of 
     Right todo -> persist todo  
     Left e -> render e )

