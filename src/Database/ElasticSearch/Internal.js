const es = require('@elastic/elasticsearch');

exports.client = p => () => new es.Client(p);

exports.search = c => p => r => () => c.search(p, r);

exports.createIndex = c => p => r => () => c.indices.create(p, r);

exports.deleteIndex = c => p => r => () => c.indices.delete(p, r);

exports.index = c => p => r => () => c.index(p, r);
