module Main where

import Types
import Server

main :: IO ()
main = startApp $ AppEnv { appPort = 3000, dbConfig = undefined }
