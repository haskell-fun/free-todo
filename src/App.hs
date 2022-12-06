module App where

import Summary 
import Options.Applicative

program :: IO ()
program = putStrLn "hello!" >>
            execParser parserInfo >>= \ args -> 
                 program'' (title args) (Just (dueDate args))

data Args = Args {
    title :: String, 
    dueDate :: Time 
    } deriving (Eq,Show, Read)


parser :: Parser Args 
parser = Args <$> strOption ( long "title"
         <> short 't'
         <> help "title" ) <*> dueDateParser where 
          dueDateParser :: Parser Time 
          dueDateParser = Time <$>strOption ( long "due" <> short 'd' <> help "due date" )


parserInfo :: ParserInfo Args 
parserInfo = info (parser <**> helper)
  ( fullDesc
  <> progDesc "blah"
  <> header "blah" )

   
