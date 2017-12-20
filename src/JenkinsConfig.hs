module JenkinsConfig (
  JenkinsConfig(protocol, host, username, password),
  readConfig
) where

import qualified Data.ConfigFile as CF
import Control.Monad.Except

data JenkinsConfig = JenkinsConfig {
  protocol :: String,
  host     :: String,
  username :: String,
  password :: String
} deriving Show

type JenkinsConfigIO = ExceptT CF.CPError IO JenkinsConfig

readConfig :: String -> IO JenkinsConfig
readConfig fileName =
    do
--      cp <- CF.readfile CF.emptyCP fileName
      return $ JenkinsConfig "" "" "" ""

configIO :: String -> IO CF.ConfigParser
configIO fileName =
  CF.readfile CF.emptyCP fileName


--readConfig :: String -> JenkinsConfigIO
--readConfig fileName =
--    do
--      cp <- join $ liftIO $ CF.readfile CF.emptyCP fileName
--      protocol <- CF.get cp "DEFAULT" "protocol" :: ExceptT CF.CPError IO String
--      host     <- CF.get cp "DEFAULT" "host"     :: ExceptT CF.CPError IO String
--      username <- CF.get cp "DEFAULT" "username" :: ExceptT CF.CPError IO String
--      password <- CF.get cp "DEFAULT" "password" :: ExceptT CF.CPError IO String
--      let jc = JenkinsConfig protocol host username password
--      return jc
