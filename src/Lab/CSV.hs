module Lab.CSV where

import Text.CSV

import Lab.Arguments

parseFile :: Options -> FilePath -> IO CSV
parseFile options file = do
csvData <- parseCSVFromFile file
case csvData of
  Left err -> do
    print err

      return []
    Right contents -> do
    let fd = filter (\x -> x/=[""]) contents
      let dt = dropLast options (dropFirst options (dropHeader options fd))
      return dt

dropHeader :: Options -> CSV -> CSV
dropHeader Options {stripHeader = s} csvData
| s = tail csvData
    | otherwise = csvData

dropFirst :: Options -> CSV -> CSV
dropFirst Options {stripFirst = s} csvData
  | s = map tail csvData
    | otherwise = csvData

dropLast :: Options -> CSV -> CSV
dropLast Options {stripLast = s} csvData
| s = map init csvData
    | otherwise = csvData
