mongoose = require 'mongoose'

#models
module.exports.Post = mongoose.model 'Post', new mongoose.Schema({
  title: String,
  body: String,
  slug: String
}, { collection : 'posts' })
