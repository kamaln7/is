express = require 'express'
app = express()
config = require './config'
fs = require 'fs'
template = fs.readFileSync('./template.html').toString()

levelup = require 'levelup'
db = levelup './database'

app.get '/', (req, res) ->
  res.redirect '/happy'

app.get '/:word', (req, res) ->
  word = req.params.word
  db.get word, (err, positive) ->
    if err? then return res.send template.replace '{-}', 'Try something else.'

    res.send template.replace '{-}', (if positive is 1 and not config.reverse then 'Yes.' else 'No.')

app.listen config.port, config.host, ->
  console.log "[is]: #{config.host}:#{config.port}"