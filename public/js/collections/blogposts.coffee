define [
  'Underscore',
  'Backbone',
  'cs!models/blogpost'
], ( _, Backbone, BlogPost ) ->
  class BlogPostsCollection extends Backbone.Collection
    model: BlogPost
    url: '/api/posts'

  return BlogPostsCollection