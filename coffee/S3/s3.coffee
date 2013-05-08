class S3
  AWS = require 'aws-sdk'
  path = require 'path'

  constructor: (file) ->
    AWS.config.loadFromPath path.normalize file
    @s3 = new AWS.S3()

  create_bucket: (bucket, callback, params = {}) ->
    params = @create_params bucket, null, params
    @head_bucket bucket, (err, data) =>
      if err?.statusCode is 404
        @s3.createBucket params, (err, data) ->
          console.log "create_bucket"
          callback err, data
      else
        callback err, data

  delete_bucket: (bucket, callback) ->
    params = @create_params bucket, null
    @head_bucket bucket, (err, data) =>
      if err?.statusCode is 404
        callback null, data
      else if err?.statusCode is 403
        callback err, data
      else if err?.statusCode is 301
        callback err, data
      else
        @s3.deleteBucket params, (err, data) ->
          console.log "delete_bucket"
          callback err, data

  delete_bucket_force: (bucket, callback) ->
    @head_bucket bucket, (err, data) =>
      if err?.statusCode is 404
        callback null, data
      else if err?.statusCode is 403
        callback err, data
      else
        @list_objects bucket, (err, data) =>
          if err
            callback err, data
          else
            unless data.Contents.length is 0
              @delete_objects bucket, data.Contents, (err, data) =>
                if err
                  callback err, data
                else
                  params = @create_params bucket, null
                  @s3.deleteBucket params, (err, data) ->
                    console.log "delete_bucket_force"
                    callback err, data
            else
              params = @create_params bucket, null
              @s3.deleteBucket params, (err, data) ->
                console.log "delete_bucket_force"
                callback err, data

  delete_object: (bucket, key, callback) ->
    params = @create_params bucket, key
    @head_object bucket, key, (err, data) =>
      if err?.statusCode is 404
        callback null, data
      else if err?.statusCode is 403
        callback err, data
      else
        @s3.deleteObject params, (err, data) ->
          console.log "delete_object"
          callback err, data

  delete_objects: (bucket, deletes, callback, params = {}) ->
    params = @create_params bucket, null, params
    keys = []
    for key in deletes
      keys.push { Key: key.Key }
    params.Delete = {
      Objects: keys
    }
    @s3.deleteObjects params, (err, data) ->
      console.log "delete_objects"
      callback err, data

  getBucketVersioning: (bucket, callback) ->
    params = @create_params bucket, null
    @s3.getBucketVersioning params, (err, data) =>
      console.log "getBucketVersioning"
      callback err, data

  get_acl: (params, callback) ->
    @s3.getBucketAcl params, (err, data) ->
      console.log "get_acl"
      console.log data.Grants if data?
      callback err, data

  get_object: (params, callback) ->
    @s3.getObject params, (err, data) ->
      console.log "get_object"
      callback err, data

  head_bucket: (bucket, callback) ->
    params = @create_params bucket, null
    @s3.headBucket params, (err, data) =>
      console.log "headBucket"
      callback err, data

  head_object: (bucket, key, callback) ->
    params = @create_params bucket, key
    @s3.headObject params, (err, data) =>
      console.log "head_object"
      callback err, data

  put_object: (bucket, key, callback, params = {}) ->
    params = @create_params bucket, key, params
    @s3.putObject params, (err, data) ->
      console.log "put_object"
      callback err, data

  list_buckets: (callback) ->
    @s3.listBuckets null, (err, data) ->
      console.log "list_buckets"
      console.log data.Buckets if data?
      callback err, data

  list_objects: (bucket, callback, params = {}) ->
    params = @create_params bucket, null, params
    @s3.listObjects params, (err, data) =>
      console.log "list_objects"
      console.log data.Contents if data?
      callback err, data

  create_params: (bucket, key, params = {}) ->
    params.Bucket = bucket if bucket?
    params.Key = key if key?
    return params

module.exports = S3
