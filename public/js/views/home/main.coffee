define [
  'jQuery',
  'Underscore',
  'Backbone',
  'text!templates/home/main.html'
], ($, _, Backbone, mainHomeTemplate) ->
  class MainHomeView extends Backbone.View
    el: $("#main-container")
    mainHomeTemplate: _.template(mainHomeTemplate)

    render: ->
      $(@el).html @mainHomeTemplate()
      @

  return new MainHomeView