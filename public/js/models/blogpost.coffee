define [
  'Underscore',
  'Backbone'
], ( _, Backbone ) ->
  class BlogPost extends Backbone.Model
    url: ->
      if @get('_id')
        '/api/posts/' +  @get('slug')
      else
        '/api/posts'

  return BlogPost