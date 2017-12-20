{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Jenkins (
  getJenkinsJSON
) where

import Network.Wreq
import Control.Lens
import Data.Aeson (Value, FromJSON, ToJSON, encode)
import Data.Aeson.Lens (_String, key)
import GHC.Generics
import Data.Typeable
import qualified Data.ByteString.Lazy as BSL
import Data.Text.Encoding
import Data.Text
import qualified JenkinsConfig as JC

jenkinsUrl :: String
jenkinsUrl = "https://skywalkers-jenkins.build.corp.creditkarma.com"

jobsPath :: String
jobsPath = "/api/json"

getJenkinsJSON :: JC.JenkinsConfig -> IO String
getJenkinsJSON config = do
  jobs <- getJobs jenkinsUrl
  return $ getJson $ Items $ createJenkins jobs

getJson :: ToJSON a => a -> String
getJson d = unpack $ decodeUtf8 $ BSL.toStrict (encode d)

newtype Jobs = Jobs {
  jobs :: [Job]
} deriving (Generic, Show)

data Job = Job {
  name  :: String
 ,url   :: String
 ,color :: String
} deriving (Generic, Show)


instance FromJSON Job
instance FromJSON Jobs

data Color = Color {
  colorColor :: String
} deriving (Show)

data FileType = FileType {
  fileType :: String
} deriving (Show)

getJobs :: String -> IO Jobs
getJobs url = do
  response <- get (url ++ jobsPath)
  jobs <- asJSON response
  return $ jobs ^. responseBody

createJenkins :: Jobs -> [Jenkins]
createJenkins js = Prelude.map jobToJenkins (jobs js)

extractName :: Job -> String
extractName = name

jobToJenkins :: Job -> Jenkins
jobToJenkins job = Jenkins {
    title = name job
   ,uid   = name job
   ,arg   = url job
   ,icon  = Icon {path = p}
  }
  where c  = getColor job
        ft = getFileType c
        p  = colorColor c ++ "." ++ fileType ft

getColor :: Job -> Color
getColor job
  | c == "notbuilt" = Color "gray"
  | c == "aborted"  = Color "gray"
  | c == "disabled" = Color "gray"
  | otherwise       = Color c
  where c = color job

getFileType :: Color -> FileType
getFileType (Color "blue_anime") = FileType "gif"
getFileType _                    = FileType "png"

data Jenkins = Jenkins {
  title :: String
 ,uid   :: String
 ,arg   :: String
 ,icon  :: Icon
} deriving (Generic, Show)

newtype Icon = Icon {
  path :: String
} deriving (Generic, Show)

newtype Items = Items {
  items :: [Jenkins]
} deriving (Generic, Show)

instance ToJSON Jenkins
instance ToJSON Icon
instance ToJSON Items