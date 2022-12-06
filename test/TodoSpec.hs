module TodoSpec where

import Test.Hspec
import Test.Hspec.QuickCheck
import Test.QuickCheck.Property
import Test.QuickCheck
import Test.QuickCheck.Instances ()
import Summary

testInterpreter :: Time -> Program -> String
testInterpreter _ (Persist todo) = "Persist"
testInterpreter _ ShowError = "ShowError"
testInterpreter t (GetCurrentTime f) = testInterpreter t (f t)

spec :: Spec
spec = describe "parse" $ do

     it "example-based unit test" $
        testInterpreter (Time "a") (program' "buy milk" (Just $ Time "c")) `shouldBe` "Persist"

   --   prop "do something" $
   --      \d n -> parse n (Input "" d) == Left DescriptionEmpty

