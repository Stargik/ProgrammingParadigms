getElementsCount :: [a] -> Int
getElementsCount [] = 0
getElementsCount (x:xs) = getElementsCount(xs) + 1

main :: IO ()
main =  do
    putStrLn "Write list:"
    input <- getLine
    let list = map read (words input) :: [Int]
    let count = getElementsCount list
    putStr "Count: "
    print count