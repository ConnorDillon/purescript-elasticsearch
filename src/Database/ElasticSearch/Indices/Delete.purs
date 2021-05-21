module Database.ElasticSearch.Indices.Delete where

import Database.ElasticSearch.Common (Api, Optional, api)
import Database.ElasticSearch.Internal as Internal
import Database.ElasticSearch.Search (ExpandWildcards)

type DeleteIndexParams =
  ( index :: Array String
  , timeout :: Optional String
  , master_timeout :: Optional String
  , ignore_unavailable :: Optional Boolean
  , allow_no_indices :: Optional Boolean
  , expand_wildcards :: Optional ExpandWildcards
  )

deleteIndex :: Api DeleteIndexParams (acknowledged :: Boolean)
deleteIndex = api Internal.deleteIndex
