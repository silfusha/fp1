module Lab.FCM where
import System.Random
import Data.List
import Data.List.Split

type Distance = [Double] -> [Double] -> Double

euclid :: Distance
euclid v1 v2 = sqrt $ sum $ zipWith diff v1 v2
  where diff a b = (a-b)^(2::Int)

hamming :: Distance
hamming v1 v2 = sum $ zipWith diff v1 v2
  where diff a b = abs $ a-b

generateAffiliation :: Int -> Int -> IO [[Double]]
generateAffiliation n c = do
  g <- getStdGen

  return $ createMatrix (getNumbers g)
where getNumbers g = take (n * c) (randomRs (0, 1) g :: [Double])
  createMatrix nums = transpose $ map normalize $ chunksOf n nums
    normalize row = map (/ sum row) row

getRandomCenters :: Int -> [[Double]] -> IO [[Double]]
getRandomCenters c objects = do
  g <- getStdGen

  return $ pick (randomSeq g)

  where randomSeq g = take c (randomRs (0, length objects - 1) g :: [Int])
  pick = map (\n -> objects !! n)

selectCenters :: [[Double]] -> [[Double]] -> [[Double]]
selectCenters affiliations objects = map fcmSelectCenter affiliations
  where fcmSelectCenter accessory = map (/ accSum) elemSum
          where elemSum = foldl (zipWith (+)) zero (zipWith mult accessory objects)
       where mult m = map (\o -> m ** 2 * o)
            accSum = sum $ map (**2) accessory
        zero = replicate (length (head objects)) 0

calculateAffiliations :: Distance -> [[Double]] -> [[Double]] -> [[Double]]
calculateAffiliations distance centers objects = map calcAffiliation centers
  where calcAffiliation center = map (calcAffiliationForObj center) objects
  calcAffiliationForObj center object = 1 / sum'
  where sum' = sum $ map rel centers
        rel nCenter = (distance object center / distance object nCenter) ** 2

normMatrix :: [[Double]] -> [[Double]] -> Double
normMatrix a b = maximum $ zipWith reduceLines a b
  where reduceLines c d = maximum $ map abs (zipWith (-) c d)

fcm :: Distance -> Int -> Double -> Bool -> [[Double]] -> IO [[Double]]
fcm distance c eps randomCenters objects = do
  affiliations <- if randomCenters
    then do
        centers <- getRandomCenters c objects
        return $ calculateAffiliations distance centers objects
      else generateAffiliation c (length objects)

  return $ fcm' affiliations

  where fcm' affiliations = calcNewAffiliation (selectCenters affiliations objects)
          where
    calcNewAffiliation centers = checkAffiliations (calculateAffiliations distance centers objects)
    checkAffiliations newAffiliations
        | normMatrix affiliations newAffiliations < eps = newAffiliations
          | otherwise = fcm' newAffiliations
