require.config({
  baseUrl:'/js',
  paths: {
    loader: 'libs/backbone/loader',
    jQuery: 'libs/jquery/jquery',
    Underscore: 'libs/underscore/underscore',
    Backbone: 'libs/backbone/backbone',
    bootstrap: 'libs/twitter-bootstrap/bootstrap.min',
    text: 'libs/require/text',
    order: 'libs/require/order',
    cs: 'libs/require/cs'
  }
});
require(['cs!app'], function(App) {
    App.initialize();
});