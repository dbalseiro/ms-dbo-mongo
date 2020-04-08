{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE TypeOperators     #-}
{-# LANGUAGE OverloadedStrings #-}

module Matter.API (matterServer, MatterAPI) where

import Servant
import Types
import Matter.Types

type MatterAPI =    "fetch" :> Get '[JSON] Matter
               :<|> "merge" :> ReqBody '[JSON] Matter :> Post '[JSON] ()

matterServer :: ServerT MatterAPI App
matterServer = fetch :<|> merge

fetch :: App Matter
fetch = return $ Matter
  { docketNum       = Just $ DocketNum "1"
  , clientDocketNum = Just $ ClientDocketNum "1"
  , matterNum       = Just $ MatterNum "1"
  , clientNum       = Just $ ClientNum "1"
  }

merge :: Matter -> App ()
merge = const $ return ()

