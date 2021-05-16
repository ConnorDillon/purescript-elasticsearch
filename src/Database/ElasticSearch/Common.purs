module Database.ElasticSearch.Common where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Argonaut (class EncodeJson, Json, encodeJson)
import Database.ElasticSearch.Client (Client)
import Effect (Effect)
import Effect.Aff (Aff)
import Foreign.Object as Object
import Literals (StringLit, stringLit)
import Unsafe.Coerce (unsafeCoerce)
import Untagged.Castable (class Castable)
import Untagged.Union (type (|+|), UndefinedOr, asOneOf)

type Optional a = UndefinedOr a

type Object = Object.Object Json

type Response a =
  { body :: Record a
  , headers :: Object
  , meta :: Object
  , statusCode :: Int
  , warnings :: Optional (Array String)
  }

type RequestParams =
  { ignore :: Optional (Array Number)
  , maxRetries :: Optional Number
  }

type CommonParams a =
  { pretty :: Optional Boolean
  , human :: Optional Boolean
  , error_trace :: Optional Boolean
  , source :: Optional String
  , filter_path :: Optional (Array Json)
  | a
  }

type Api a b
   = forall c d
   . Castable (Record c) (CommonParams a)
  => Castable (Record d) RequestParams
  => Client
  -> Record c
  -> Record d
  -> Aff (Response b)

type DataType =
  StringLit "boolean"
  |+| StringLit "date"
  |+| StringLit "double"
  |+| StringLit "geo_point"
  |+| StringLit "ip"
  |+| StringLit "keyword"
  |+| StringLit "long"

type Cast a = forall b. Castable b a => b -> a 

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
