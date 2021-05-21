module Database.ElasticSearch.Delete where

import Database.ElasticSearch.Common (Api, Optional, api)
import Database.ElasticSearch.Index (IndexResult)
import Database.ElasticSearch.Internal as Internal

type DeleteParams =
  ( index :: String
  , id :: String
  , waitForActiveShards :: Optional String
  , refresh :: Optional String -- 'true' | 'false' | 'wait_for'
  , routing :: Optional String
  , timeout :: Optional String
  , version :: Optional Number
  , versionType :: Optional String -- 'internal' | 'external' | 'external_gte'
  , ifSeqNo :: Optional Number
  , ifPrimaryTerm :: Optional Number
  )

delete :: Api DeleteParams IndexResult
delete = api Internal.delete
