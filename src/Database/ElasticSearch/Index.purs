module Database.ElasticSearch.Index where

import Database.ElasticSearch.Common (Api, Object, Optional, api)
import Database.ElasticSearch.Internal as Internal
import Literals (StringLit, stringLit)
import Prelude ((==))
import Untagged.Union (type (|+|), asOneOf)

type IndexParams =
  ( index :: String
  , body :: Object
  , id :: Optional String
  , type :: Optional String
  , waitForActiveShards :: Optional String
  , opType :: Optional OpType
  , refresh :: Optional Refresh
  , routing :: Optional String
  , timeout :: Optional String
  , version :: Optional Number
  , versionType :: Optional VersionType
  , ifSeqNo :: Optional Number
  , ifPrimaryTerm :: Optional Number
  , pipeline :: Optional String
  , requireAlias :: Optional Boolean
  )

type OpType =
  StringLit "index"
  |+| StringLit "create"

type Refresh =
  StringLit "true"
  |+| StringLit "false"
  |+| StringLit "wait_for"

type VersionType =
  StringLit "internal"
  |+| StringLit "external"
  |+| StringLit "external_gte"

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
  , result :: String
  )

index :: Api IndexParams IndexResult
index = api Internal.index

indexOp :: OpType
indexOp = asOneOf (stringLit :: _ "index")

createOp :: OpType
createOp = asOneOf (stringLit :: _ "create")

internal :: VersionType
internal = asOneOf (stringLit :: _ "internal")

external :: VersionType
external = asOneOf (stringLit :: _ "external")

externalGte :: VersionType
externalGte = asOneOf (stringLit :: _ "external_gte")

refreshTrue :: Refresh
refreshTrue = asOneOf (stringLit :: _ "true")

refreshFalse :: Refresh
refreshFalse = asOneOf (stringLit :: _ "false")

waitFor :: Refresh
waitFor = asOneOf (stringLit :: _ "wait_for")
