const {ApiIndex, URLValue} = require('@nrfcloud/models');
require('es6-promise').polyfill();
require('isomorphic-fetch');

const lookForSubject = new URLValue('https://aws.amazon.com/iot-platform/');
const lookForStage = 'stage@prod';

fetch('https://meta.nrfcloud.com/')
    .then(response => response.json())
    .then(json => ApiIndex.fromJSON(json))
    .then(({links}) => links.filter(({subject, rel}) => subject.equals(lookForSubject) && rel.indexOf(lookForStage) > -1)[0])
    .then(endpoint => {
        console.log(endpoint.href.toString());
    });
