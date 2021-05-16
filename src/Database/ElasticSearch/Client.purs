module Database.ElasticSearch.Client
  ( client
  , module Client
  , apiKey
  , ApiKey
  , Auth
  ) where

import Database.ElasticSearch.Internal (Client)
import Database.ElasticSearch.Internal (Client) as Client
import Database.ElasticSearch.Internal as Internal
import Effect (Effect)
import Untagged.Castable (class Castable)
import Untagged.Union (type (|+|), UndefinedOr, asOneOf)

type Auth = {username :: String, password :: String} |+| {apiKey :: ApiKey}

type ApiKey = String |+| {id :: String, api_key :: String}

apiKey :: forall a. Castable a ApiKey => a -> Auth
apiKey x = asOneOf {apiKey: asOneOf x :: ApiKey}

client
  :: forall a
   . Castable (Record a) {node :: String, auth :: UndefinedOr Auth}
  => Record a
  -> Effect Client
client = Internal.client

cloudClient :: {cloud :: {id :: String}, auth :: Auth} -> Effect Client
cloudClient = Internal.client
