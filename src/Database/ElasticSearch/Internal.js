const es = require('@elastic/elasticsearch');

exports.client = p => () => new es.Client(p);

exports.search = c => p => r => () => c.search(p, r);

exports.createIndex = c => p => r => () => c.indices.create(p, r);

exports.deleteIndex = c => p => r => () => c.indices.delete(p, r);

exports.index = c => p => r => () => c.index(p, r);

exports.create = c => p => r => () => c.create(p, r);

exports.delete = c => p => r => () => c.delete(p, r);

exports.get = c => p => r => () => c.get(p, r);

exports.update = c => p => r => () => c.update(p, r);

exports.bulk = c => p => r => () => c.bulk(p, r);
