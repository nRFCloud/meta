# meta.nrfcloud.com [![API v1.0.0](https://img.shields.io/badge/API-v1.0.0-blue.svg)](https://meta.nrfcloud.com/swagger-api.yaml?v1.0.0)

[![Build Status](https://travis-ci.org/nRFCloud/meta.svg?branch=master)](https://travis-ci.org/nRFCloud/meta)
[![Swagger UI](https://img.shields.io/badge/Swagger-UI-orange.svg)](http://petstore.swagger.io/?url=https%3A%2F%2Fmeta.nrfcloud.com%2Fswagger-api.yaml%3Fv1.0.0)

Provides a document for service discovery related to nRFCloud.com on https://meta.nrfcloud.com/.

The document is the JSON representation of an [ApiIndex document](https://github.com/nRFCloud/models#apiindex), created with [generate-index.js](./scripts/generate-index.js), with the Content-Type 
`application/vnd.nrfcloud.meta.v1+json`: 

You discover endpoints by iterating over the `links` array, and filter
[the links](https://github.com/nRFCloud/models#link) by the subject you
are interested in. The `rel` property contains information about the 
stage of the endpoint in the notation `stage@<stage-identifier>`.

See [this test](./__tests__/index.spec.js) for a JavaScript example of this process using the 
[@nrfcloud/models](https://github.com/nRFCloud/models) package.

Here is a JavaScript example of this process using just the JSON data:

```JavaScript
const lookForSubject = 'https://aws.amazon.com/iot-platform/'
const lookForStage = 'stage@prod'

fetch('https://meta.nrfcloud.com/')
    .then(response => response.json())
    .then(({links}) => links.filter(({subject, rel}) => subject === lookForSubject && rel.indexOf(lookForStage) > -1)[0])
    .then(endpoint => {
      console.log(endpoint.href)
    })
```

## Deployment

The document at https://meta.nrfcloud.com/ will be updated for every tag 
[through travis](./.travis.yml).
