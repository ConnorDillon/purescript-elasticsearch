module Database.ElasticSearch.Indices.Create where

import Database.ElasticSearch.Common (Api, api)
import Database.ElasticSearch.Internal as Internal
import Foreign.Object (Object)
import Option (Option)

type CreateIndexParamsOpt =
  ( include_type_name :: Boolean
  , wait_for_active_shards :: String
  , timeout :: String
  , master_timeout :: String
  , body :: Option CreateIndexBody
  )

type CreateIndexBody =
  ( aliases :: Object (Option AliasParams)
  , mappings :: {properties :: Object {type :: String}}
  , settings :: Option (number_of_shards :: Int, number_of_replicas :: Int)
  )

type AliasParams =
  ( routing :: String
  , index_routing :: String
  , search_routing :: String
  , is_hidden :: Boolean
  , is_write_index :: Boolean
  )

createIndex :: Api (index :: String) CreateIndexParamsOpt (acknowledged :: Boolean)
createIndex = api Internal.createIndex
