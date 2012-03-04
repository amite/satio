define [
  'jQuery',
  'Underscore',
  'Backbone',
  'cs!views/home/main'
], ($, _, Backbone, mainHomeView) ->
  class AppRouter extends Backbone.Router
    routes:
      '*actions': 'defaultAction'

    defaultAction: (actions) ->
      mainHomeView.render()

  initialize = () ->
    app_router = new AppRouter
    Backbone.history.start()

  return {
    initialize: initialize
  }