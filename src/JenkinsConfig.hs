module JenkinsConfig (
  JenkinsConfig(protocol, host, username, password),
  readConfig,
  buildUrl
) where

import qualified Data.ConfigFile as CF
import Control.Monad.Except

data JenkinsConfig = JenkinsConfig {
  protocol :: String,
  host     :: String,
  username :: String,
  password :: String
} deriving Show

readConfig :: String -> IO JenkinsConfig
readConfig fileName =
  do
    ioConfig <- runExceptT $
      do
       cp <- join $ liftIO $ CF.readfile CF.emptyCP fileName
       p  <- CF.get cp "DEFAULT" "protocol" :: ExceptT CF.CPError IO String
       h  <- CF.get cp "DEFAULT" "host"     :: ExceptT CF.CPError IO String
       u  <- CF.get cp "DEFAULT" "username" :: ExceptT CF.CPError IO String
       pa <- CF.get cp "DEFAULT" "password" :: ExceptT CF.CPError IO String
       let jc = JenkinsConfig p h u pa
       return jc
    eitherIO ioConfig

eitherIO :: (Show e) => Either e a -> IO a
eitherIO (Left e) = error $ show e
eitherIO (Right a) = return a

buildUrl :: JenkinsConfig -> String
buildUrl config = protocol config ++ "://" ++ host config
