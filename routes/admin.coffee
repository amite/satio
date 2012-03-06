module.exports = (app, Post, User) ->
  app.namespace '/admin/', ->
    app.get "/", (req, res) ->
      res.render "app"

    app.get "/todos", (req, res) ->
      Todo.find (err, todos) ->
        res.send todos

    app.post "/todos", (req, res) ->
      todo = new Todo(content: req.body.content, done: req.body.done)
      todo.save (err) ->
        console.log("created") unless err
      res.send todo

    app.put "/todos/:id", (req, res) ->
      Todo.findById req.params.id, (err, todo) ->
        todo.content = req.body.content
        todo.done = req.body.done
        todo.save (err) ->
          console.log("updated") unless err
          res.send todo

    app.del '/todos/:id', (req, res) ->
      Todo.findById req.params.id, (err, todo) ->
        todo.remove (err) ->
          console.log("removed") unless err