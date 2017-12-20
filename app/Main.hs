module Main where

import qualified Jenkins as J
import qualified JenkinsConfig as JC
import Control.Monad.Except

main :: IO ()
main = do
  config <- JC.readConfig "/Users/chris.albert/.jenkins.conf"
  json   <- J.getJenkinsJSON config
  putStrLn "jenkins"
