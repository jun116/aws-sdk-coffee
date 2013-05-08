async = require 'async'
S3 = require './s3'

s3 = new S3('../../config/config.json')

#params =
#  Bucket: "msc-bucket-hoge"

bucket_name = "msc-bucket-hoge"
key_name = ""

delete_bucket_force = (callback) ->
  s3.delete_bucket_force bucket_name, callback

delete_bucket = (callback) ->
  s3.delete_bucket bucket_name, callback

create_bucket = (callback) ->
  params =
    ACL: "public-read"
    CreateBucketConfiguration: {
      LocationConstraint: "ap-northeast-1"
    }
  s3.create_bucket bucket_name, callback, params

put_object = (callback) ->
  params =
      Body: "Hello world!"
  key_name = "test/Key"
  s3.put_object bucket_name, key_name, callback, params

put_object2 = (callback) ->
  params =
    Body: "Hello world!"
  key_name = "Key1"
  s3.put_object bucket_name, key_name, callback, params

get_object = (callback) ->
  s3.get_object bucket_name, key_name, callback, params

delete_object = (callback) ->
  s3.delete_object bucket_name, key_name, callback

list_buckets = (callback) ->
  s3.list_buckets callback

list_objects = (callback) ->
  s3.list_objects bucket_name, callback

tasks = []
#tasks.push put_object
#tasks.push put_object2
#tasks.push delete_bucket_force
#tasks.push delete_bucket
#tasks.push create_bucket
#tasks.push put_object
#tasks.push put_object2
#tasks.push get_object
#tasks.push delete_object
#tasks.push list_buckets
#tasks.push list_objects
tasks.push list_buckets
#tasks.push create_bucket
#tasks.push put_object
#tasks.push delete_object
#tasks.push delete_bucket

async.series tasks, (err, results) ->
  if err
    console.log err
  else
    console.log results
