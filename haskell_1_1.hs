import Data.List (intercalate)
findElementCount x xs = (length . filter (== x)) xs
getFilteredList list1 list2 = filter (\x -> or [((findElementCount x list2) `mod` 2 == 1),((findElementCount x list2) == 0)]) list1
main = do
  putStrLn "Write first list:"
  input <- getLine
  let list1 = map read (words input) :: [Int]
  putStrLn "Write second list:"
  input <- getLine
  let list2 = map read (words input) :: [Int]
  let list3 = getFilteredList list1 list2
  putStr "First list: "
  print list1
  putStr "Second list: "
  print list2
  putStr "Result list: "
  print list3