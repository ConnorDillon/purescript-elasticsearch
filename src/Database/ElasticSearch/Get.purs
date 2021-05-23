module Database.ElasticSearch.Get where

import Data.Argonaut (Json)
import Database.ElasticSearch.Common (Api, Optional, api)
import Database.ElasticSearch.Index (VersionType)
import Database.ElasticSearch.Internal as Internal
import Foreign.Object (Object)

type GetParams =
  ( id :: String
  , index :: String
  , stored_fields :: Optional (Array String)
  , preference :: Optional String
  , realtime :: Optional Boolean
  , refresh :: Optional Boolean
  , routing :: Optional String
  , _source :: Optional (Array String)
  , _source_excludes :: Optional (Array String)
  , _source_includes :: Optional (Array String)
  , version :: Optional Number
  , version_type :: Optional VersionType
  )

type GetResult =
  ( _index :: String
  , _type :: String
  , _id :: String
  , _version :: Int
  , _seq_no :: Int
  , _primary_term :: Int
  , found :: Boolean
  , _routing :: Optional String
  , _source :: Optional (Object Json)
  , _fields :: Optional (Object Json)
  )

get :: Api GetParams GetResult
get = api Internal.get
