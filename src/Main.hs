{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Main where

import Network.Wreq
import Control.Lens
import Data.Aeson (Value, FromJSON)
import Data.Aeson.Lens (_String, key)
import GHC.Generics
import Data.Typeable
import qualified Control.Exception as E

jenkinsUrl :: String
jenkinsUrl = ""

jobsPath :: String
jobsPath = "/api/json"

main :: IO ()
main = do
  jobs <- getJobs jenkinsUrl
  let names = createJenkins jobs
  print names

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

getJobs :: String -> IO Jobs
getJobs url = do
  response <- get (url ++ jobsPath)
  jobs <- asJSON response
  return $ jobs ^. responseBody

createJenkins :: Jobs -> [String]
createJenkins js = map extractName (jobs js)

extractName :: Job -> String
extractName = name