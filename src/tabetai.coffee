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

list_elements = (singular, plural, array) ->
  switch array.length
    when 0 then return "no #{singular}"
    when 1 then return "1 #{singular}: #{array[0]}"
    else return "#{array.length} #{plural}: #{array.join(", ")}"

commands = {
help : ([], [], [], bot_name) ->
    return  """
            Hubot-tabetai is a chat-based event participants manager.
            commands:
            - `#{bot_name} tabetai open [target]` open new tabetai issue and set the active tabetai.
            - `#{bot_name} tabetai close [target]` close tabetai issue.
            - `#{bot_name} tabetai join [target]` join tabetai issue.
            - `#{bot_name} tabetai cancel [target]` cancel tabetai issue.
            - `#{bot_name} tabetai list` show alive tabetai issues.
            - `#{bot_name} tabetai members [target]` show members in specified tabetai issue.
            - `#{bot_name} tabetai invite [user1] ... [target]` invite members to tabetai issue.
            - `#{bot_name} tabetai kick [user1] ... [target]` kick members from tabetai issue.
            - `#{bot_name} tabetai help` open new tabetai issue.

            There are also shorthands of above commands: \"ku\".
            commands:
            - `#{bot_name} ku [new target]` equal to `#{bot_name} tabetai open [new target]`.
            - `#{bot_name} ku [existing target]` equal to `#{bot_name} tabetai join [existing target]`.
            - `#{bot_name} ku` join the active tabetai issue.
            """

open : (tabetai, args, creater, bot_name) ->
    return "usage: `#{bot_name} tabetai open [target]`" unless args.length
    target = args[0]
    if tabetai.list[target]
      tabetai.active = target
      return "#{target} already exists. Did you mean `#{bot_name} tabetai join #{target}`?"
    else
      tabetai.list[target] = {
        members: [creater]
      }
      tabetai.active = target
      size = tabetai.list[target].members.length
      return "new tabetai \"#{target}\" (#{list_elements("member", "members", tabetai.list[target].members)})"

close : (tabetai, args, [], bot_name) ->
    return "usage: `#{bot_name} tabetai close [target]`" unless args.length
    target = args[0]
    if not tabetai.list[target]
      return "tabetai \"#{target}\" does not exist."
    else
      members = []
      for member in tabetai.list[target].members
        members.push member
      delete tabetai.list[target]
      if tabetai.active == target
        tabetai.active = null
      return "closed tabetai \"#{target}\" (#{list_elements("member", "members", members)})"

join : (tabetai, args, member, bot_name) ->
    return "usage: `#{bot_name} tabetai join [target]`" unless args.length
    target = args[0]
    if not tabetai.list[target]
      return "tabetai \"#{target}\" does not exist now."
    else if tabetai.list[target].members.indexOf(member) >= 0
      return "#{member} has already joined #{target}."
    else
      tabetai.active = target
      tabetai.list[target].members.push member
      return "#{member} joined #{target}"

cancel : (tabetai, args, member, bot_name) ->
    return "usage: `#{bot_name} tabetai cancel [target]`" unless args.length
    target = args[0]
    if not tabetai.list[target]
      return "tabetai \"#{target}\" does not exist."
    else if tabetai.list[target].members.indexOf(member) < 0
      return "#{member} does not belong to #{target}."
    else
      idx = tabetai.list[target].members.indexOf member
      tabetai.list[target].members.splice idx, 1
      return "#{member} canceled #{target}."

list : (tabetai, [], [], []) ->
    targets = []
    for key,value of tabetai.list
      targets.push key
    return """
           #{list_elements("tabetai", "tabetaies", targets)}
           #{tabetai.active ? "nothing"} is active
           """

members : (tabetai, args, [], bot_name) ->
    return "usage: `#{bot_name} tabetai members [target]`" unless args.length
    target = args[0]
    members = []
    if not tabetai.list[target]
      return "tabetai \"#{target}\" does not exist now."
    else
      for member in tabetai.list[target].members
        members.push member
      return "#{list_elements("member", "members", members)}"

invite : (tabetai, args, inviter, bot_name) ->
    return "usage: `#{bot_name} tabetai invite [user1] ... [target]`" if args.length < 2
    [members ... , target] = args
    if not tabetai.list[target]
      return "tabetai \"#{target}\" does not exist now."
    else
      diff = tabetai.list[target].members.length
      for member in members
        commands.join tabetai, [target], member, bot_name
      diff = tabetai.list[target].members.length - diff
      return "#{inviter} invited #{diff} #{if diff >= 2 then "members" else "member"} to #{target}."

kick : (tabetai, args, kicker, bot_name) ->
    return "usage: `#{bot_name} tabetai kick [user1] ... [target]`" if args.length < 2
    [members ... , target] = args
    if not tabetai.list[target]
      return "tabetai \"#{target}\" does not exist now."
    else
      diff = tabetai.list[target].members.length
      for member in members
        commands.cancel tabetai, [target], member, bot_name
      diff -= tabetai.list[target].members.length
      return "#{kicker} kicked #{diff} #{if diff >= 2 then "members" else "member"} from #{target}."

ku : (tabetai, args, member, bot_name) ->
    if args.length > 0
      target = args[0]
      if tabetai.list[target]?
        commands.join tabetai, [target], member, bot_name
      else
        commands.open tabetai, [target], member, bot_name
    else
      if tabetai.active?
        commands.join tabetai, [tabetai.active], member, bot_name
      else
        return "there are no activated tabetai. Bless `#{bot_name} ku [target]` to activate new tabetai."
}

module.exports = (robot) ->
  init = ->
    robot.brain.data.tabetai ?= {
      active: null
      list: {}
    }

  robot.respond /tabetai\s+(\S.*)$/i, (msg)->
    init()
    [command, args ...] = msg.match[1].split /\s+/
    name = msg.message.user.name
    if commands[command]?
      msg.send commands[command](robot.brain.data.tabetai, args, name, robot.name)
    else
      msg.send "unknown command: #{command}. Did you mean `#{robot.name} tabetai open #{command}`?"
    robot.brain.save()

  robot.respond /tabetai\s*$/i, (msg) ->
    msg.send "Bless `#{robot.name} tabetai help` for help."

  robot.respond /ku\s+(\S*)$/i, (msg)->
    init()
    args = msg.match[1].split /\s+/
    name = msg.message.user.name
    msg.send commands["ku"](robot.brain.data.tabetai, args, name, robot.name)
    robot.brain.save()

  robot.respond /ku\s*$/i, (msg) ->
    init()
    name = msg.message.user.name
    msg.send commands["ku"](robot.brain.data.tabetai, [], name, robot.name)
    robot.brain.save()
