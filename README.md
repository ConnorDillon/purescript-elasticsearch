# Purescript Elastic Search

A lightweight typed wrapper around the official [Node JS client](https://www.elastic.co/guide/en/elasticsearch/client/javascript-api/current/api-reference.html). The current implemented methods are:

- bulk
- create
- delete
- get
- index
- indices.create
- indices.delete
- search
- update

This library uses [`Untagged.Union`](https://github.com/jvliwanag/purescript-untagged-union) to specify the types of API parameters.
