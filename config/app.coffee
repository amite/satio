# Load dependencies
express       = require 'express'
stylus        = require 'stylus'
mongoose      = require 'mongoose'
nib           = require 'nib'
models        = require './models'
config        = require './config'
routes        = require './routes'
environment   = require './environment'
errors        = require './errors'
hooks         = require './hooks'

# util        = require 'util'
mongoStore  = require 'connect-mongodb'
helpers     = require './helpers'

#
# Exports
#
module.exports = ->
  # Create Server
  app = express.createServer()

  helpers(app)
  # Load Mongoose Models

  models(app)

  # Load Expressjs config

  config(app)

  # Load Environmental Settings

  environment(app)

  # Load routes config

  routes(app)

  # Load error routes + pages

  errors(app)

  # Load hooks

  hooks(app)

  return app
