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
  robot.brain.data.tabetai = {} if not robot.brain.data.tabetai

  join_contents = (array, singular, plural) ->
    size = array.length
    if size == 0
      "no #{singular}"
    else if size == 1
      "1 #{singular}: #{array[0]}"
    else
      "#{size} #{plural}: #{array.join(", ")}"

  keys = (hash) ->
    ks = []
    for key, value of hash
      ks.push key
    ks

  robot.respond /tabetai open (.*)/i, (msg) ->
    target = msg.match[1]
    creater = msg.message.user.name
    if robot.brain.data.tabetai[target]
      msg.send "#{target} already exists."
    else
      robot.brain.data.tabetai[target] = {
        members: [creater]
      }
      msg.send "new tabetai \"#{target}\""
  
  robot.respond /tabetai close (.*)/i, (msg) ->
    target = msg.match[1]
    if not robot.brain.data.tabetai[target]
      msg.send "#{target} does not exist."
    else
      members = join_contents robot.brain.data.tabetai[target].members, "member", "members"
      delete robot.brain.data.tabetai[target]
      msg.send "closed tabetai \"#{target}\" (#{members})"

  robot.respond /tabetai join (.*)/i, (msg) ->
    target = msg.match[1]
    member = msg.message.user.name
    if not robot.brain.data.tabetai[target]
      msg.send "#{target} does not exist now."
    else if robot.brain.data.tabetai[target].members.indexOf(member) >= 0
      msg.send "#{member} has already joined #{target}."
    else
      robot.brain.data.tabetai[target].members.push member
      msg.send "#{member} joined #{target}"

  robot.respond /tabetai cancel (.*)/i, (msg) ->
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
    msg.send join_contents(keys(robot.brain.data.tabetai), "tabetai", "tabetaies")

  robot.respond /tabetai members (.*)/i, (msg) ->
    target = msg.match[1]
    if not robot.brain.data.tabetai[target]
      msg.send "#{target} does not exist."
    else
      msg.send join_contents(robot.brain.data.tabetai[target].members, "member in #{target}", "members in #{target}")

