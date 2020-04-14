{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Main where

import System.Environment (getEnv, lookupEnv)
import Data.Text (pack)
import Text.Read (readMaybe)

import Types
import Server

main :: IO ()
main = startApp =<< mkEnv

mkEnv :: IO AppEnv
mkEnv = do
  appPort <- read <$> getEnv "APP_PORT"
  dbHost  <- pack <$> getEnv "DB_HOST"
  dbUser  <- pack <$> getEnv "DB_USER"
  dbPass  <- pack <$> getEnv "DB_PASS"
  dbName  <- pack <$> getEnv "DB_NAME"
  dbAuth  <- (== "true") <$> getEnv "DB_AUTH"
  dbSSL   <- (== "true") <$> getEnv "DB_SSL"
  dbPort  <- (readMaybe =<<) <$> lookupEnv "DB_PORT"
  let dbConfig = DBConfig{..}
  return AppEnv{..}

