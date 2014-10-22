# velocity-tinytest
# MIT License ben@latenightsketches.com
# lib/server.coffee
# Execute Tinytest on server and in PhantomJS client by Meteor method

thisTitle = 'tinytest' # Name of this testing framework

if !process.env.NODE_ENV == 'DEVELOPMENT'
  return console.log 'process.env.NODE ENV != DEVELOPMENT, TESTS WILL NOT BE RAN'

path = Npm.require 'path'
childProcess = Npm.require 'child_process'
mkdirp = Npm.require 'mkdirp'

phantomExec = undefined
ddpParent = undefined

Velocity?.registerTestingFramework? thisTitle,
  regex: 'tinytest/.+\\.(js|coffee|litcoffee|coffee\\.md)$'
  sampleTestGenerator: ->
    [
      {
        path: 'tinytest/sample.js',
        contents: Assets.getText 'test/sample.js'
      }
    ]

Meteor.startup ->
  if process.env.IS_MIRROR
    ddpParent = DDP.connect process.env.PARENT_URL
    # Hangs without timeout
    Meteor.setTimeout (->
      runTinytest
        url: process.env.ROOT_URL
    ), 100


runTinytest = (options) ->
  options = options || {}
  if not phantomExec
    phantomExec = phantomLaunch
      debug: true
  # Run tests here, on the server
  _runTests options, (error, result) ->
    throw error if error
    locationComplete 'Server', result

    # Run tests in a PhantomJS client
    options.phantomUrl = options.url
    resultClient = phantomExec _runTests, options
    throw resultClient.error if resultClient.error
    locationComplete 'Client', resultClient.result

    # All Done!
    ddpParent.call 'completed',
      framework: thisTitle

# For each test from a location, report back to Velocity
# @param {string} location - Server|Client
# @param {obj} result - Output from _runTests
locationComplete = (location, result) ->
  _.each result, (test, key) ->
    ancestors = key.split(' - ').reverse()
    ancestors.pop() # First portion is always 'tinytest'
    result =
      id: thisTitle + ':' + key + ':' + location
      framework: thisTitle
      name: location
      result: if test.passed then 'passed' else 'failed'
      isClient: location == 'Client'
      isServer: location == 'Server'
      time: test.time
      ancestors: ancestors
      failureStackTrace: if not test.passed then \
                          JSON.stringify(test.events) else undefined
    ddpParent.call 'postResult', result

# Copied from https://github.com/mad-eye/meteor-mocha-web/
copyTestsToMirror = (file) ->
  Meteor.call "resetReports", {framework: thisTitle}, ->
    relativeDest = file.relativePath.split(path.sep).splice(1).join(path.sep)
    mirrorPath = path.join(process.env.PWD, ".meteor", "local", ".mirror")
    dest = path.join(mirrorPath, relativeDest)
    mkdirp.sync(dest)
    cmd = "cp " +  file.absolutePath + " " + dest
    childProcess.exec cmd, (err)->
      console.log err if err

Meteor.startup ->
  VelocityTestFiles.find({targetFramework: thisTitle}).observe
    added: copyTestsToMirror,
    changed: copyTestsToMirror,
    removed: copyTestsToMirror

