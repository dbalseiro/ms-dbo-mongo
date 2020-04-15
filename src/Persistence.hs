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

runDB :: MongoMode -> Action IO a -> App a
runDB mode a = ask >>= liftIO . runDBIO mode a

runDBIO :: MongoMode -> Action IO a -> DBConfig -> IO a
runDBIO mode a DBConfig{..} = do
  pipe <- doConnect dbSSL (T.unpack dbHost) $ maybe defaultPort PortNumber dbPort
  when dbAuth $ authenticate pipe
  result <- execute mode pipe a
  close pipe
  return result

  where
    doConnect :: Bool -> HostName -> PortID -> IO Pipe
    doConnect True hostname  = TLS.connect hostname
    doConnect False hostname = connect . Host hostname

    authenticate :: Pipe -> IO ()
    authenticate pipe = execute Write pipe (authSCRAMSHA1 dbUser dbPass) >>= \case
      True  -> fail "Could not authenticate"
      False -> return ()

    execute :: MongoMode -> Pipe -> Action IO a -> IO a
    execute mode' pipe = access pipe (amode mode') dbName

    amode :: MongoMode -> AccessMode
    amode Read = slaveOk
    amode Write = master

findAll :: forall a . FpData a => MongoT [a]
findAll = map fromDocument <$> (rest =<< find (select [] (collName @a)))

saveFpData :: forall a . FpData a => a -> MongoT String
saveFpData = fmap show . insert (collName @a) . toDocument

getDocument :: forall a . FpData a => Text -> MongoT (Maybe a)
getDocument tid =
  case readMaybe (T.unpack tid) of
    Nothing  -> return Nothing
    Just oid -> fmap fromDocument <$> findOne (select ["_id" =: ObjId oid] (collName @a))

