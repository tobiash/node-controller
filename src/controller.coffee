_ = require("underscore")._
Q = require("q")
prepostify = require 'prepostify'

beget = (o, locals) ->
  F = ->
  F.prototype = o
  _.extend (new F), locals


# Use ExpressJS route implementation
Route = require("express/lib/router/route")

# Helper to copy the params
copyParams = (route) ->
  params = []
  for p, i in route.params
    params[i] = p
  # Copy named parameters
  for key, value of route.params
    params[key] = value
  params

#
# Resource Controller for Socket.IO (and possibly others)
# =======================================================
#
# The resource controller can be defined in a special DSL:
#
# @path "/tables", ->
#   @on "read", ->
#
#   @path ":id", ->
#     @on "read", ->
#     @on "join", ->
#
# @pre "*:read", ->
#
class Controller
  
  # Error that gets thrown when the controller does not find
  # a suitable route.
  #
  class @RouteNotFound
    constructor: (@req) ->

    toString: ->
      "No route found for request #{req.url}##{req.method}"

  constructor: (builder) ->

    # Exposed for testing
    @routes = routes = []

    # Prepostify Utility
    prepostified = new prepostify.PrepostifiedCan
    
    # Tracks the path prefixes of the current scope
    pathPrefixes = []

    # Builds a path from the given string by prepending it
    # with the current scope path
    buildPath = (path) ->
      pathPrefixes.concat(path).join ""

    # Keeps a mapping from action strings to routes
    # e.g.
    #   foo/bar/:id#read => Route(...)
    #
    actions = {}

    # Creates a combined string from a path and action
    actionName = (path, action) ->
      buildPath(path) + "#" + action

    # Prefixes all filter actions with the current scope path
    scoped_filter_adder = (filter_adder) ->
      (actions..., fn) -> 
        scoped_actions = (buildPath(action) for action in actions)
        filter_adder.apply @, scoped_actions.concat(fn)

    @pre = scoped_filter_adder(prepostified.pre)
    @post = scoped_filter_adder(prepostified.post)
    @can = scoped_filter_adder(prepostified.can)

    @on = (method, path, handler) ->
      if _.isFunction path
        handler = path
        path = ""
      action = actionName(path, method)
      prepostified.on action, handler  
      route = new Route method, buildPath(path), []
      routes.push route
      actions[action] = route

    # 
    # Creates a scope for child routes
    #
    # @path "/foo", ->
    #   @on "/:id", ...
    #
    # => "/foo/:id"
    #
    @path = (path, fn) ->
      context = beget @, {}
      pathPrefixes.push path
      fn.call context
      pathPrefixes.pop()
  
    #
    # Dispatches the request to the controller. The request needs to contain
    # * url
    # * method
    # The request is passed to the matching route handler.
    # Returns a promise-
    #
    @dispatch = (request, context) ->
      matchRoute = (request) ->
        for name, route of actions
          if route.method is request.method and route.match(request.url)
            return [name, copyParams(route)]
        throw new Controller.RouteNotFound(request)

      Q.fcall ->
        [actionName, params] = matchRoute(request)
        request.params = params
        prepostified.action(actionName, context)(request)

    # Run initializer in context
    builder?.call @


module.exports = Controller
