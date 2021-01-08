{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Applicative
import Lib (xboxScraper)
import System.Environment
import Text.HTML.Scalpel

main :: IO ()
main = do
  args <- getArgs
  if null args || length args > 1
    then putStrLn "ERROR: No URL Supplied!"
    else mapM_ xboxScraper args
