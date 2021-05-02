module Database.ElasticSearch.Client
  ( client
  , module Client
  ) where

import Database.ElasticSearch.Internal (Client)
import Database.ElasticSearch.Internal as Internal
import Database.ElasticSearch.Internal (Client) as Client
import Effect (Effect)
import Prim.Row (class Union)

client
  :: forall a b
   . Union a b (auth :: {username :: String, password :: String})
  => {node :: String | a}
  -> Effect Client
client = Internal.client
