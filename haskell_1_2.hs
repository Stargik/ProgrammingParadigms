import Data.List
main = do
  putStrLn "Write list:"
  input <- getLine
  let list1 = map read (words input) :: [Int]
  putStrLn "Write count:"
  input <- getLine
  let n = (read input :: Int)
  let list2 = (take n . sort) list1
  let list = filter (\x -> (any (==x) list2)) list1
  putStr "List: "
  print list1
  putStr "Count: "
  print n
  putStr "Result: "
  print list