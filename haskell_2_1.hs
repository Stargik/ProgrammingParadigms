import Data.List

primesTo :: Int -> [Int]
primesTo m = sieve [2..m]
  where 
  sieve (x:xs) = x : sieve (xs \\ [x,x+x..m])
  sieve [] = []

nthPrime :: Int -> [Int] -> Int
nthPrime n primes = primes !! (n - 1) 

splitList :: Int -> [Int] -> [[Int]] -> [Int] -> [[Int]]
splitList n primes list list2 =
  if n > (length list2)
    then if null list2 then list else list2 : list
    else do
      let tuple = splitAt (nthPrime n primes) (reverse list2)
      let newList = (reverse (fst tuple)) : list
      splitList (n + 1) primes newList (reverse (snd tuple))

main = do
  putStrLn "Write list:"
  input <- getLine
  let list1 = map read (words input) :: [Int]
  let primes = primesTo $ length list1
  let list = []
  let newList = splitList 1 primes list list1
  putStrLn "List: "
  print list1
  putStrLn "Result: "
  putStrLn $ intercalate " " (map show newList)