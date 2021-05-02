module Database.ElasticSearch.Indices.Delete where

import Database.ElasticSearch.Common (Api, api)
import Database.ElasticSearch.Internal as Internal

type DeleteIndexParamsOpt =
  ( timeout :: String
  , master_timeout :: String
  , ignore_unavailable :: Boolean
  , allow_no_indices :: Boolean
  , expand_wildcards :: String -- 'open' | 'closed' | 'hidden' | 'none' | 'all'
  )

deleteIndex :: Api (index :: Array String) DeleteIndexParamsOpt (acknowledged :: Boolean)
deleteIndex = api Internal.deleteIndex
