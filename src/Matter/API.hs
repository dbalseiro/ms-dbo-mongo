{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE TypeOperators     #-}
{-# LANGUAGE OverloadedStrings #-}

module Matter.API (matterServer, MatterAPI) where

import Servant
import Matter.Types

type MatterAPI =    "fetch" :> Get '[JSON] Matter
               :<|> "merge" :> ReqBody '[JSON] Matter :> Post '[JSON] ()

matterServer :: Server MatterAPI
matterServer = fetch :<|> merge

fetch :: Handler Matter
fetch = return $ Matter
  { docketNum       = Just $ DocketNum "1"
  , clientDocketNum = Just $ ClientDocketNum "1"
  , matterNum       = Just $ MatterNum "1"
  , clientNum       = Just $ ClientNum "1"
  }

merge :: Matter -> Handler ()
merge = const $ return ()

