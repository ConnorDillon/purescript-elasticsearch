module Database.ElasticSearch.Index where

import Database.ElasticSearch.Common (Api, Object, api)
import Database.ElasticSearch.Internal as Internal

type IndexParamsReq =
  ( index :: String
  , body :: Object
  )

type IndexParamsOpt =
  ( id :: String
  , type :: String
  , waitForActiveShards :: String
  , opType :: String -- 'index' | 'create'
  , refresh :: String -- 'true' | 'false' | 'wait_for'
  , routing :: String
  , timeout :: String
  , version :: Number
  , versionType :: String -- 'internal' | 'external' | 'external_gte'
  , ifSeqNo :: Number
  , ifPrimaryTerm :: Number
  , pipeline :: String
  , requireAlias :: Boolean
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

index :: Api IndexParamsReq IndexParamsOpt IndexResult
index = api Internal.index
