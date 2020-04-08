{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Server (app)
import Test.Hspec
import Test.Hspec.Wai

main :: IO ()
main = hspec spec

spec :: Spec
spec = with (return app) $ do
  describe "GET /healthcheck" $
    it "responds with 200" $
      get "/healthcheck" `shouldRespondWith` 200
  describe "GET /matter/fetch" $
    it "responds with 200" $
      get "/healthcheck" `shouldRespondWith` 200
