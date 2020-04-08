{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE NamedFieldPuns  #-}

module Server (startApp, app) where

import Network.Wai
import Network.Wai.Handler.Warp

import Control.Monad.Trans.Reader (runReaderT)

import System.IO (hPutStrLn, stderr)

import Servant
import Types
import Matter

type API =    "healthcheck" :> Get '[JSON] String
         :<|> "matter" :> MatterAPI

startApp :: AppEnv -> IO ()
startApp AppEnv{appPort, dbConfig} = do
  hPutStrLn stderr $ "Running on port " ++ show appPort
  run appPort (app dbConfig)

app :: DBConfig -> Application
app dbconf = serve api $ hoistServer api (`runReaderT` dbconf) server

api :: Proxy API
api = Proxy

server :: ServerT API App
server = healthcheck :<|> matterServer

healthcheck :: App String
healthcheck = return "I'm OK"

