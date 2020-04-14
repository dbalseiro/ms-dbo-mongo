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

runDB :: Action IO a -> App a
runDB a = ask >>= liftIO . runDBIO a

runDBIO :: Action IO a -> DBConfig -> IO a
runDBIO a DBConfig{..} = do
  pipe <- doConnect dbSSL (T.unpack dbHost) $ maybe defaultPort PortNumber dbPort
  when dbAuth $ authenticate pipe
  result <- execute pipe a
  close pipe
  return result

  where
    doConnect :: Bool -> HostName -> PortID -> IO Pipe
    doConnect True hostname  = TLS.connect hostname
    doConnect False hostname = connect . Host hostname

    authenticate :: Pipe -> IO ()
    authenticate pipe = execute pipe (auth dbUser dbPass) >>= \case
      True  -> fail "Could not authenticate"
      False -> return ()

    execute :: Pipe -> Action IO a -> IO a
    execute pipe = access pipe master dbName

findAll :: forall a . FpData a => MongoT [a]
findAll = map fromDocument <$> (rest =<< find (select [] (collName @a)))

saveFpData :: forall a . FpData a => a -> MongoT String
saveFpData = fmap show . insert (collName @a) . toDocument

getDocument :: forall a . FpData a => Text -> MongoT (Maybe a)
getDocument tid =
  case readMaybe (T.unpack tid) of
    Nothing  -> return Nothing
    Just oid -> fmap fromDocument <$> findOne (select ["_id" =: ObjId oid] (collName @a))

