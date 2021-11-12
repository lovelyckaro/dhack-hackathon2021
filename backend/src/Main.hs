{-# LANGUAGE OverloadedStrings #-}

module Main where

import Prelude hiding (id)

import Web.Scotty hiding (html, body, text)
import qualified Web.Scotty as S

import Text.Blaze.Html.Renderer.Text (renderHtml)
import Text.Blaze.Html5 hiding (main, map)
import Text.Blaze.Html5.Attributes hiding (form, label)
import Control.Monad.IO.Class (MonadIO(liftIO))

import qualified Data.Map as M
import Control.Concurrent.MVar

main :: IO ()
main = do
  mvars <- zip [1..6] <$> (sequence $ map newMVar $ [0,0,0,0,0,0])
  scotty 3000 $ do
    get "/" $ do
      S.html $ renderHtml $ 
        html $
          body $ do
            h1 "Do a thing!"
            form ! method "post" ! action "/" $ do

              input ! type_ "radio"  ! id "1" ! name "target" ! value "1" ! checked "true"
              label ! for "1" $ toHtml $ text "Fack 1" >> br

              input ! type_ "radio"  ! id "2" ! name "target" ! value "2"
              label ! for "2" $ toHtml $ text "Fack 2" >> br

              input ! type_ "radio"  ! id "3" ! name "target" ! value "3"
              label ! for "3" $ toHtml $ text "Fack 3" >> br

              input ! type_ "radio"  ! id "4" ! name "target" ! value "4"
              label ! for "4" $ toHtml $ text "Fack 4" >> br

              input ! type_ "radio"  ! id "5" ! name "target" ! value "5"
              label ! for "5" $ toHtml $ text "Fack 5" >> br

              input ! type_ "radio"  ! id "6" ! name "target" ! value "6"
              label ! for "6" $ toHtml $ text "Fack 6" >> br

              input ! type_ "radio" ! id "inc" ! name "action" ! value "inc" ! checked "true"
              label ! for "inc" $ toHtml $ text "Increment" >> br

              input ! type_ "radio" ! id "empty" ! name "action" ! value "empty"
              label ! for "empty" $ toHtml $ text "Empty" >> br

              input ! type_ "submit" ! value "Do it!"
    post "/" $ do
      t <- S.param "target"
      a <- S.param "action"
      liftIO $ putStrLn $ a ++ " fack " ++ t
      case a of
        "inc" -> case lookup (read t) mvars of
                  Nothing -> return ()
                  Just ref -> liftIO $ do v <- takeMVar ref
                                          putMVar ref (v+1)
                                          putStrLn $ "Fack " ++ t 
                                                   ++ " inkrementerat till " 
                                                   ++ show (v+1)
        "empty" -> case lookup (read t) mvars of
                     Nothing -> return ()
                     Just ref -> liftIO $ do v <- takeMVar ref
                                             putMVar ref 0
                                             putStrLn $ "Fack " ++ t
                                                      ++ " är nu tomt :("

      redirect "/"

