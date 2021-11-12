{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty

main :: IO ()
main = do
  scotty 3000 $
    get "/" $
      html "<h1>Hello World!</h1>"
