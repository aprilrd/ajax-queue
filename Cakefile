fs = require "fs"
{print}       = require 'util'
{spawn, exec} = require 'child_process'

# ANSI Terminal Colors
bold  = '\x1B[0;1m'
red   = '\x1B[0;31m'
green = '\x1B[0;32m'
reset = '\x1B[0m'

spawnedProcesses = []

cleanup = (e) ->
  console.log e.message if e?.message?
  while spawnedProcesses.length > 0
    {spawned, command} = spawnedProcesses.shift()
    spawned.kill()
    console.log "Killed #{command}"

process.on 'SIGINT', cleanup
process.on 'exit', cleanup
process.on 'uncaughtException', cleanup

# Helpers
log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

spawnWithStdout = (command, args, callback) ->
  spawned = spawn command, args
  spawned.stdout.pipe process.stdout
  spawned.stderr.pipe process.stderr
  if callback?
    spawned.on 'exit', callback

  spawnedProcesses.push {command, spawned}
  return spawned

# Micro jobs
build = (callback) ->
  spawnWithStdout 'coffee', ['-c','-b', '-o', 'public/js', 'src'], callback

watch = (callback) ->
  spawnWithStdout 'coffee', ['-c', '-b', '-w', '-o', 'public/js', 'src'], callback

test = (callback) ->
  try
    spawnWithStdout 'mocha', [
      '--compilers'
      'coffee:coffee-script'
      '--colors'
      '--require'
      'should'
      '--require'
      './server'
    ], callback
  catch err
    log err.message, red
    log 'Mocha is not installed - try npm install mocha -g', red

child = ->
  log "#{spawnedProcesses.length} child processes are running", green

task 'build', "Build javascript sources", ->
  build -> log "Built!", green

task 'watch', "Watching coffee files", ->
  watch -> log "Done watching", green

task 'test', 'Run Mocha tests', ->
  build -> test -> log "Tests Complete!", green

task 'child', 'Check current child processes', ->
  child()