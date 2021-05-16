module Database.ElasticSearch.Client
  ( client
  , module Client
  ) where

import Database.ElasticSearch.Internal (Auth, Client)
import Database.ElasticSearch.Internal (Auth, Client, user, apiKey, apiKeyObject) as Client
import Database.ElasticSearch.Internal as Internal
import Effect (Effect)
import Option (class FromRecord)

client
  :: forall a
   . FromRecord a (node :: String) (auth :: Auth)
  => Record a
  -> Effect Client
client = Internal.client

cloudClient :: {cloud :: {id :: String}, auth :: Auth} -> Effect Client
cloudClient = Internal.client
