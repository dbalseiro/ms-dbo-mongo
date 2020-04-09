{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE TypeOperators     #-}
{-# LANGUAGE OverloadedStrings #-}

module Matter.Handler (matterServer, MatterAPI) where

import qualified Data.ByteString.Lazy as BL
import qualified Data.Text.Encoding as TE
import Data.Text (Text)

import Servant

import Types
import Matter.Types

import Persistence

type MatterAPI =    "all"   :> Get '[JSON] [Matter]
               :<|> "fetch" :> Capture "matterId" Text :> Get '[JSON] Matter
               :<|> "merge" :> ReqBody '[JSON] Matter :> Post '[JSON] String

matterServer :: ServerT MatterAPI App
matterServer = getAll :<|> fetch :<|> merge

getAll :: App [Matter]
getAll = runDB findAll

fetch :: Text -> App Matter
fetch _id =
  runDB (getDocument _id)
  >>= maybe (notFound _id) return

merge :: Matter -> App String
merge = runDB . saveFpData

notFound :: Text -> App a
notFound t = throwError $ err500 { errBody = "id not found: " <> toLBS t }
  where
    toLBS = BL.fromStrict . TE.encodeUtf8
