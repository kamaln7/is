fs = require 'fs'
readline = require 'readline'

levelup = require 'levelup'
db = levelup './database'

colors = require 'colors'

SentiWordNet = fs.createReadStream './SentiWordNet_3.0.0_20130122.txt'
rl = readline.createInterface {
  input: SentiWordNet
  terminal: false
}

process.stdout.write 'Processing:'
count = 1
rl.on 'line', (line) ->
  return if line[0] is '#'

  line = line.split "\t"
  word = line[4].split('#')[0]
  positiveScore = line[2]
  negativeScore = line[3]
  positive = positiveScore > negativeScore

  return if not word?

  process.stdout.write " #{count} - " + if positive then word.green else word.red
  db.put word, (if positive then 1 else 0), (err) ->
    return if not err?

    rl.close()
    process.stdout.write "\n"
    console.error "An error occurred while inserting into the database: #{err}"
    process.exit()
  count++