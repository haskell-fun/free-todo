module Todo (program, program', Todo(..), Input(..), Error(..), parse) where
import Data.Time ( getCurrentTime, UTCTime )
import Data.Map ()
import Data.List.NonEmpty ( NonEmpty, nonEmpty )
import Data.Either.Combinators ( maybeToRight )
import Control.Monad (void,mfilter)
import Data.Time.ISO8601 ( parseISO8601 )

type NonEmptyString = NonEmpty Char

newtype DueDate = DueDate UTCTime deriving (Eq,Show,Ord)

newtype Description = Description NonEmptyString deriving (Eq,Show)

data Input = Input String (Maybe String) deriving (Eq,Show)
data Todo = Todo Description (Maybe DueDate) deriving (Eq,Show)

persist :: Todo -> IO ()
persist = void . pure

data Error = DescriptionEmpty | PastDueDate | InvalidDateFormat deriving (Eq,Show)

serialise :: Error -> String
serialise = show

render :: Error -> IO ()
render = putStrLn . serialise

parse :: UTCTime -> Input -> Either Error Todo
parse now (Input s d) =
    Todo <$>
     maybeToRight DescriptionEmpty (processDescription s) <*>
     processDate now d

processDescription :: String -> Maybe Description
processDescription = fmap Description . nonEmpty

processDate :: UTCTime -> Maybe String -> Either Error (Maybe DueDate)
processDate now =
  traverse (fmap DueDate . (=<<) (maybeToRight PastDueDate . mfilter (> now) . Just) . maybeToRight InvalidDateFormat  . parseISO8601)

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

--original :: Input -> IO ()
--original input =
   --getCurrentTime >>= (\ now ->
    --case parse now input of
     --Right todo -> persist todo
     --Left e -> render e )

