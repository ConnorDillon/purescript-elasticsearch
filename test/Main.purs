module Test.Main where

import Prelude

import Database.ElasticSearch (client, createIndex, deleteIndex, index, search, toObject)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Test.Assert (assert')

test :: String -> Aff Boolean -> Aff Unit
test s k = k >>= \r -> liftEffect $ assert' s r *> log ("[OK] " <> s)

main :: Effect Unit
main = launchAff_ $ test "createIndex/index/search/deleteIndex" do
  c <- liftEffect $ client {node: "http://localhost:9200"}
  cr <- createIndex c {index: "foo"} {}
  ir <- index c {index: "foo", refresh: "wait_for", body: toObject {"bar": 1}} {}
  sr <- search c {index: ["foo"]} {}
  dr <- deleteIndex c {index: ["foo"]} {}
  pure $ cr.body.acknowledged
    && ir.body.result == "created"
    && sr.body.took >= 0
    && cr.body.acknowledged
