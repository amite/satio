express = require 'express'
mongoose = require 'mongoose'
postsRoutes = require './routes/postsRoutes'
postModels = require './models/posts'

app = module.exports = express.createServer();

# Mongo connection
mongoose.connect 'mongodb://localhost/my_database'
mongoose.connection.on "open", ->
  console.log "mongodb is connected!!"

# Configuration

app.configure () ->
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.cookieParser()
    app.use express.session({ secret: 'satio'})
    app.use app.router
    app.use express.static "#{__dirname}/public"
    app.use express.logger({ format: ':method :url'})

app.configure 'development', () ->
  app.use express.errorHandler dumpExceptions: true, showStack: true

app.configure 'production', () ->
  app.use express.errorHandler()

#routes
Post = postModels.Post
postsRoutes(app, Post)

# Starting app
app.listen 3000
console.log "Express server listening on port #{app.address().port}"