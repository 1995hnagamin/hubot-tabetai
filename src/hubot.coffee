# Description:
#   manage members who want to eat pizza.
#
# Commands:
# hubot tabetai open <food>     - open new tabetai issue
# hubot tabetai close <food>    - close tabetai issue
# hubot tabetai join <food>     - join tabetai issue
# hubot tabetai cancel <food>   - cancel tabetai issue
# hubot tabetai list            - show alive tabetai issues
# hubot tabetai members <food>  - show members in tabetai issue
# hubot tabetai invite <user1> <user2> ... <food> - invite members to tabetai issue
# hubot tabetai kick <user1> <user2> ... <food> - kick members from tabetai issue
# hubot ku [food]               - shorthand of tabetai. open or join, the active or specified tabetai
# hubot tabetai help            - show help
#

module.exports = (robot) ->
  commands = require("./tabetai")(robot.brain, robot.name)

  robot.respond /tabetai\s+(\S.*)$/i, (msg)->
    [command, args ...] = msg.match[1].split /\s+/
    name = msg.message.user.name
    if commands[command]?
      msg.send commands[command](args, name)
    else
      msg.send "unknown command: #{command}. Did you mean `#{robot.name} tabetai open #{command}`?"

  robot.respond /tabetai\s*$/i, (msg) ->
    msg.send "Bless `#{robot.name} tabetai help` for help."

  robot.respond /ku\s+(\S*)$/i, (msg)->
    args = msg.match[1].split /\s+/
    name = msg.message.user.name
    msg.send commands["ku"](args, name)

  robot.respond /ku\s*$/i, (msg) ->
    name = msg.message.user.name
    msg.send commands["ku"]([], name)
