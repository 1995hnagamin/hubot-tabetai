# Description:
#   manage members who want to eat pizza.
#
# Commands:
#   tabetai open [name]     - open new tabetai issue
#   tabetai close [name]    - close tabetai issue
#   tabetai join [name]     - join tabetai issue
#   tabetai cancel [name]   - cancel tabetai issue
#   tabetai list            - show active tabetai issues
#   tabetai members [name]  - show members in tabetai issues
#   ku ([name])             - shorthand of tabetai. open or join [name] | join active taebetai
#

commands = {
open : (tabetai, target, creater) ->
    return "usage: tabetai open [target]" unless target
    if tabetai.list[target]
      tabetai.active = target
      return "#{target} already exists. reactivate it."
    else
      tabetai.list[target] = {
        members: [creater]
      }
      tabetai.active = target
      size = tabetai.list[target].members.length
      return "new tabetai \"#{target}\" (#{size} members)"

close : (tabetai, target, []) ->
    return "usage: tabetai close [target]" unless target
    if not tabetai.list[target]
      return "#{target} does not exist."
    else
      members = []
      for member in tabetai.list[target].members
        members.push member
      delete tabetai.list[target]
      if tabetai.active == target
        tabetai.active = null
      return "closed tabetai \"#{target}\" (members: #{members.join(", ")})"

join : (tabetai, target, member) ->
    return "usage: tabetai join [target]" unless target
    if not tabetai.list[target]
      return "#{target} does not exist now."
    else if tabetai.list[target].members.indexOf(member) >= 0
      return "#{member} has already joined #{target}."
    else
      tabetai.active = target
      tabetai.list[target].members.push member
      return "#{member} joined #{target}"

cancel : (tabetai, target, member) ->
    return "usage: tabetai cancel [target]" unless target
    if not tabetai.list[target]
      return "#{target} does not exist."
    else if tabetai.list[target].members.indexOf(member) < 0
      return "#{member} does not belong to #{target}."
    else
      idx = tabetai.list[target].members.indexOf member
      tabetai.list[target].members.splice idx, 1
      return "#{member} canceled #{target}."

list : (tabetai, [], []) ->
    targets = []
    for key,value of tabetai.list
      targets.push key
    return """
           #{targets.length} tabetaies: #{targets.join ", "}
           #{tabetai.active ? "nothing"} is active
           """

members : (tabetai, target, []) ->
    return "usage: tabetai members [target]" unless target
    members = []
    if not tabetai.list[target]
      return "#{target} does not exist now."
    else
      for member in tabetai.list[target].members
        members.push member
      return "#{members.length} members in #{target}: #{members.join ", "}"

ku : (tabetai, target, member) ->
    if target
      if tabetai[target]?
        commands.join tabetai, target, member
      else
        commands.open tabetai, target, member
    else
      if tabetai.active?
        commands.join tabetai, tabetai.active, member
      else
        return "there are no activated tabetai. Bless `#{robot.name} ku [target]` to activate new tabetai."
}

module.exports = (robot) ->
  robot.respond /tabetai\s+(\S+)\s*(\S*)/i, (msg)->
    robot.brain.data.tabetai ?=  {
        active : null 
        list : {}
      }
    command = msg.match[1].toLowerCase()
    target = msg.match[2]
    name = msg.message.user.name
    if commands[command]?
      msg.send commands[command](robot.brain.data.tabetai, target, name)
    else
      msg.send "unknown command: #{command}. Did you mean `#{robot.name} tabetai open #{command}`?"

  robot.respond /ku\s*(\S*)/i, (msg)->
    robot.brain.data.tabetai ?=  {
        active : null 
        list : {}
      }
    target = msg.match[1]
    name = msg.message.user.name
    msg.send commands["ku"](robot.brain.data.tabetai, target, name)

