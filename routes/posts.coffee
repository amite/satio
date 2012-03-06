
module.exports = (app, Post) ->

  app.get '/api/posts', (req, res) ->
    return Post.find( (err, posts) ->
      	return res.json(posts)
    )

  app.get '/api/posts/:id', (req, res) ->
    return Post.find({ slug: req.params.id }, (err, post) ->
      if (!err)
        return res.json(post)
    )

  app.post '/api/posts', (req, res) ->
    post = new Post({
      title: req.body.title,
      body: req.body.body,
      slug: req.body.title.replace(/\s+/g,'-').replace(/[^a-zA-Z0-9\-]/g,'').toLowerCase()
    })
    post.save((err) ->
      if (!err)
        console.log "Post " + post.id + " created"
    )
    return res.json(post)

  app.put '/api/posts/:id', (req, res) ->
  	Post.findById(req.params.id, (err, post) ->
  	  post.title = req.body.title
  	  post.body = req.body.body
  	  post.slug = req.body.title.replace(/\s+/g,'-').replace(/[^a-zA-Z0-9\-]/g,'').toLowerCase()
  		post.save((err) ->
  			if (!err)
  				console.log " Post updated"
  			return res.json(post)
  		)
  	)