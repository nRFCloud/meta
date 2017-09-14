/* global describe beforeAll it expect */

const {readFile} = require('fs')
const {promisify} = require('util')
const {ApiIndex, URLValue} = require('@nrfcloud/models')

const stages = [
  'dev',
  'beta',
  'prod'
]

describe('index.json', () => {
  let index

  beforeAll(async () => {
    index = ApiIndex.fromJSON(JSON.parse(await promisify(readFile)('./dist/index.json', 'utf-8')))
  })

  it('should have a link to self', () => {
    const links = index.links.filter(({rel}) => rel === 'self')
    expect(links).toHaveLength(1)
    const self = links[0]
    expect(self).not.toBeUndefined()
    expect(self.subject.toString()).toEqual('https://github.com/nRFCloud/meta')
    expect(self.href.toString()).toEqual('https://meta.mrfcloud.com/')
  })

  it('should have an AWS IoT endpoint for every stage', () => {
    stages
            .map(stage => {
              const awsItoSubject = new URLValue('https://aws.amazon.com/iot-platform/')
              const links = index.links.filter(({rel, subject}) => rel.indexOf(`stage@${stage}`) >= 0 && subject.equals(awsItoSubject))
              expect(links).toHaveLength(1)
            })
  })

  it('should have an REST API endpoint for every stage', () => {
    stages
            .map(stage => {
              const nrfCloudRestApiSubject = new URLValue('https://nrfcloud.com/#api')
              const links = index.links.filter(({rel, subject}) => rel.indexOf(`stage@${stage}`) >= 0 && subject.equals(nrfCloudRestApiSubject))
              expect(links).toHaveLength(1)
            })
  })
})
