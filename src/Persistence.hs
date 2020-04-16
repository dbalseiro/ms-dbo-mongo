{-# LANGUAGE RecordWildCards     #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications    #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE LambdaCase          #-}

module Persistence where

import Types

import Control.Monad (when)
import Control.Monad.Trans.Reader (ask)
import Control.Monad.IO.Class (liftIO)

import qualified Data.Text as T
import Data.Text (Text)
import Text.Read (readMaybe)

import Network.Socket (HostName)
import Database.MongoDB
import qualified Database.MongoDB.Transport.Tls as TLS

import Debug.Trace

runDB :: MongoMode -> Action IO a -> App a
runDB mode a = ask >>= liftIO . runDBIO mode a

runDBIO :: MongoMode -> Action IO a -> DBConfig -> IO a
runDBIO mode action DBConfig{..} = do
  pipe <- doConnect dbSSL (T.unpack dbHost) $ maybe defaultPort PortNumber dbPort
  result <- access pipe (accessmode mode) dbName (authenticate >> action)
  close pipe
  return result

  where
    doConnect :: Bool -> HostName -> PortID -> IO Pipe
    doConnect True hostname  = TLS.connect hostname
    doConnect False hostname = connect . Host hostname

    authenticate :: Action IO ()
    authenticate = when dbAuth $ authMongoCR dbUser dbPass >>= \case
      False  -> fail "Could not authenticate"
      True   -> return ()

    accessmode :: MongoMode -> AccessMode
    accessmode Read = master
    accessmode Write = master

findAll :: forall a . FpData a => MongoT [a]
findAll = map fromDocument . traceShowId <$> (rest =<< find (select [] (collName @a)))

saveFpData :: forall a . FpData a => a -> MongoT String
saveFpData = fmap show . insert (collName @a) . toDocument

getDocument :: forall a . FpData a => Text -> MongoT (Maybe a)
getDocument tid =
  case readMaybe (T.unpack tid) of
    Nothing  -> return Nothing
    Just oid -> fmap fromDocument <$> findOne (select ["_id" =: ObjId oid] (collName @a))

