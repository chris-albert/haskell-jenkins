module Main where

import qualified Jenkins as J
import qualified JenkinsConfig as JC
import Control.Monad.Except
import System.Environment
import Control.Exception

main :: IO ()
main = do
  out <- catchAny run
  print out

run :: IO String
run = do
  file   <- getConfFile
  config <- JC.readConfig file
  J.getJenkinsJSON config

getConfFile :: IO String
getConfFile = do
  args <- getArgs
  liftMaybe . headOption $ args

headOption :: [a] -> Maybe a
headOption [] = Nothing
headOption (h:_) = Just h

liftMaybe :: Maybe a -> IO a
liftMaybe (Just a) = return a
liftMaybe Nothing = error "Maybe was empty"

catchAny :: IO String -> IO String
catchAny io = (Control.Exception.catch io)
              (\e -> return $ show (e :: SomeException))
