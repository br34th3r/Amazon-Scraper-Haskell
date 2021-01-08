{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Applicative
import Lib (xboxScraper)
import System.Environment
import Text.HTML.Scalpel

main :: IO ()
main = xboxScraper "https://www.amazon.co.uk/Xbox-RRT-00007-Series-X/dp/B08H93GKNJ"
