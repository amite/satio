define [
  'Underscore',
  'Backbone'
], ( _, Backbone ) ->
  class Post extends Backbone.Model
    defaults:
      title: "Default Title"
      body: "Default Body"

    url: ->
      if @get('_id')
        '/api/posts/' +  @get('slug')
      else
        '/api/posts'

  return Post