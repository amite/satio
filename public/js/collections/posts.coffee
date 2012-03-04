define [
  'Underscore',
  'Backbone',
  'cs!models/post'
], ( _, Backbone, Post ) ->
  class PostsCollection extends Backbone.Collection
    model: Post
    url: '/api/posts'

  return PostsCollection