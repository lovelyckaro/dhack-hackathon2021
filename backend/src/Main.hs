{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty

import Text.Blaze.Html.Renderer.Text (renderHtml)

import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import Control.Monad.IO.Class (MonadIO(liftIO))

main :: IO ()
main = do
  scotty 3000 $ do
    get "/" $ do
      html $ renderHtml $ 
        H.html $
          H.body $ do
            H.h1 "Do a thing!"
            H.form H.! A.method "post" H.! A.action "/" $ do
              H.input H.! A.type_ "submit"
    post "/" $ do
      liftIO $ putStrLn "A thing!"
      redirect "/"
