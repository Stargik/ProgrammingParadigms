import Data.List

type Transition = (Integer, String, Integer)
type Automata = [Transition]

fstEl :: (a, b, c) -> a
fstEl (x, _, _) = x

sndEl :: (a, b, c) -> b
sndEl (_, x, _) = x

thrdEl :: (a, b, c) -> c
thrdEl (_, _, x) = x

automataPath :: Integer -> Integer -> Automata -> Automata -> [Integer] -> Integer -> [String] -> Bool -> (Bool, [String])
automataPath state 0 _ _ finalS _ word _
    | state `elem` finalS = (True, word)
    | otherwise = (False, word)
automataPath state k (t:ts) (t1:ts1) finalS initS word nextStep
    | nextStep == True && state == fstEl t && sndEl t /= "e" && (fst $ (automataPath (thrdEl t) (k-1) (t:ts) (t:ts) finalS initS ((sndEl t):word) True)) = automataPath (thrdEl t) (k-1) (t:ts) (t:ts) finalS initS ((sndEl t):word) True
    | nextStep == False && state == fstEl t1 && sndEl t1 /= "e" && (fst $ (automataPath (thrdEl t1) (k-1) (t:ts) (t:ts) finalS initS ((sndEl t1):word) True)) = automataPath (thrdEl t1) (k-1) (t:ts) (t:ts) finalS initS ((sndEl t1):word) True
    | nextStep == True && state == fstEl t && sndEl t == "e" && thrdEl t /= fstEl t && (fst $ (automataPath (thrdEl t) (k) (t:ts) (t:ts) finalS initS (word) True)) = automataPath (thrdEl t) (k) (t:ts) (t:ts) finalS initS (word) True
    | nextStep == False && state == fstEl t1 && sndEl t1 == "e" && thrdEl t1 /= fstEl t1 && (fst $ (automataPath (thrdEl t1) (k) (t:ts) (t:ts) finalS initS (word) True)) = automataPath (thrdEl t1) (k) (t:ts) (t:ts) finalS initS (word) True
    | length ts1 /= 0 = automataPath state k (t:ts) ts1 finalS initS word False
    | otherwise = (False, word)

getElementAtIndex :: [a] -> Int -> a
getElementAtIndex (x:xs) index
  | index == 0 = x
  | otherwise = getElementAtIndex xs (index - 1)

main :: IO ()
main =  do
  content <- readFile "/uploads/haskell_test_3.txt"
  let lists = lines content
  let initState = (getElementAtIndex (map read (words (getElementAtIndex lists 0)) :: [Integer]) 0) 
  let finalStates =  map read (words $ (getElementAtIndex lists 1)) :: [Integer]
  let automata = map (\x -> ((read (getElementAtIndex (words x) 0) :: Integer), (getElementAtIndex (words x) 1), (read (getElementAtIndex (words x) 2) :: Integer))) (drop 2 lists)
  putStr $ "Initial state: " 
  print initState
  putStrLn $ "Final states: " ++ intercalate " " (map show finalStates)
  putStrLn $ "Transitions: "
  mapM_ (\x -> putStrLn $ intercalate " " x) (map (\x -> (show (fstEl x)) : (sndEl x) : [(show (thrdEl x))]) (automata))
  putStrLn "Write length: "
  input <- getLine
  let n = (read input :: Integer)
  let result = automataPath initState n automata automata finalStates initState [] False
  print $ fst result
  putStrLn $ intercalate "" $ reverse $ snd result