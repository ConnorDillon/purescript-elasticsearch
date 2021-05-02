module Database.ElasticSearch.Common where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Argonaut (class EncodeJson, Json, encodeJson)
import Data.Nullable (Nullable)
import Database.ElasticSearch.Client (Client)
import Effect (Effect)
import Effect.Aff (Aff)
import Foreign.Object as Object
import Option (class FromRecord)
import Unsafe.Coerce (unsafeCoerce)

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

api :: forall a b c d. (a -> b -> c -> Effect (Promise d)) -> a -> b -> c -> Aff d
api fn x y = toAffE <<< fn x y

toObject :: forall a. EncodeJson (Record a) => Record a -> Object
toObject = unsafeCoerce <<< encodeJson
