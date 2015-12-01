module Lab.CSVSpec where

import Lab.CSV
import Lab.Arguments

import Test.Hspec

csv :: [[String]]
csv = [["number", "text"], ["1", "123"]]

spec :: Spec
spec = describe "CSV" $ do
  it "drop header" $ do
    dropHeader defaultOptions {stripHeader = True} csv `shouldBe` [["1", "123"]]
    dropHeader defaultOptions {stripHeader = False} csv `shouldBe` [["number", "text"], ["1", "123"]]

  it "drop first column" $ do
    dropFirst defaultOptions {stripFirst = True} csv `shouldBe` [["text"], ["123"]]
    dropFirst defaultOptions {stripFirst = False} csv `shouldBe` [["number", "text"], ["1", "123"]]

  it "drop last column" $ do
    dropLast defaultOptions {stripLast = True} csv `shouldBe` [["number"], ["1"]]
    dropLast  defaultOptions {stripLast = False} csv `shouldBe` [["number", "text"], ["1", "123"]]
