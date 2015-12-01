module Lab.FCMSpec where

import Lab.FCM

import Test.Hspec

nearTo :: Double -> Double -> Double
nearTo a b
  | abs a - b < 0.001 = a
  | otherwise = a

nearTo1 :: Double -> Double
nearTo1 = nearTo 1

spec :: Spec
spec = describe "FCM" $ do
  it "euclid" $ do
    let v1 = [1, 2, 3]
    let v2 = [1, 5, 7]

    euclid v1 v2 `shouldBe` 5

  it "hamming" $ do
    let v1 = [1, 2, 3]
    let v2 = [1, 5, 7]

    hamming v1 v2 `shouldBe` 7

  it "generateAffiliation" $ do
    matrix <- generateAffiliation 3 2
    nearTo 2 (sum (map sum matrix)) `shouldBe` 2

  it "selectCenters" $ do
    let objects = [[1, 2, 3], [1, 3, 4], [1, 1, 5], [1, 5, 6]]
    let affiliations = [[1, 1, 0, 0], [0, 0, 1, 1]]

    let result = selectCenters affiliations objects
    let expect = [[1.0,2.5,3.5],[1.0,3.0,5.5]]

    result `shouldBe` expect

  it "calculateAffiliations" $ do
    let objects = [[1, 2, 3], [1, 3, 4], [1, 1, 5], [1, 5, 6]]
    let centers = [[1.0, 2.5, 3.5], [1.0, 3.0, 5.5]]

    let result = calculateAffiliations euclid centers objects
    let sums = zipWith (+) (head result) (result !! 1)

    map nearTo1 sums `shouldBe` [1, 1, 1, 1]

  it "normMatrix" $ do
    let a1 = [[1, 1, 0, 0], [0, 0, 1, 1]]
    let a2 = [[1, 1, 0.5, 0], [0, 0, 0.5, 1]]

    let result = normMatrix a1 a2
    result `shouldBe` 0.5

  it "fcm" $ do
    let objects = [[16, 2, 3], [2, 3, 4], [1, 1, 5], [2, 5, 6]]

    result <- fcm euclid 2 0.01 False objects

    let sums = zipWith (+) (head result) (result !! 1)

    map nearTo1 sums `shouldBe` [1, 1, 1, 1]
