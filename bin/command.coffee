usage =
"""

Usage: consul-sync [options] key filename

  Sync the value of the Consul key to the file contents

options:
  --http-addr=127.0.0.1:8500    HTTP address of the Consul agent.

"""

minimist = require 'minimist'
argv = minimist process.argv[2..],
  default: 'http-addr': '127.0.0.1:8500'

if argv._.length isnt 2
  console.error usage
  process.exit 1

httpAddr = argv['http-addr']
key = argv._[0]
filename = argv._[1]

consul = require 'redwire-consul'
fs = require 'fs'

new consul.KV httpAddr, key, (configurations) ->
  try
    fs.writeFileSync filename, configurations[0].Value
    console.log "Updated #{filename} with contents of #{key}"
  catch error
    console.error "Error writing consul key #{key} to #{filename}"
    console.error error

console.log "Connecting to consul agent #{httpAddr}"
console.log "Syncing changes from #{key} to #{filename}..."