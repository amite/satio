#
#  Load dependencies
#

express   = require 'express'
path      = require 'path'
cons      = require 'consolidate'
expose    = require 'express-expose'
mongoose  = require 'mongoose'
nib       = require 'nib'
mongoStore  = require 'connect-mongodb'
mongodb     = require 'mongodb'

# Exports

module.exports = (app) ->

  # Setup DB connection for Sessions Store
  Db = mongodb.Db
  Server = mongodb.Server
  server_config = new Server('localhost', 27017, {auto_reconnect: true, native_parser: true})
  db_store = new Db('satio-blog', server_config, {})

  # Setup DB Connection
  dblink = process.env.MONGOHQ_URL || 'mongodb://localhost/satio-blog'
  db  = mongoose.createConnection dblink

  # Compile Hack for Stylus
  #  Replaced by connect-assets
  # function compile(str, path) {
  #   return stylus(str)
  #     .set('filename', path)
  #     .include(nib.path);
  # }

  # Configure expressjs
  app.configure ->
    app.use express.logger('\033[90m:method\033[0m \033[36m:url\033[0m \033[90m:response-time ms\033[0m')
    # app.register '.html', require('ejs')
    app.set 'views', __dirname + '/../views'
    app.set 'view engine', 'ejs'
    app.use express.cookieParser()
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.errorHandler({dumpException: true, showStack: true})
    app.use express.session
          secret: '076ee61d63aa10a125ea872411e433b9'
          maxAge: new Date(Date.now() + 3600000)
          store: new mongoStore { db: db_store }
    # app.use app.router
    app.use express.static __dirname + '/../public'
    app.dynamicHelpers { messages: require('express-messages-bootstrap') }

  # Save reference to database connection
  app.configure ->
    app.set 'db', {
        'main': db
        # 'posts': db.model 'BlogPost'
        # 'users': db.model 'Users'
        # 'logintoken' : db.model 'LoginToken'
    }

    app.set 'version', '0.1.0'

  return app
