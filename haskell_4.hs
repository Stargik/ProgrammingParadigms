import Data.List

type Rule = (String, [String])

type Gram = [Rule]

isNonTerm :: String -> [String] -> Bool
isNonTerm s nt = s `elem` nt
 
isTerm :: String -> [String] -> Bool
isTerm s t = s `elem` t

axiom :: Gram -> String
axiom gram = fst (head gram)

uniq [] = []
uniq (x:xs) = if (x `elem` xs) then uniq xs else (x : uniq xs)

supr (x:xs) = if (x == head xs) then x else supr xs

areMembers [] y = True
areMembers (x:xs) y = (x `elem` y) && (areMembers xs y)

fStepProductNonTerms g xs = uniq ( [l | (l,r) <- g, areMembers r xs ] ++ xs )

xs0 g t = [l | (l,r) <- g, areMembers r t ]

productNonTerms :: Gram -> [String] -> [String]
productNonTerms g t = supr (iterate (fStepProductNonTerms g) (xs0 g t) )

unproductNonTerms :: Gram -> [String] -> [String] -> [String]
unproductNonTerms _ [] _ = []
unproductNonTerms g nt t = nt \\ (productNonTerms g t)

setOfTermsAndProductNonTerms :: Gram -> [String] -> [String]
setOfTermsAndProductNonTerms g t = t ++ productNonTerms g t

elimUnproductRules :: Gram -> [String] -> [String] -> Gram
elimUnproductRules [] _ _= []
elimUnproductRules g nt t = [(l,r) | (l,r) <- g, l `elem` setOfTermsAndProductNonTerms g t && areMembers r (setOfTermsAndProductNonTerms g t)]

getElementAtIndex :: [a] -> Int -> a
getElementAtIndex (x:xs) index
  | index == 0 = x
  | otherwise = getElementAtIndex xs (index - 1)


main :: IO ()
main = do
  content <- readFile "/uploads/test.txt"
  let lists = lines content
  let nonTerminals = words $ getElementAtIndex lists 0
  let terminals = words $ getElementAtIndex lists 1
  let grammar = map (\x -> ((head $ words x), (tail $ words x))) (drop 2 lists) :: Gram
  putStrLn $ "Grammar: "
  putStrLn $ "Nonterminals: " ++ intercalate " " nonTerminals
  putStrLn $ "Terminals: " ++ intercalate " " terminals
  putStrLn $ "Rules: "
  mapM_ (\x -> putStrLn $ intercalate " " x) (map (\x -> fst x : "->" : snd x) (grammar :: Gram))
  let productiveNonTerms = productNonTerms grammar terminals
  putStrLn $ "Productive nonterminals: " ++ intercalate " " productiveNonTerms
  let unproductiveNonTerms = unproductNonTerms grammar nonTerminals terminals
  putStrLn $ "Unproductive nonterminals: " ++ intercalate " " unproductiveNonTerms
  let elimGrammar = elimUnproductRules grammar nonTerminals terminals
  let elimNonterminals = uniq((axiom grammar) : productiveNonTerms)
  putStrLn $ "New grammar: "
  putStrLn $ "Nonterminals: " ++ intercalate " " elimNonterminals
  putStrLn $ "Terminals: " ++ intercalate " " terminals
  putStrLn $ "Rules: "
  mapM_ (\x -> putStrLn $ intercalate " " x) (map (\x -> fst x : "->" : snd x) (elimGrammar :: Gram))
