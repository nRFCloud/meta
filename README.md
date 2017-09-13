# meta.nrfcloud.com

[![Build Status](https://travis-ci.org/nRFCloud/meta.svg?branch=master)](https://travis-ci.org/nRFCloud/meta)

Provides a document for service discovery related to nRFCloud.com on https://meta.nrfcloud.com/.

The document is the JSON representation of an [ApiIndex document](https://github.com/nRFCloud/models#apiindex), created with [generate-index.js](./scripts/generate-index.js), with the Content-Type 
`application/vnd.nrfcloud.meta.v1+json`: 

You discover endpoints by iterating over the `links` array, and filter
[the links](https://github.com/nRFCloud/models#link) by the subject you
are interested in. The `rel` property contains information about the 
stage of the endpoint in the notation `stage@<stage-identifier>`.

Here is a JavaScript example of this process using the 
[@nrfcloud/models](https://github.com/nRFCloud/models) package: 
[./docs/example.js](./docs/example.js).

Here is a JavaScript example of this process using just the JSON data: 
[./docs/example-no-models.js](./docs/example-no-models.js).
