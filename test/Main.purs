module Test.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Database.ElasticSearch (Client, alias, bulk, bulkCreate, bulkDelete, bulkIndex, bulkUpdate, client, create, createIndex, createIndexBody, delete, deleteIndex, get, index, long, mapping, search, searchBody, settings, toObject, update, waitFor)
import Database.ElasticSearch.Query (bool, match, matches)
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
  ir <- index c {index: idx, refresh: waitFor, body: toObject {"bar": 1}} {}
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
  _ <- create c {index: idx, refresh: waitFor, id: id, body: source} {}
  gr1 <- get c {id: id, index: idx} {}
  _ <- update c {id: id, index: idx, body: {doc: patch}, refresh: waitFor} {}
  gr2 <- get c {id: id, index: idx} {}
  dr <- delete c {id: id, index: idx, refresh: waitFor} {}
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
  br1 <- runBulk $ bulkCreate {_id: "foo1"} (toObject {"bar": 1})
                    <> bulkIndex {_id: "foo2"} (toObject {"baz": 2})
  br2 <- runBulk $ bulkUpdate {_id: "foo1"} (toObject {"bar": 3})
                    <> bulkUpdate {_id: "foo2"} (toObject {"baz": 4})
  gr1 <- get c {id: "foo1", index: idx} {}
  gr2 <- get c {id: "foo2", index: idx} {}
  br3 <- runBulk $ bulkDelete {_id: "foo1"} <> bulkDelete {_id: "foo2"}
  sr <- search c {index: [idx]} {}
  pure $
    not br1.body.errors
    && not br2.body.errors
    && not br3.body.errors
    && uorToMaybe gr1.body._source == Just (toObject {"bar": 3})
    && uorToMaybe gr2.body._source == Just (toObject {"baz": 4})
    && sr.body.hits.total.value == 0
  where
    runBulk x = bulk c {index: idx, body: x, refresh: waitFor} {}

testQuery :: Client -> String -> Aff Unit
testQuery c idx = test "query" do
  _ <- createIndex c {index: idx} {}
  _ <- index c {index: idx, refresh: waitFor, body: toObject {"bar": 1}} {}
  _ <- index c {index: idx, refresh: waitFor, body: toObject {"baz": 1}} {}
  _ <- index c {index: idx, refresh: waitFor, body: toObject {"quux": 1}} {}
  sr <- search c {index: [idx], body: searchBody {query: q}} {}
  pure $ sr.body.hits.total.value == 2
  where
    q = bool {must: [bool {must_not: [matches {bar: match {query: 1.0}}]}]}

main :: Effect Unit
main = launchAff_ do
  fixture testCreateIndexIndexSearchDeleteIndex
  fixture testCreateUpdateGetDelete
  fixture testBulk
  fixture testQuery
  liftEffect $ log "[DONE]"
