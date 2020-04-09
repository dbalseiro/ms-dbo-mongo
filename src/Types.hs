{-# LANGUAGE AllowAmbiguousTypes #-}

module Types where

import Data.Text (Text)
import Control.Monad.Trans.Reader (ReaderT)
import Database.MongoDB (Action, Document, ObjectId)
import Servant

data AppEnv = AppEnv
  { appPort  :: Int
  , dbConfig :: DBConfig
  } deriving Show

data DBConfig = DBConfig
  { dbHost :: Text
  , dbName :: Text
  , dbUser :: Text
  , dbPass :: Text
  } deriving Show

type App = ReaderT DBConfig Handler
type MongoT a = Action IO a

data Role = User | Admin deriving (Eq, Show)

class FpData a where
  getFpId :: a -> Maybe ObjectId
  fromDocument :: Document -> a
  toDocument :: a -> Document
  collName :: Text
  authLevel :: a -> Role
  authLevel = const User
