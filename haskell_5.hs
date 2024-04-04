f3 :: Double -> Maybe Double
f3 x = if (x==(1 / (10 * (sqrt 34))) || x<=0) then Nothing else Just (1 / ((logBase 10 x) + (sqrt (34))))

f1 :: Double -> Maybe Double
f1 x = if x <= (1 / (10 * 34)) then Nothing else Just (1 / (sqrt (34 + logBase 10 x)))

f4 :: Double -> Maybe Double
f4 x = if x <= -34 then Nothing else Just (1 / (sqrt (x + 34)))

withDoF314 :: Double -> Maybe Double
withDoF314 x = do
    u3 <- f4 x
    u2 <- f1 u3
    f3 u2

withoutDoF314 :: Double -> Maybe Double
withoutDoF314 x = f4 x >>= f1 >>= f3

binf4 :: Double -> Double -> Maybe Double
binf4 x n = if x <= -n then Nothing else Just (1 / (sqrt (x + n)))

withDoBinf431 :: Double -> Maybe Double
withDoBinf431 x = do
    u1 <- f3 x
    u2 <- f1 x
    binf4 u1 u2

withoutDoBinf431 :: Double -> Maybe Double
withoutDoBinf431 x = f3 x >>= \u1 -> f1 x >>= \u2 -> binf4 u1 u2

main :: IO ()
main =  do
    putStrLn "Task number: "
    input <- getLine
    let taskNumber = (read input :: Int)
    case taskNumber of
        1 -> do 
            putStrLn "Function number (3, 1, 4): "
            input <- getLine
            let functionNumber = (read input :: Int)
            putStrLn "Enter x: "
            input <- getLine
            let x = (read input :: Double)
            case functionNumber of
                3 -> do putStr $ "f3(x): " 
                        print $ f3 x
                1 -> do putStr $ "f1(x): " 
                        print $ f1 x
                4 -> do putStr $ "f4(x): " 
                        print $ f4 x
                _ -> putStr $ "Value is not correct"
        2 -> do
            putStrLn "Enter x: "
            input <- getLine
            let x = (read input :: Double)
            putStr "With do-notation f3(f1(f4(x))): "
            print $ withDoF314 x
            putStr "Without do-notation f3(f1(f4(x))): "
            print $ withoutDoF314 x
        3 -> do
            putStrLn "Enter x: "
            input <- getLine
            let x = (read input :: Double)
            putStrLn "Enter n: "
            input <- getLine
            let n = (read input :: Double)
            putStr $ "f4(x, n): " 
            print $ binf4 x n
        4 -> do
            putStrLn "Enter x: "
            input <- getLine
            let x = (read input :: Double)
            putStr $ "With do-notation f4(f3(x), f1(x)): " 
            print $ withDoBinf431 x
            putStr $ "Without do-notation f4(f3(x), f1(x)): " 
            print $ withoutDoBinf431 x
        _ -> putStr $ "Value is not correct"