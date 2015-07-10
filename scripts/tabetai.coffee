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
#

module.exports = (robot) ->
  robot.respond /tabetai open (.*)/i, (msg) ->
    robot.brain.data.tabetai = {} if not robot.brain.data.tabetai
    target = msg.match[1]
    creater = msg.message.user.name
    if robot.brain.data.tabetai[target]
      msg.send "#{target} already exists."
    else
      robot.brain.data.tabetai[target] = {
        members: [creater]
      }
      size = robot.brain.data.tabetai[target].members.length
      msg.send "new tabetai \"#{target}\" (#{size} members)"
  
  robot.respond /tabetai close (.*)/i, (msg) ->
    robot.brain.data.tabetai = {} if not robot.brain.data.tabetai
    target = msg.match[1]
    if not robot.brain.data.tabetai[target]
      msg.send "#{target} does not exist."
    else
      members = []
      for member in robot.brain.data.tabetai[target].members
        members.push member
      delete robot.brain.data.tabetai[target]
      msg.send "closed tabetai \"#{target}\" (members: #{members.join(", ")})"

  robot.respond /tabetai join (.*)/i, (msg) ->
    robot.brain.data.tabetai = {} if not robot.brain.data.tabetai
    target = msg.match[1]
    member = msg.message.user.name
    if not robot.brain.data.tabetai[target]
      msg.send "#{target} does not exist now."
    else if robot.brain.data.tabetai[target].members.indexOf(member) >= 0
      msg.send "#{member} has already joined #{target}."
    else
      robot.brain.data.tabetai[target].members.push member
      msg.send "#{msg.message.user.name} joined #{target}"

  robot.respond /tabetai cancel (.*)/i, (msg) ->
    robot.brain.data.tabetai = {} if not robot.brain.data.tabetai
    target = msg.match[1]
    member = msg.message.user.name
    if not robot.brain.data.tabetai[target]
      msg.send "#{target} does not exist."
    else if robot.brain.data.tabetai[target].members.indexOf(member) < 0
      msg.send "#{member} does not belong to #{target}."
    else
      idx = robot.brain.data.tabetai[target].members.indexOf member
      robot.brain.data.tabetai[target].members.splice idx, 1
      msg.send "#{member} canceled #{target}."

  robot.respond /tabetai list/i, (msg) ->
    robot.brain.data.tabetai = {} if not robot.brain.data.tabetai
    targets = []
    for key,value of robot.brain.data.tabetai
      targets.push key
    msg.send "#{targets.length} tabetaies: #{targets.join ", "}"

  robot.respond /tabetai members (.*)/i, (msg) ->
    robot.brain.data.tabetai = {} if not robot.brain.data.tabetai
    target = msg.match[1]
    members = []
    if not robot.brain.data.tabetai[target]
      msg.send "#{target} does not exist now."
    else
      for member in robot.brain.data.tabetai[target].members
        members.push member
      msg.send "#{members.length} members in #{target}: #{members.join ", "}"

