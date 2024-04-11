getElements :: Int -> [Int]
getElements 0 = []
getElements n = if n <= 1 then [(2*n)] else getElements (n-1) ++ [(2*n)]

main :: IO ()
main =  do
    putStrLn "Write n:"
    input <- getLine
    let n = (read input :: Int)
    let list = getElements n
    print list