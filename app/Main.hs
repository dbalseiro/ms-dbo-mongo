{-# LANGUAGE OverloadedStrings #-}

module Main where

import Types
import Server

main :: IO ()
main = startApp $ AppEnv { appPort = 3000, dbConfig = defDBConfig}

defDBConfig :: DBConfig
defDBConfig = DBConfig
  { dbHost = "127.0.0.1"
  , dbUser = "root"
  , dbPass = "root"
  , dbName = "dev"
  }
