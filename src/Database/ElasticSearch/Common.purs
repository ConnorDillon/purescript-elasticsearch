module Database.ElasticSearch.Common where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Argonaut (class EncodeJson, Json, encodeJson)
import Data.Nullable (Nullable)
import Database.ElasticSearch.Client (Client)
import Effect (Effect)
import Effect.Aff (Aff)
import Foreign.Object as Object
import Literals (StringLit, stringLit)
import Option (class FromRecord)
import Unsafe.Coerce (unsafeCoerce)
import Untagged.Union (type (|+|), asOneOf)

type Object = Object.Object Json

type Response a =
  { body :: Record a
  , headers :: Object
  , meta :: Object
  , statusCode :: Int
  , warnings :: Nullable (Array String)
  }

type RequestParams =
  ( ignore :: Array Number
  , maxRetries :: Number
  )

type CommonParams a =
  ( pretty :: Boolean
  , human :: Boolean
  , error_trace :: Boolean
  , source :: String
  , filter_path :: Array Json
  | a
  )

type Api a b c
   = forall d e
   . FromRecord d a (CommonParams b)
  => FromRecord e () RequestParams
  => Client
  -> Record d
  -> Record e
  -> Aff (Response c)

type DataType =
  StringLit "boolean"
  |+| StringLit "date"
  |+| StringLit "double"
  |+| StringLit "geo_point"
  |+| StringLit "ip"
  |+| StringLit "keyword"
  |+| StringLit "long"

api :: forall a b c d. (a -> b -> c -> Effect (Promise d)) -> a -> b -> c -> Aff d
api fn x y = toAffE <<< fn x y

toObject :: forall a. EncodeJson (Record a) => Record a -> Object
toObject = unsafeCoerce <<< encodeJson

boolean :: DataType
boolean = asOneOf (stringLit :: _ "boolean")

date :: DataType
date = asOneOf (stringLit :: _ "date")

double :: DataType
double = asOneOf (stringLit :: _ "double")

geo_point :: DataType
geo_point = asOneOf (stringLit :: _ "geo_point")

ip :: DataType
ip = asOneOf (stringLit :: _ "ip")

keyword :: DataType
keyword = asOneOf (stringLit :: _ "keyword")

long :: DataType
long = asOneOf (stringLit :: _ "long")
