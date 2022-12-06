module Summary where

data Todo = Todo String (Maybe Time) deriving (Eq,Show)
newtype Time = Time String deriving (Eq,Show, Ord,Read)

-- input: String and Optional Due date
-- IF input is valid (ie, description nto empty and due date, WHEN present, in the future) 
--    persist todo
-- else 
--    do nothing  

clock :: IO Time
clock = pure $ Time "c"

persist :: Todo -> IO ()
persist = print  

parseAndValidate :: Time -> String -> Maybe Time -> Maybe Todo
parseAndValidate _ "" _ = Nothing 
parseAndValidate _ s Nothing  = Just (Todo s Nothing)
parseAndValidate now s (Just d) | d > now = Just (Todo s (Just d))
                                | otherwise = Nothing 

data Program = Persist Todo | ShowError | GetCurrentTime (Time -> Program)

interpreter :: Program -> IO () 
interpreter (Persist todo) =  persist todo 
interpreter ShowError = putStrLn "error" 
interpreter (GetCurrentTime f) = clock >>= interpreter . f 

program'' :: String -> Maybe Time -> IO ()
program'' s t = interpreter (program' s t )

program' :: String -> Maybe Time -> Program
program'  s t = GetCurrentTime (\ now -> 
    case parseAndValidate now s t of
      Just todo -> Persist todo 
      Nothing -> ShowError )



