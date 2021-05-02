module Database.ElasticSearch.Search where

import Data.Nullable (Nullable)
import Database.ElasticSearch.Common (Api, Object, api)
import Database.ElasticSearch.Internal as Internal

type SearchParamsOpt =
  ( index :: Array String
  , type :: Array String
  , analyzer :: String
  , analyze_wildcard :: Boolean
  , ccs_minimize_roundtrips :: Boolean
  , default_operator :: String -- 'AND' | 'OR'
  , df :: String
  , explain :: Boolean
  , stored_fields :: Array String
  , docvalue_fields :: Array String
  , from :: Number
  , ignore_unavailable :: Boolean
  , ignore_throttled :: Boolean
  , allow_no_indices :: Boolean
  , expand_wildcards :: String -- 'open' | 'closed' | 'hidden' | 'none' | 'all'
  , lenient :: Boolean
  , preference :: String
  , q :: String
  , routing :: Array String
  , scroll :: String
  , search_type :: String -- 'query_then_fetch' | 'dfs_query_then_fetch'
  , size :: Number
  , sort :: Array String
  , _source :: Array String
  , _source_excludes :: Array String
  , _source_includes :: Array String
  , terminate_after :: Number
  , stats :: Array String
  , suggest_field :: String
  , suggest_mode :: String -- 'missing' | 'popular' | 'always'
  , suggest_size :: Number
  , suggest_text :: String
  , timeout :: String
  , track_scores :: Boolean
  , track_total_hits :: Boolean
  , allow_partial_search_results :: Boolean
  , typed_keys :: Boolean
  , version :: Boolean
  , seq_no_primary_term :: Boolean
  , request_cache :: Boolean
  , batched_reduce_size :: Number
  , max_concurrent_shard_requests :: Number
  , pre_filter_shard_size :: Number
  , rest_total_hits_as_int :: Boolean
  , min_compatible_shard_node :: String
  , body :: Object
  )

type SearchResult =
  ( _scroll_id :: Nullable String
  , took :: Int
  , timed_out :: Boolean
  , _shards ::
      { total :: Int
      , successful :: Int
      , skipped :: Int
      , failed :: Int
      }
  , hits ::
      { total ::
          { value :: Int
          , relation :: String
          }
      , max_score :: Nullable Number
      , hits :: Array
          { _index :: String
          , _type :: String
          , _id :: String
          , _score :: Int
          , _source :: Nullable Object
          , fields :: Nullable Object
          }
      }
  )

search :: Api () SearchParamsOpt SearchResult
search = api Internal.search
