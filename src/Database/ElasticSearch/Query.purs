module Database.ElasticSearch.Query where

import Database.ElasticSearch.Common (Optional, Cast)
import Foreign.Object (Object, fromHomogeneous)
import Literals (StringLit, stringLit)
import Type.Row.Homogeneous (class Homogeneous)
import Untagged.Castable (class Castable, cast)
import Untagged.Union (type (|+|), asOneOf)

newtype Query = Query
  (   {match :: Object Match}
  |+| {term :: Object Term}
  |+| {range :: Range}
  |+| {bool :: Bool}
  |+| {boosting :: Boosting}
  |+| {dis_max :: DisMax}
  |+| {prefix :: Object Prefix}
  )

type Match =
  { query :: String |+| Number |+| Boolean
  , analyzer :: Optional String
  , auto_generate_synonyms_phrase_query :: Optional Boolean
  , fuzziness :: Optional String
  , max_expansions :: Optional Int
  , prefix_length :: Optional Int
  , fuzzy_transpositions :: Optional Boolean
  , fuzzy_rewrite :: Optional String
  , lenient :: Optional Boolean
  , operator :: Optional Operator
  , minimum_should_match :: Optional String
  , zero_terms_query :: Optional ZeroTermsQuery
  }
  
type Term =
  { value :: String
  , boost :: Optional Number
  , case_insensitive :: Optional Boolean
  }
  
type Range =
  { gte :: Optional (String |+| Number)
  , gt :: Optional (String |+| Number)
  , lte :: Optional (String |+| Number)
  , lt :: Optional (String |+| Number)
  , format :: Optional String
  , relation :: Optional Relation
  , time_zone :: Optional String
  , boost :: Optional Number
  }

type Bool =
  { must :: Optional (Array Query)
  , must_not :: Optional (Array Query)
  , should :: Optional (Array Query)
  , filter :: Optional (Array Query)
  , minimum_should_match :: Optional Int
  , boost :: Optional Number
  }

type Boosting =
  { positive :: Query
  , negative :: Query
  , negative_boost :: Number
  }

type DisMax =
  { queries :: Array Query
  , tie_breaker :: Optional Number
  }

type Prefix =
  { value :: String
  , rewrite :: Optional String
  , case_insensitive :: Optional Boolean
  }

type Operator = StringLit "AND" |+| StringLit "OR"

type ZeroTermsQuery = StringLit "all" |+| StringLit "none"

type Relation =
  StringLit "INTERSECTS"
  |+| StringLit "CONTAINS"
  |+| StringLit "WITHIN"

range :: forall a. Castable a Range => a -> Query
range x = Query (asOneOf {range: cast x :: Range})
  
matches :: forall a. Homogeneous a Match => Record a -> Query
matches x = Query (asOneOf {match: fromHomogeneous x :: Object Match})
  
match :: Cast Match
match = cast
  
terms :: forall a. Homogeneous a Term => Record a -> Query
terms x = Query (asOneOf {term: fromHomogeneous x :: Object Term})
  
term :: Cast Term
term = cast

prefixes :: forall a. Homogeneous a Prefix => Record a -> Query
prefixes x = Query (asOneOf {prefix: fromHomogeneous x :: Object Prefix})
  
prefix :: Cast Prefix
prefix = cast

bool :: forall a. Castable a Bool => a -> Query
bool x = Query (asOneOf {bool: cast x :: Bool})

boosting :: forall a. Castable a Boosting => a -> Query
boosting x = Query (asOneOf {boosting: cast x :: Boosting})

disMax :: forall a. Castable a DisMax => a -> Query
disMax x = Query (asOneOf {dis_max: cast x :: DisMax})

and :: Operator
and = asOneOf (stringLit :: _ "AND")

or :: Operator
or = asOneOf (stringLit :: _ "OR")

returnNone :: ZeroTermsQuery
returnNone = asOneOf (stringLit :: _ "none")

returnAll :: ZeroTermsQuery
returnAll = asOneOf (stringLit :: _ "all")

intersects :: Relation
intersects = asOneOf (stringLit :: _ "INTERSECTS")

contains :: Relation
contains = asOneOf (stringLit :: _ "CONTAINS")

within :: Relation
within = asOneOf (stringLit :: _ "WITHIN")
