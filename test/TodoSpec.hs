module TodoSpec where

import Test.Hspec
import Test.Hspec.QuickCheck
import Test.QuickCheck.Property
import Test.QuickCheck
import Test.QuickCheck.Instances ()
import Todo


spec :: Spec
spec = describe "parse" $ do

     it "example-based unit test" $
        1 `shouldBe` 1

     prop "do something" $
        \d n -> parse n (Input "" d) == Left DescriptionEmpty

