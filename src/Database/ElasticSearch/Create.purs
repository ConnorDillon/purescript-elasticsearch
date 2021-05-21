module Database.ElasticSearch.Create where

import Database.ElasticSearch.Common (Api, Object, Optional, api)
import Database.ElasticSearch.Index (IndexResult)
import Database.ElasticSearch.Internal as Internal

type CreateParams =
  ( index :: String
  , body :: Object
  , id :: Optional String
  , waitForActiveShards :: Optional String
  , refresh :: Optional String -- 'true' | 'false' | 'wait_for'
  , routing :: Optional String
  , timeout :: Optional String
  , version :: Optional Number
  , versionType :: Optional String -- 'internal' | 'external' | 'external_gte'
  , pipeline :: Optional String
  )

create :: Api CreateParams IndexResult
create = api Internal.create
