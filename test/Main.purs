module Test.Main where

import Prelude

import Database.ElasticSearch (alias, client, createIndex, createIndexBody, deleteIndex, index, long, mapping, search, searchBody, settings, toObject)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Foreign.Object (singleton)
import Test.Assert (assert')

test :: String -> Aff Boolean -> Aff Unit
test s k = k >>= \r -> liftEffect $ assert' s r *> log ("[OK] " <> s)

main :: Effect Unit
main = launchAff_ $ test "createIndex/index/search/deleteIndex" do
  c <- liftEffect $ client {node: "http://localhost:9200"}
  cr <- createIndex c {index: "foo", body: body} {}
  ir <- index c {index: "foo", refresh: "wait_for", body: toObject {"bar": 1}} {}
  sr <- search c {index: ["foo"], body: searchBody {size: 10, _source: true}} {}
  dr <- deleteIndex c {index: ["foo"]} {}
  pure $ cr.body.acknowledged
    && ir.body.result == "created"
    && sr.body.took >= 0
    && cr.body.acknowledged
  where
    body = createIndexBody 
      { aliases: singleton "baz" $ alias
          { is_hidden: true
          , is_write_index: true
          , routing: "shard-1"
          }
      , mappings: {properties: singleton "bar" $ mapping {type: long}}
      , settings: settings {number_of_shards: 1, number_of_replicas: 1}
      }
