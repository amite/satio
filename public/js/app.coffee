define [
  'jQuery',
  'Underscore',
  'Backbone',
  'cs!router'
], ($, _, Backbone, Router) ->
  initialize = () ->
    Router.initialize()

  return {
    initialize: initialize
  }
