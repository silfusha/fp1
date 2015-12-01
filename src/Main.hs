import System.Environment

import Lab.Arguments
import Lab.CSV
import Lab.FCM
import Data.List

main :: IO ()
main = do
  options <- getArgs >>= parseArguments
  let Options {input = file} = options
  csv <- parseFile options file
  processCSV options csv
  where processCSV Options {distance = dist, clustersCount = count, randomCenters = random, eps = _eps} csv = do
            affiliations <- process (csvToObjects csv)
            printAffiliations $ transpose affiliations
            return ()
            wherecsvToObjects = map (map conv) where conv v = read v :: Double
  process = fcm dist count _eps random
              printAffiliations = mapM print
