module Main where

-- Used for extracting categories from original hackage

import Text.ParserCombinators.Parsec
import System.Environment

type Tag = String
type Name = String
type Count = Integer
data Category = Category Tag Name Count
              deriving (Show)

categoryParser :: Parser Category
categoryParser = do 
  string "<a href=\"#cat:"
  tag <- many $ letter <|> oneOf "./- " <|> digit
  string "\"\n\t>"
  name <- many $ letter <|> noneOf "<"
  string "</a\n\t>("
  count <- many1 digit
  string "), "
  return $ Category tag name (read count)

recursiveCategoryParser :: Parser [Category]
recursiveCategoryParser = many categoryParser

printCategory :: Category -> String
printCategory (Category tag name count) =
  "<a href=\"#cat:" ++ tag ++ "\">" ++
  name ++ " (" ++ show count ++ ")</a>\n"

printCategories :: Either ParseError [Category] -> String
printCategories (Left err) = "Error occurred"
printCategories (Right (x:[])) = printCategory x
printCategories (Right (x:xs)) = printCategory x ++ printCategories (Right xs)

main = do
  args <- getArgs
  file <- readFile $ head args
  let categories = printCategories $ parse recursiveCategoryParser "c" file
  writeFile (args !! 1) categories
