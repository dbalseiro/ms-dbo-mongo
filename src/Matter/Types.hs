{-# LANGUAGE DeriveGeneric #-}

module Matter.Types where

import Data.Text (Text)
import Data.Aeson

import GHC.Generics

newtype DocketNum = DocketNum Text deriving (Show, Eq, Generic)
newtype ClientDocketNum = ClientDocketNum Text deriving (Show, Eq, Generic)
newtype MatterNum = MatterNum Text deriving (Show, Eq, Generic)
newtype ClientNum = ClientNum Text deriving (Show, Eq, Generic)

data Matter = Matter
  { docketNum       :: Maybe DocketNum
  , clientDocketNum :: Maybe ClientDocketNum
  , matterNum       :: Maybe MatterNum
  , clientNum       :: Maybe ClientNum
  } deriving (Show, Eq, Generic)

instance FromJSON DocketNum
instance ToJSON DocketNum

instance FromJSON ClientDocketNum
instance ToJSON ClientDocketNum

instance FromJSON MatterNum
instance ToJSON MatterNum

instance FromJSON ClientNum
instance ToJSON ClientNum

instance FromJSON Matter
instance ToJSON Matter

