module Database.ElasticSearch.Update where

import Data.Argonaut (class EncodeJson, Json)
import Database.ElasticSearch.Common (Api, Optional, api, toObject)
import Database.ElasticSearch.Index (IndexResult, Refresh)
import Database.ElasticSearch.Internal as Internal
import Foreign.Object (Object)
import Untagged.Castable (class Castable)
import Untagged.Union (type (|+|), asOneOf)

type UpdateParams =
  ( id :: String
  , index :: String
  , body :: UpdateBody
  , waitForActiveShards :: Optional String
  , _source :: Optional (Array String)
  , _sourceExcludes :: Optional (Array String)
  , _sourceIncludes :: Optional (Array String)
  , lang :: Optional String
  , refresh :: Optional Refresh
  , retryOnConflict :: Optional Number
  , routing :: Optional String
  , timeout :: Optional String
  , ifSeqNo :: Optional Number
  , ifPrimaryTerm :: Optional Number
  , requireAlias :: Optional Boolean
  )

type Script = String |+| {source :: String, lang :: String, params :: Object Json}

type UpdateBody = {doc :: Object Json} |+| {script :: Script}

doc :: forall a. EncodeJson (Record a) => Record a -> UpdateBody
doc x = asOneOf {doc: (toObject x)}

script :: forall a. Castable a Script => a -> UpdateBody
script x = asOneOf {script: asOneOf x :: Script}

update :: Api UpdateParams IndexResult
update = api Internal.update
