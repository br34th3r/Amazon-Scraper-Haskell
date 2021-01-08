{-# LANGUAGE OverloadedStrings #-}

module Lib
  ( xboxScraper,
  )
where

import Control.Applicative
import Control.Concurrent
import Data.Char (isSpace, toUpper)
import Data.Time
import System.Environment
import Text.HTML.Scalpel
import Web.Browser (openBrowser)

xboxScraper :: URL -> IO ()
xboxScraper url = do
  content <- scrapeURL url (texts $ "div" @: ["id" @= "availability"] // "span")
  maybe printError printStock content
  where
    printError = putStrLn "ERROR: Could not scrape the URL!"
    printStock = mapM_ handleStock

tidy :: String -> String
tidy = reverse . dropWhile isSpace . reverse . dropWhile isSpace

checkStock :: String -> Bool
checkStock stock = let tidyStock = tidy stock in map toUpper tidyStock /= "CURRENTLY UNAVAILABLE."

handleStock :: String -> IO ()
handleStock stock =
  let inStock = checkStock stock
   in if inStock
        then do
          now <- fmap show getCurrentTime
          putStrLn ("In Stock at " ++ now)
          openBrowser "https://www.amazon.co.uk/Xbox-RRT-00007-Series-X/dp/B08H93GKNJ" >>= print
        else do
          now <- fmap show getCurrentTime
          putStrLn ("Not in Stock at " ++ now)
          putStrLn "Trying again in 10 Minutes"
          threadDelay 600000000
          putStrLn "Trying again..."
          xboxScraper "https://www.amazon.co.uk/Xbox-RRT-00007-Series-X/dp/B08H93GKNJ"