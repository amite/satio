mongoose 	= require 'mongoose'
Schema    = mongoose.Schema
Comment = require './comment'

#models
module.exports.Post = mongoose.model 'Post', new Schema({
  title: String,
  copete: String,
  body: String,
  slug: String,
  comments: [Comment]
  created_at: { type: Date, default: Date.now }
}, { collection : 'posts' })
