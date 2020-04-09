{-# LANGUAGE RecordWildCards     #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications    #-}
{-# LANGUAGE OverloadedStrings   #-}

module Persistence where

import Types

import Control.Monad (void)
import Control.Monad.Trans.Reader (ask)
import Control.Monad.IO.Class (liftIO)

import qualified Data.Text as T
import Data.Text (Text)
import Text.Read (readMaybe)

import Database.MongoDB

runDB :: Action IO a -> App a
runDB a = do
  DBConfig{..} <- ask
  liftIO $ do
    pipe <- connect (host $ T.unpack dbHost)
    void $ access pipe master dbName (auth dbUser dbPass)
    result <- access pipe master dbName a
    close pipe
    return result

findAll :: forall a . FpData a => MongoT [a]
findAll = map fromDocument <$> (rest =<< find (select [] (collName @a)))

saveFpData :: forall a . FpData a => a -> MongoT String
saveFpData = fmap show . insert (collName @a) . toDocument

getDocument :: forall a . FpData a => Text -> MongoT (Maybe a)
getDocument _id =
  case readMaybe (T.unpack _id) of
    Nothing -> return Nothing
    Just i -> fmap fromDocument <$> findOne (select ["_id" =: ObjId i] (collName @a))
