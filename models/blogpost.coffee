mongoose  = require 'mongoose'
Schema   = mongoose.Schema

#  Comment model
#  Used for persisting user comments
Comment = module.exports = new Schema
      author: String
      title: String
      date: Date
      body: String

# register virtual members
Comment.virtual('readableday')
  .get ->
    day = @date.getDate()
    return (day < 10 ? '0' + day : day)

Comment.virtual('readablemonth')
  .get ->
    return monthNamesShort[@date.getMonth()]

Comment.virtual('readabletime')
  .get ->
    hour = @date.getHours()
    minute = @date.getMinutes()
    return (hour < 10 ? '0' +  hour : hour) + ':' + (minute < 10 ? '0' +  minute : minute);

Comment.virtual('bodyParsed')
  .get ->
    return convertBasicMarkup(@body, false)

# register validators
Comment.path('author').validate( 
    (val) ->
        val.length > 0
    'AUTHOR_MISSING' )

Comment.path('body').validate( 
    (val) ->
        val.length > 0 
    'BODY_MISSING' )


# Blogpost model
# Used for persisting blog posts

BlogPost = module.exports = new Schema
    title: String
    preview: String
    body: String
    rsstext: String
    slug: String
    created: Date
    modified: Date
    tags: [String]
    comments: [Comment]

monthNames = [ 'January', 'February', 'March', 'April', 'May', 'June', 'July',
                   'August', 'September', 'October', 'November', 'December' ]
monthNamesShort = [ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
                        'Aug', 'Sep', 'Oct', 'Nov', 'Dec' ]

# define virtual getter method for id (readable string)
BlogPost.virtual('id')
  .get ->
    return @_id.toHexString()

BlogPost.virtual('url')
  .get ->
    # build url for current post
    year = @created.getFullYear()
    month = @created.getMonth() + 1
    day = @created.getDate()
    return '/' + year + '/' + (month < 10 ? '0' + month : month) + '/' + (day < 10 ? '0' + day : day) + '/' + @slug + '/'

BlogPost.virtual('rfc822created')
  .get ->
    return @created.toGMTString()

BlogPost.virtual('readabledate')
  .get ->
    year = @created.getFullYear()
    month = monthNames[@created.getMonth()]
    day = @created.getDate()
    return (day < 10 ? '0' + day : day) + '. ' + month + ' ' + year


BlogPost.virtual('readableday')
  .get ->
    day = @created.getDate()
    return (day < 10 ? '0' + day : day)


BlogPost.virtual('readablemonth')
  .get ->
    return monthNamesShort[@created.getMonth()]


BlogPost.virtual('previewParsed')
  .get ->
    return convertBasicMarkup(@preview, true)

BlogPost.virtual('bodyParsed')
  .get ->
    return convertBasicMarkup(@body, true)

# register validators
BlogPost.path('title').validate(
      (val) ->
        val.length > 0
      'TITLE_MISSING' )

BlogPost.path('preview').validate(
      (val) ->
        val.length > 0
      'PREVIEW_MISSING' )

BlogPost.path('rsstext').validate(
      (val) ->
        val.length > 0
      'RSSTEXT_MISSING' )

BlogPost.path('body').validate(
      (val) ->
        val.length > 0
      'BODY_MISSING' )

# generate a proper slug value for blogpost
slugGenerator = (options) ->
  options = options || {}
  key = options.key || 'title'
  return slugGenerator = (schema) ->
      schema.path(key)
        .set (v) ->
          @slug = v.toLowerCase().replace(/[^a-z0-9]/g, '-').replace(/\++/g, '')
          return v

# attach slugGenerator plugin to BlogPost schema
BlogPost.plugin( slugGenerator() )