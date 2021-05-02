module Database.ElasticSearch.Indices.Create where

import Database.ElasticSearch.Common (Api, Object, api)
import Database.ElasticSearch.Internal as Internal
import Option (Option)

type CreateIndexParamsOpt =
  ( include_type_name :: Boolean
  , wait_for_active_shards :: String
  , timeout :: String
  , master_timeout :: String
  , body :: Option CreateIndexBody
  )

type CreateIndexBody =
  ( aliases :: Object
  , mappings :: Object
  , settings :: Object
  )

createIndex :: Api (index :: String) CreateIndexParamsOpt (acknowledged :: Boolean)
createIndex = api Internal.createIndex
