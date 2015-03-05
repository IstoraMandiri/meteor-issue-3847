testCol = new Mongo.Collection 'test'

if Meteor.isClient

  Template.test.helpers
    testDocs : -> testCol.find()

  Template.test.events
    'click .insert' : -> testCol.insert { '_id' : 'test' }
    'click .drop-db' : -> Meteor.call 'dropDatabase'

if Meteor.isServer

  mongo = Meteor.npmRequire('mongodb')

  dropDb = Meteor.wrapAsync (callback) ->
    mongo.MongoClient.connect process.env.MONGO_URL, (err, db) ->
      db.dropDatabase (err) ->
        callback err

  Meteor.methods
    'dropDatabase' : ->
      console.log "dropping database.."
      console.log "docs before: #{testCol.find().count()}"
      dropDb()
      console.log "docs after: #{testCol.find().count()}"