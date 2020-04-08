{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TypeOperators   #-}

module Server (startApp, app) where

import Network.Wai
import Network.Wai.Handler.Warp

import System.IO (hPutStrLn, stderr)

import Servant
import Matter

type API =    "healthcheck" :> Get '[JSON] String
         :<|> "matter" :> MatterAPI

startApp :: Port -> IO ()
startApp port = do
  hPutStrLn stderr $ "Running on port " ++ show port
  run port app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server = healthcheck :<|> matterServer

healthcheck :: Handler String
healthcheck = return "I'm OK"

