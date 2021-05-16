module Database.ElasticSearch.Index where

import Database.ElasticSearch.Common (Api, Object, Optional, api)
import Database.ElasticSearch.Internal as Internal

type IndexParams =
  ( index :: String
  , body :: Object
  , id :: Optional String
  , type :: Optional String
  , waitForActiveShards :: Optional String
  , opType :: Optional String -- 'index' | 'create'
  , refresh :: Optional String -- 'true' | 'false' | 'wait_for'
  , routing :: Optional String
  , timeout :: Optional String
  , version :: Optional Number
  , versionType :: Optional String -- 'internal' | 'external' | 'external_gte'
  , ifSeqNo :: Optional Number
  , ifPrimaryTerm :: Optional Number
  , pipeline :: Optional String
  , requireAlias :: Optional Boolean
  )

type IndexResult =
  ( _shards ::
      { total :: Int
      , successful :: Int
      , failed :: Int
      }
  , _index :: String
  , _type :: String
  , _id :: String
  , _version :: Int
  , _seq_no :: Int
  , _primary_term :: Int
  , result :: String -- 'createed' | 'updated'
  )

index :: Api IndexParams IndexResult
index = api Internal.index
