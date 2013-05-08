should = require 'should'
S3 = require '../js/S3'

describe 'S3', ->

  before ->
    @s3 = new S3('./config/config.json')

  beforeEach (done) ->
    callback = (err, data) ->
      done()
    @s3.delete_bucket "msc-bucket-hoge3", callback

  describe 'create_bucket', ->
    it 'create_bucket OK', (done) ->
      callback = (err, data) ->
        data.should.have.keys 'Location', 'RequestId'
        done()
      params =
        ACL: "public-read"
        CreateBucketConfiguration: {
        LocationConstraint: "ap-northeast-1"
        }
      @s3.create_bucket "msc-bucket-hoge3", (err, data) ->
        data.should.have.keys 'Location', 'RequestId'
        done()
      , params

#describe 'S3', ->
#  describe 'create_bucket', ->
#    it 'test', ->
#      console.log "hoge"

  after ->
    console.log "test"