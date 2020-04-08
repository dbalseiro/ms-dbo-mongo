{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TypeOperators   #-}

module Server
    ( startApp
    , app
    ) where

import Network.Wai
import Network.Wai.Handler.Warp
import Servant

type API = "healthcheck" :> Get '[JSON] String

startApp :: IO ()
startApp = run 3000 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server = healthcheck

healthcheck :: Handler String
healthcheck = return "I'm OK"

