module Todo where
import Data.Time
import Data.Either.Combinators (maybeToRight)


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

-- fmap :: Functor f => (a -> b) -> f a -> f b 

defaultNow :: UTCTime
defaultNow = undefined 


data Action = Persist Todo | Render Error   
data SourceAction  = GetCurrentTime 

runSource :: SourceAction -> IO UTCTime
runSource GetCurrentTime = getCurrentTime

run :: Action -> IO () 
run (Persist t) = persist t 
run (Render e) = render e 


program' :: Input -> Action 
program' input = 
   case parse defaultNow input of 
     Right todo -> Persist todo 
     Left e -> Render e 

program :: Input -> IO ()
program = run . program' 


