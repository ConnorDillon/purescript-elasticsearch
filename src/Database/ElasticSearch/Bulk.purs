module Database.ElasticSearch.Bulk where

import Database.ElasticSearch.Common (Api, Object, Optional, api)
import Database.ElasticSearch.Index (Refresh)
import Database.ElasticSearch.Internal as Internal
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

type DeleteParams =
  { _id :: String
  , _index :: Optional String
  , require_alias :: Optional Boolean
  }

type IndexParams =
  { _index :: Optional String
  , _id :: Optional String
  , require_alias :: Optional Boolean
  , dynamic_templates :: Optional Object
  }

type CreateParams = IndexParams

type UpdateParams =
  { _id :: String
  , _index :: Optional String
  , require_alias :: Optional Boolean
  }

type Action =
  {create :: CreateParams}
  |+| {delete :: DeleteParams}
  |+| {index :: IndexParams}
  |+| {update :: UpdateParams}
  |+| {doc :: Object}
  |+| Object

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

create :: forall a. Castable a CreateParams => a -> Object -> BulkBody  
create x y = [asOneOf {create: cast x :: CreateParams}, asOneOf y]

index :: forall a. Castable a IndexParams => a -> Object -> BulkBody  
index x y = [asOneOf {index: cast x :: IndexParams}, asOneOf y]

delete :: forall a. Castable a DeleteParams => a -> BulkBody  
delete x = [asOneOf {delete: cast x :: DeleteParams}]

update :: forall a. Castable a UpdateParams => a -> Object -> BulkBody  
update x y = [asOneOf {update: cast x :: UpdateParams}, asOneOf {doc: y}]

bulk :: Api BulkParams BulkResult
bulk = api Internal.bulk
