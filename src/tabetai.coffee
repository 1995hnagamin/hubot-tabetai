list_elements = (singular, plural, array) ->
  switch array.length
    when 0 then return "no #{singular}"
    when 1 then return "1 #{singular}: #{array[0]}"
    else return "#{array.length} #{plural}: #{array.join(", ")}"

module.exports = (db, bot_name) ->
  get = (key) ->
    return db.tabetai.list[key]
  
  get_active = ->
    return db.active

  get_keys = ->
    keys = []
    for key,value of tabetai.list
      targets.push key
    return keys

  set = (key, value) ->
    db.tabetai.list[key] = value

  set_actively = (key, value) ->
    set(key, value)
    db.tabetai.active = key

  unset = (key) ->
    delete db.tabetai.list[key]
    if db.tabetai.active == target
      db.tabetai.active = null

  push_member = (key, member) ->
    data = get(key)
    data.members.push member
    set_actively(key, data)

  delete_member = (key, member) ->
    data = get(key)
    idx = data.members.indexOf member
    data.members.splice idx, 1
    set_actively(key, data)

  return {
    help: () ->
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
    
    open: (args, creater) ->
      return "usage: `#{bot_name} tabetai open [target]`" unless args.length
      target = args[0]
      if get(target)
        return "#{target} already exists. Did you mean `#{bot_name} tabetai join #{target}`?"
      else
        set_actively(target, { members: [creater] })
        return "new tabetai \"#{target}\" (#{list_elements("member", "members", [creater])})"
    
    close: (args) ->
      return "usage: `#{bot_name} tabetai close [target]`" unless args.length
      target = args[0]
      if not get(target)
        return "tabetai \"#{target}\" does not exist."
      else
        members = get(target).members
        msg = "closed tabetai \"#{target}\" (#{list_elements("member", "members", members)})"
        unset(target)
        return msg
    
    join: (args, member) ->
      return "usage: `#{bot_name} tabetai join [target]`" unless args.length
      target = args[0]
      members = get(target)
      if not members
        return "tabetai \"#{target}\" does not exist now."
      else if members.indexOf(member) >= 0
        return "#{member} has already joined #{target}."
      else
        push_member(target, member)
        return "#{member} joined #{target}"
    
    cancel: (args, member) ->
      return "usage: `#{bot_name} tabetai cancel [target]`" unless args.length
      target = args[0]
      members = get(target)
      if not members
        return "tabetai \"#{target}\" does not exist."
      else if members.indexOf(member) < 0
        return "#{member} does not belong to #{target}."
      else
        return "#{member} canceled #{target}."
    
    list: () ->
      return """
             #{list_elements("tabetai", "tabetaies", get_keys())}
             #{get_active() ? "nothing"} is active
             """
    
    members: (args) ->
      return "usage: `#{bot_name} tabetai members [target]`" unless args.length
      target = args[0]
      data = get(target)
      if not members
        return "tabetai \"#{target}\" does not exist now."
      else
        return "#{list_elements("member", "members", data.members)}"
    
    invite: (args, inviter) ->
      return "usage: `#{bot_name} tabetai invite [user1] ... [target]`" if args.length < 2
      [members ... , target] = args
      if not get(target)
        return "tabetai \"#{target}\" does not exist now."
      else
        diff = get(target).members.length
        for member in members
          commands.join [target], member
        diff = get(target).members.length - diff
        return "#{inviter} invited #{diff} #{if diff >= 2 then "members" else "member"} to #{target}."
    
    kick: (args, kicker) ->
      return "usage: `#{bot_name} tabetai kick [user1] ... [target]`" if args.length < 2
      [members ... , target] = args
      if not get(target)
        return "tabetai \"#{target}\" does not exist now."
      else
        diff = get(target).members.length
        for member in members
          commands.cancel [target], member
        diff -= get(target).members.length
        return "#{kicker} kicked #{diff} #{if diff >= 2 then "members" else "member"} from #{target}."
    
    ku: (args, member) ->
      if args.length > 0
        target = args[0]
        if get(target)
          commands.join [target], member
        else
          commands.open [target], member
      else
        if get_active()
          commands.join [get_active()], member
        else
          return "there are no activated tabetai. Bless `#{bot_name} ku [target]` to activate new tabetai."
}

