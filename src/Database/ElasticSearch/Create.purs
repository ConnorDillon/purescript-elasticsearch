module Database.ElasticSearch.Create where

import Data.Argonaut (Json)
import Database.ElasticSearch.Common (Api, Optional, api)
import Database.ElasticSearch.Index (IndexResult, Refresh, VersionType)
import Database.ElasticSearch.Internal as Internal
import Foreign.Object (Object)

type CreateParams =
  ( index :: String
  , body :: Object Json
  , id :: Optional String
  , waitForActiveShards :: Optional String
  , refresh :: Optional Refresh
  , routing :: Optional String
  , timeout :: Optional String
  , version :: Optional Number
  , versionType :: Optional VersionType
  , pipeline :: Optional String
  )

create :: Api CreateParams IndexResult
create = api Internal.create
