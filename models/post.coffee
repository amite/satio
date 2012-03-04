mongoose 	= require 'mongoose'
Schema    = mongoose.Schema

#models
module.exports.Post = mongoose.model 'Post', new Schema({
  title: String,
  body: String,
  slug: String,
  created_at: { type: Date, default: Date.now }
}, { collection : 'posts' })
