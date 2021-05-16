module Database.ElasticSearch.Internal where

import Control.Promise (Promise)
import Effect (Effect)

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
