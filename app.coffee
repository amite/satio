express = require 'express'
mongoose = require 'mongoose'

postsRoutes = require './routes/postsRoutes'
postModel = require './models/post'

app = module.exports = express.createServer();

Db = require('mongodb').Db
Server = require('mongodb').Server
server_config = new Server('localhost', 27017, {auto_reconnect: true, native_parser: true})
db = new Db('my_database', server_config, {})
mongoStore = require('connect-mongodb');

# Mongo connection
mongoose.connect 'mongodb://localhost/my_database'
mongoose.connection.on "open", ->
  console.log "mongodb is connected!!"

# Configuration
app.configure () ->
    app.use express.logger({ format: ':method :url'})
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.cookieParser()
    app.use express.session({
          secret: '076ee61d63aa10a125ea872411e433b9',
          maxAge: new Date(Date.now() + 3600000),
          store: new mongoStore({ db: db })
    })
    app.use app.router
    app.use express.static "#{__dirname}/public"

app.configure 'development', () ->
  app.use express.errorHandler dumpExceptions: true, showStack: true

app.configure 'production', () ->
  app.use express.errorHandler()

#routes
Post = postModel.Post
postsRoutes(app, Post)

# Starting app
app.listen 3000
console.log "Express server listening on port #{app.address().port}"