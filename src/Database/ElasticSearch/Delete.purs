module Database.ElasticSearch.Delete where

import Database.ElasticSearch.Common (Api, Optional, api)
import Database.ElasticSearch.Index (IndexResult, VersionType, Refresh)
import Database.ElasticSearch.Internal as Internal

type DeleteParams =
  ( index :: String
  , id :: String
  , waitForActiveShards :: Optional String
  , refresh :: Optional Refresh
  , routing :: Optional String
  , timeout :: Optional String
  , version :: Optional Number
  , versionType :: Optional VersionType
  , ifSeqNo :: Optional Number
  , ifPrimaryTerm :: Optional Number
  )

delete :: Api DeleteParams IndexResult
delete = api Internal.delete
