const models = require('@nrfcloud/models')

const { ApiIndex, Link, URLValue } = models

const index = new ApiIndex([
  // self
  new Link(
    new URLValue('https://meta.mrfcloud.com/'),
    new URLValue('https://github.com/nRFCloud/meta'),
    'self'
  ),
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
  // Backend Status endpoint (public)
  new Link(
    new URLValue('https://hnmr2uba55.execute-api.us-east-1.amazonaws.com/prod/status'),
    new URLValue('https://github.com/nRFCloud/models#Status'),
    'stage@prod'
  ),
  new Link(
    new URLValue('https://hnmr2uba55.execute-api.us-east-1.amazonaws.com/beta/status'),
    new URLValue('https://github.com/nRFCloud/models#Status'),
    'stage@beta'
  ),
  new Link(
    new URLValue('https://hnmr2uba55.execute-api.us-east-1.amazonaws.com/dev/status'),
    new URLValue('https://github.com/nRFCloud/models#Status'),
    'stage@dev'
  )
])

console.log(JSON.stringify(index, null, 2))
