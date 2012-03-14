#  Set all global variables
pusher = require 'pusher'
controller = {}
app = {}
db = {}

# Constructor

module.exports = (_app) ->
  app = _app
  db  = app.set 'db'
  return controller

########################################################################
# Login routes
# render login form
controller.login = (req, res) ->
  User = db.main.model('User')
  res.render 'admin/login', { user: new User(), title: 'Ingresar' }

# login user
controller.session = (req, res) ->
  User = db.main.model('User')
  User.findOne({ email: req.body.user.email }, (err, user) ->
    if (user && user.authenticate(req.body.user.password))
      req.session.user_id = user.id

      if (req.body.remember_me)
        loginToken = new LoginToken({ email: user.email })
        loginToken.save( ->
          res.cookie('logintoken', loginToken.cookieValue, { expires: new Date(Date.now() + 2 * 604800000), path: '/' })
        )
      res.redirect '/'
    else
      req.flash 'error', 'Login failed, try again'
      res.redirect '/admin/login'
  )

# logout user
controller.logout = (req, res) ->
  LoginToken = db.main.model('LoginToken')
  if (req.session)
    LoginToken.remove({ email: req.currentUser.email }, -> {} )
    res.clearCookie('logintoken')
    req.session.destroy(-> {})
  res.redirect '/admin/login'

##########################################################################
# Administrative Blog routes
#

##########################################################################
# USER
#

# render user create form
controller.newUser  = (req, res) ->
  res.render 'users/create', { user: new User() }

# save new user
controller.createUser = (req, res) ->
  User = db.main.model('User')  
  user = new User(req.body.user)

  userSaveFailed = ->
    req.flash('error', 'Saving user failed')
    res.render 'users/create', { user: user }

  user.save( (err) ->
    if (err) 
      userSaveFailed()
    req.flash('info', 'User has been saved!')
    res.redirect '/'
  )

##########################################################################
# POSTS
#

controller.index = (req, res, next) ->
  #  expose pusher key
  res.expose 
      app_key   : req.app.set('pusher_key') 
      channel   : 'blog_post'
      events    : 'post'
    , 'PUSHER'

  # render template
  res.render 'home', { posts: db.posts.posts() }

##########################################################################
# NEW POST
#

# GET render post creation form
controller.newPost = (req, res) ->
  BlogPost = db.main.model('BlogPost')
  res.render 'blogpost/create', { post: new BlogPost() }

##########################################################################
# CREATE POST
#
# POST save new blog post
 controller.createPost = (req, res) ->
  BlogPost = db.main.model('BlogPost')
  post = new BlogPost()
  post.title = req.body.blogpost.title
  post.rsstext = req.body.blogpost.rsstext
  post.preview = req.body.blogpost.preview
  post.body = req.body.blogpost.body
  post.created = new Date()
  post.modified = new Date()
  post.tags = req.body.blogpost.tags.split(',')

  postCreationFailed = ->
    req.flash('error', 'Creating post failed')
    res.render 'blogpost/create', { post: post }

  post.save (err) ->
    if (err)
      return postCreationFailed()

    req.flash('info', 'Post created')
    res.redirect '/'

##########################################################################
# DELETE POST
#
# delete blog post
controller.delete = (req, res, next) ->
  BlogPost = db.main.model('BlogPost')
  BlogPost.findById(req.params.id, (err, bp) ->
    if (!bp)
      return next(new NotFound('Blogpost not found'))
    else
      bp.remove (err) ->
        if (err)
          return next(new Error('Blogpost failed to remove'))
        else
          req.flash('info', 'Post was removed')
          res.redirect '/'
  )

# render update form
controller.edit = (req, res, next) ->
  BlogPost = db.main.model('BlogPost')
  BlogPost.findById(req.params.id, (err, bp) ->
    if (!bp)
      return next(new NotFound('Blogpost not found'))
    else
      res.render 'blogpost/edit', { post: bp }
  )

#  update blog post
controller.update = (req, res, next) ->
  BlogPost = db.main.model('BlogPost')
  BlogPost.findById(req.params.id, (err, bp) ->
    if (!bp)
      return next(new NotFound('Blogpost not found'))
    else 
      bp.title = req.body.blogpost.title
      bp.rsstext = req.body.blogpost.rsstext
      bp.preview = req.body.blogpost.preview
      bp.body = req.body.blogpost.body
      bp.tags = req.body.blogpost.tags.split(',')
      bp.modified = new Date()

      postUpdateFailed = ->
        req.flash('error', 'Failde to update Post')
        res.render 'blogpost/edit', { post: bp }

      bp.save (err) ->
        if (err)
          return postUpdateFailed()

        req.flash('info', 'Post updated')
        res.redirect '/'
  )