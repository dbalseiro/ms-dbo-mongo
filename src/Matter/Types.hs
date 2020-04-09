{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Matter.Types where

import Text.Read (readMaybe)
import Data.String (IsString)
import Data.Maybe (fromMaybe)
import Data.Text (Text)
import Data.Aeson
import qualified Data.Bson as B

import Types

newtype DocketNum = DocketNum { unDocketNum :: Text }
  deriving (Show, Eq)

newtype ClientDocketNum = ClientDocketNum { unClientDocketNum :: Text }
  deriving (Show, Eq)

newtype MatterNum = MatterNum { unMatterNum :: Text }
  deriving (Show, Eq)

newtype ClientNum = ClientNum { unClientNum :: Text }
  deriving (Show, Eq)

data Matter = Matter
  { matterId        :: Maybe String
  , docketNum       :: Maybe DocketNum
  , clientDocketNum :: Maybe ClientDocketNum
  , matterNum       :: Maybe MatterNum
  , clientNum       :: Maybe ClientNum
  } deriving (Show, Eq)

instance FromJSON Matter where
  parseJSON = withObject "Matter" $ \v ->
    Matter <$> v .:? "_id"
           <*> (fmap DocketNum <$> v .:? "docket_num")
           <*> (fmap ClientDocketNum <$> v .:? "client_docket_num")
           <*> (fmap MatterNum <$> v .:? "matter_num")
           <*> (fmap ClientNum <$> v .:? "client_num")

instance ToJSON Matter where
  toJSON m@Matter{..} = object $
    ("_id" .= fromMaybe mempty matterId) : matterData m (.=)

instance FpData Matter where
  collName = "matters"
  getFpId = fmap read . matterId
  fromDocument doc = Matter
    { matterId        = show <$> (B.lookup "_id" doc :: Maybe B.ObjectId)
    , docketNum       = DocketNum <$> B.lookup "docket_num" doc
    , clientDocketNum = ClientDocketNum <$> B.lookup "client_docket_num" doc
    , matterNum       = MatterNum <$> B.lookup "matter_num" doc
    , clientNum       = ClientNum <$> B.lookup "client_num" doc
    }
  toDocument matter =
    let mid = maybe [] (\_id -> ["_id" B.=: B.ObjId _id]) $ matterId matter >>= readMaybe
     in mid <> matterData matter (B.=:)


matterData :: IsString t => Matter -> (t -> Text -> a) -> [a]
matterData Matter{..} (..=) =
    [ "docket_num"        ..= maybe mempty unDocketNum docketNum
    , "client_docket_num" ..= maybe mempty unClientDocketNum clientDocketNum
    , "matter_num"        ..= maybe mempty unMatterNum matterNum
    , "client_num"        ..= maybe mempty unClientNum clientNum
    ]
