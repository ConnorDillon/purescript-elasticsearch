module Database.ElasticSearch.Search where

import Data.Argonaut (Json)
import Database.ElasticSearch.Common (Api, DataType, Optional, Cast, api)
import Database.ElasticSearch.Internal as Internal
import Database.ElasticSearch.Query (Operator, Query)
import Foreign.Object (Object)
import Literals (StringLit, stringLit)
import Untagged.Castable (cast)
import Untagged.Union (type (|+|), UndefinedOr, asOneOf)

type ExpandWildcards =
  StringLit "open"
  |+| StringLit "closed"
  |+| StringLit "hidden"
  |+| StringLit "none"
  |+| StringLit "all"

type SearchType = StringLit "query_then_fetch" |+| StringLit "dfs_query_then_fetch"

type SuggestMode = StringLit "missing" |+| StringLit "popular" |+| StringLit "always"

type SearchParamsOpt =
  ( index :: Optional (Array String)
  , type :: Optional (Array String)
  , analyzer :: Optional String
  , analyze_wildcard :: Optional Boolean
  , ccs_minimize_roundtrips :: Optional Boolean
  , default_operator :: Optional Operator
  , df :: Optional String
  , explain :: Optional Boolean
  , stored_fields :: Optional (Array String)
  , docvalue_fields :: Optional (Array String)
  , from :: Optional Number
  , ignore_unavailable :: Optional Boolean
  , ignore_throttled :: Optional Boolean
  , allow_no_indices :: Optional Boolean
  , expand_wildcards :: Optional ExpandWildcards
  , lenient :: Optional Boolean
  , preference :: Optional String
  , q :: Optional String
  , routing :: Optional (Array String)
  , scroll :: Optional String
  , search_type :: Optional SearchType
  , size :: Optional Number
  , sort :: Optional (Array String)
  , _source :: Optional (Array String)
  , _source_excludes :: Optional (Array String)
  , _source_includes :: Optional (Array String)
  , terminate_after :: Optional Number
  , stats :: Optional (Array String)
  , suggest_field :: Optional String
  , suggest_mode :: Optional SuggestMode
  , suggest_size :: Optional Number
  , suggest_text :: Optional String
  , timeout :: Optional String
  , track_scores :: Optional Boolean
  , track_total_hits :: Optional Boolean
  , allow_partial_search_results :: Optional Boolean
  , typed_keys :: Optional Boolean
  , version :: Optional Boolean
  , seq_no_primary_term :: Optional Boolean
  , request_cache :: Optional Boolean
  , batched_reduce_size :: Optional Number
  , max_concurrent_shard_requests :: Optional Number
  , pre_filter_shard_size :: Optional Number
  , rest_total_hits_as_int :: Optional Boolean
  , min_compatible_shard_node :: Optional String
  , body :: Optional SearchBody
  )

type Fields = Array (String |+| {field :: String, format :: UndefinedOr String})

type Pit = {id :: String, keep_alive :: Optional String}

type RuntimeMapping = {type :: DataType, script :: UndefinedOr String}

type SearchSource = Boolean |+| Array String |+| {excludes :: Array String, includes :: Array String}

type SearchBody =
  { docvalue_fields :: Optional Fields
  , fields :: Optional Fields
  , explain :: Optional Boolean
  , from :: Optional Int
  , indices_boost :: Optional (Array (Object Number))
  , min_score :: Optional Number
  , pit :: Optional Pit
  , query :: Optional Query
  , runtime_mappings :: Optional (Object RuntimeMapping)
  , seq_no_primary_term :: Optional Boolean
  , size :: Optional Int
  , _source :: Optional SearchSource
  , stats :: Optional (Array String)
  , terminate_after :: Optional Int
  , timeout :: Optional String
  , version :: Optional Boolean
  }

type SearchResult =
  ( _scroll_id :: Optional String
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
      , max_score :: Optional Number
      , hits :: Array
          { _index :: String
          , _type :: String
          , _id :: String
          , _score :: Int
          , _source :: Optional (Object Json)
          , fields :: Optional (Object Json)
          }
      }
  )

pit :: Cast Pit
pit = cast

runtimeMapping :: Cast RuntimeMapping
runtimeMapping = cast

searchBody :: Cast SearchBody
searchBody = cast

search :: Api SearchParamsOpt SearchResult
search = api Internal.search

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
