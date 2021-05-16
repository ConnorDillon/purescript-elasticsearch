module Database.ElasticSearch.Search where

import Data.Argonaut (Json)
import Data.Nullable (Nullable)
import Database.ElasticSearch.Common (Api, DataType, api)
import Database.ElasticSearch.Internal as Internal
import Foreign.Object (Object)
import Literals (StringLit, stringLit)
import Option (Option)
import Untagged.Union (type (|+|), UndefinedOr, asOneOf)

type DefaultOperator = StringLit "AND" |+| StringLit "OR"

type ExpandWildcards =
  StringLit "open"
  |+| StringLit "closed"
  |+| StringLit "hidden"
  |+| StringLit "none"
  |+| StringLit "all"

type SearchType = StringLit "query_then_fetch" |+| StringLit "dfs_query_then_fetch"

type SuggestMode = StringLit "missing" |+| StringLit "popular" |+| StringLit "always"

type SearchParamsOpt =
  ( index :: Array String
  , type :: Array String
  , analyzer :: String
  , analyze_wildcard :: Boolean
  , ccs_minimize_roundtrips :: Boolean
  , default_operator :: DefaultOperator
  , df :: String
  , explain :: Boolean
  , stored_fields :: Array String
  , docvalue_fields :: Array String
  , from :: Number
  , ignore_unavailable :: Boolean
  , ignore_throttled :: Boolean
  , allow_no_indices :: Boolean
  , expand_wildcards :: ExpandWildcards
  , lenient :: Boolean
  , preference :: String
  , q :: String
  , routing :: Array String
  , scroll :: String
  , search_type :: SearchType
  , size :: Number
  , sort :: Array String
  , _source :: Array String
  , _source_excludes :: Array String
  , _source_includes :: Array String
  , terminate_after :: Number
  , stats :: Array String
  , suggest_field :: String
  , suggest_mode :: SuggestMode
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
  , body :: Option SearchBody
  )

type Fields = Array (String |+| {field :: String, format :: UndefinedOr String})

type SearchBody =
  ( docvalue_fields :: Fields
  , fields :: Fields
  , explain :: Boolean
  , from :: Int
  , indices_boost :: Array (Object Number)
  , min_score :: Number
  , pit :: {id :: String, keep_alive :: UndefinedOr String}
  , query :: Object Json
  , runtime_mappings :: Object {type :: DataType, script :: UndefinedOr String}
  , seq_no_primary_term :: Boolean
  , size :: Int
  , _source :: Boolean |+| Array String |+| {excludes :: Array String, includes :: Array String}
  , stats :: Array String
  , terminate_after :: Int
  , timeout :: String
  , version :: Boolean
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
          , _source :: Nullable (Object Json)
          , fields :: Nullable (Object Json)
          }
      }
  )

search :: Api () SearchParamsOpt SearchResult
search = api Internal.search

and :: DefaultOperator
and = asOneOf (stringLit :: _ "AND")

or :: DefaultOperator
or = asOneOf (stringLit :: _ "OR")

missing :: SuggestMode
missing = asOneOf (stringLit :: _ "missing")

popular :: SuggestMode
popular = asOneOf (stringLit :: _ "popular")

always :: SuggestMode
always = asOneOf (stringLit :: _ "always")

queryThenFetch :: SearchType
queryThenFetch = asOneOf (stringLit :: _ "query_then_fetch")

dfsQueryThenFetch :: SearchType
dfsQueryThenFetch = asOneOf (stringLit :: _ "dfs_query_then_fetch")

open :: ExpandWildcards
open = asOneOf (stringLit :: _ "open")

closed :: ExpandWildcards
closed = asOneOf (stringLit :: _ "closed")

hidden :: ExpandWildcards
hidden = asOneOf (stringLit :: _ "hidden")

none :: ExpandWildcards
none = asOneOf (stringLit :: _ "none")

all :: ExpandWildcards
all = asOneOf (stringLit :: _ "all")
