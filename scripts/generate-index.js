const models = require('@nrfcloud/models');

const {ApiIndex, Link, URLValue} = models;

const index = new ApiIndex([
    // AWS IoT endpoints
    new Link(
        new URLValue('https://a2n7tk1kp18wix.iot.us-east-1.amazonaws.com'),
        new URLValue('https://aws.amazon.com/iot-platform/'),
        'stage@dev,stage@beta,stage@prod'
    ),
    // REST API
    new Link(
        new URLValue('https://hnmr2uba55.execute-api.us-east-1.amazonaws.com/prod'),
        new URLValue('https://nrfcloud.com/#api'),
        'stage@prod'
    ),
    new Link(
        new URLValue('https://hnmr2uba55.execute-api.us-east-1.amazonaws.com/beta'),
        new URLValue('https://nrfcloud.com/#api'),
        'stage@beta'
    ),
    new Link(
        new URLValue('https://hnmr2uba55.execute-api.us-east-1.amazonaws.com/dev'),
        new URLValue('https://nrfcloud.com/#api'),
        'stage@dev'
    ),
]);

console.log(JSON.stringify(index, '', 2));
