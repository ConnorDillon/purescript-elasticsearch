module Database.ElasticSearch.Internal where

import Prelude

import Control.Promise (Promise)
import Effect (Effect)
import Option (class InsertOption, Option, fromRecord, insert', optional, required)
import Option as Option
import Prim.RowList (class RowToList)
import Unsafe.Coerce (unsafeCoerce)

foreign import data Client :: Type

foreign import client :: forall a. Record a -> Effect Client

type ForeignApi
   = forall a b c
   . Client
  -> Record a
  -> Record b
  -> Effect (Promise (Record c))

foreign import search :: ForeignApi

foreign import createIndex :: ForeignApi

foreign import deleteIndex :: ForeignApi

foreign import index :: ForeignApi

fromOption :: forall a. Option a -> Record a
fromOption = unsafeCoerce

fromOptionRecord
  :: forall a b c d
   . RowToList c d
  => InsertOption d c a b
  => Option.Record c a
  -> Record b
fromOptionRecord r = fromOption $ insert' (required r) (optional r)

