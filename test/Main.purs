module Test.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Database.ElasticSearch (Client, alias, client, createIndex, createIndexBody, deleteIndex, index, long, mapping, search, searchBody, settings, toObject)
import Database.ElasticSearch.Bulk (bulk)
import Database.ElasticSearch.Bulk as Bulk
import Database.ElasticSearch.Create (create)
import Database.ElasticSearch.Delete (delete)
import Database.ElasticSearch.Get (get)
import Database.ElasticSearch.Update (update)
import Effect (Effect)
import Effect.Aff (Aff, finally, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Foreign.Object (singleton, union)
import Test.Assert (assert')
import Untagged.Union (uorToMaybe)

test :: String -> Aff Boolean -> Aff Unit
test s k = k >>= \r -> liftEffect $ assert' s r *> log ("[OK] " <> s)

fixture :: forall a. (Client -> String -> Aff a) -> Aff a
fixture fn = do
  c <- liftEffect $ client {node: "http://localhost:9200"}
  finally (void $ deleteIndex c {index: ["foo"]} {}) $ fn c "foo"

testCreateIndexIndexSearchDeleteIndex :: Client -> String -> Aff Unit
testCreateIndexIndexSearchDeleteIndex c idx = test "createIndex/index/search/deleteIndex" do
  cr <- createIndex c {index: idx, body: body} {}
  ir <- index c {index: idx, refresh: "wait_for", body: toObject {"bar": 1}} {}
  sr <- search c {index: [idx], body: searchBody {size: 10, _source: true}} {}
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

testCreateUpdateGetDelete :: Client -> String -> Aff Unit
testCreateUpdateGetDelete c idx = test "create/update/get/delete" do
  _ <- createIndex c {index: idx} {}
  cr <- create c {index: idx, refresh: "wait_for", id: id, body: source} {}
  gr1 <- get c {id: id, index: idx} {}
  ur <- update c {id: id, index: idx, body: {doc: patch}, refresh: "wait_for"} {}
  gr2 <- get c {id: id, index: idx} {}
  dr <- delete c {id: id, index: idx, refresh: "wait_for"} {}
  sr <- search c {index: [idx]} {}
  pure $
    uorToMaybe gr1.body._source == Just source
    && uorToMaybe gr2.body._source == Just (union source patch)
    && dr.body.result == "deleted"
    && sr.body.hits.total.value == 0
  where
    id = "bar"
    source = toObject {"baz": 1}
    patch = toObject {"quux": 1}

testBulk :: Client -> String -> Aff Unit
testBulk c idx = test "bulk" do
  _ <- createIndex c {index: idx} {}
  br1 <- runBulk $ Bulk.create {_id: "foo1"} (toObject {"bar": 1})
                    <> Bulk.index {_id: "foo2"} (toObject {"baz": 2})
  br2 <- runBulk $ Bulk.update {_id: "foo1"} (toObject {"bar": 3})
                    <> Bulk.update {_id: "foo2"} (toObject {"baz": 4})
  gr1 <- get c {id: "foo1", index: idx} {}
  gr2 <- get c {id: "foo2", index: idx} {}
  br3 <- runBulk $ Bulk.delete {_id: "foo1"} <> Bulk.delete {_id: "foo2"}
  sr <- search c {index: [idx]} {}
  pure $
    not br1.body.errors
    && not br2.body.errors
    && not br3.body.errors
    && uorToMaybe gr1.body._source == Just (toObject {"bar": 3})
    && uorToMaybe gr2.body._source == Just (toObject {"baz": 4})
    && sr.body.hits.total.value == 0
  where
    runBulk x = bulk c {index: idx, body: x, refresh: "wait_for"} {}

main :: Effect Unit
main = launchAff_ do
  fixture testCreateIndexIndexSearchDeleteIndex
  fixture testCreateUpdateGetDelete
  fixture testBulk
  liftEffect $ log "[DONE]"
