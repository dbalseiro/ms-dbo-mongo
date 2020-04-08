module Types where

import Control.Monad.Trans.Reader (ReaderT)

import Servant

data AppEnv = AppEnv
  { appPort  :: Int
  , dbConfig :: DBConfig
  } deriving Show

data DBConfig = DBConfig
  { dbHost :: String
  , dbName :: String
  } deriving Show

type App = ReaderT DBConfig Handler
