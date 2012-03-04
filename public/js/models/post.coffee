define [
  'Underscore',
  'Backbone'
], ( _, Backbone ) ->
  class Post extends Backbone.Model
    defaults:
      title: "Default Title"
      body: "Default Body"

    url: ->
      if @_id
        '/api/posts/' +  @slug
      else
        '/api/posts'

  return Post