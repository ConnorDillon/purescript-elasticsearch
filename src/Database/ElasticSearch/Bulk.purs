module Database.ElasticSearch.Bulk where

import Data.Argonaut (class EncodeJson, Json)
import Database.ElasticSearch.Common (Api, Optional, api, toObject)
import Database.ElasticSearch.Index (Refresh)
import Database.ElasticSearch.Internal as Internal
import Foreign.Object (Object)
import Untagged.Castable (class Castable, cast)
import Untagged.Union (type (|+|), asOneOf)

type BulkParams =
  ( index :: String
  , body :: BulkBody
  , waitForActiveShards :: Optional String
  , _source :: Optional (Array String)
  , _sourceExcludes :: Optional (Array String)
  , _sourceIncludes :: Optional (Array String)
  , refresh :: Optional Refresh
  , routing :: Optional String
  , timeout :: Optional String
  , requireAlias :: Optional Boolean
  , pipeline :: Optional String
  )

type BulkBody = Array Action

type BulkDeleteParams =
  { _id :: String
  , _index :: Optional String
  , require_alias :: Optional Boolean
  }

type BulkIndexParams =
  { _index :: Optional String
  , _id :: Optional String
  , require_alias :: Optional Boolean
  , dynamic_templates :: Optional (Object Json)
  }

type BulkCreateParams = BulkIndexParams

type BulkUpdateParams =
  { _id :: String
  , _index :: Optional String
  , require_alias :: Optional Boolean
  }

type Action =
  {create :: BulkCreateParams}
  |+| {delete :: BulkDeleteParams}
  |+| {index :: BulkIndexParams}
  |+| {update :: BulkUpdateParams}
  |+| {doc :: Object Json}
  |+| Object Json

type BulkResult =
  ( took :: Int
  , errors :: Boolean
  , items :: Array ActionResult
  )

type ActionResult =
  { _shards ::
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
  , status :: Int
  , error :: Optional Error
  }

type Error =
  { type :: String
  , reason :: String
  , index_uuid :: String
  , index :: String
  }

bulkCreate
  :: forall a b
   . Castable a BulkCreateParams
  => EncodeJson (Record b)
  => a
  -> Record b
  -> BulkBody  
bulkCreate x y = [asOneOf {create: cast x :: BulkCreateParams}, asOneOf (toObject y)]

bulkIndex
  :: forall a b
   . Castable a BulkIndexParams
  => EncodeJson (Record b)
  => a
  -> Record b
  -> BulkBody  
bulkIndex x y = [asOneOf {index: cast x :: BulkIndexParams}, asOneOf (toObject y)]

bulkDelete :: forall a. Castable a BulkDeleteParams => a -> BulkBody  
bulkDelete x = [asOneOf {delete: cast x :: BulkDeleteParams}]

bulkUpdate
  :: forall a b
   . Castable a BulkUpdateParams
  => EncodeJson (Record b)
  => a
  -> Record b
  -> BulkBody  
bulkUpdate x y = [asOneOf {update: cast x :: BulkUpdateParams}, asOneOf {doc: (toObject y)}]

bulk :: Api BulkParams BulkResult
bulk = api Internal.bulk
