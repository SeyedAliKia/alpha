
local function pre_process(msg)
  local data = load_data(_config.moderation.data)
  -- SERVICE MESSAGE
  if msg.action and msg.action.type then
    local action = msg.action.type
    -- Check if banned user joins chat by link
    if action == 'chat_add_user_link' then
      local user_id = msg.from.id
      print('Checking invited user '..user_id)
      local banned = is_banned(user_id, msg.to.id)
      if banned or is_gbanned(user_id) then -- Check it with redis
      print('User is banned!')
      local print_name = user_print_name(msg.from):gsub("‮", "")
	  local name = print_name:gsub("_", "")
      kick_user(user_id, msg.to.id)
      end
    end
    -- Check if banned user joins chat
    if action == 'chat_add_user' then
      local user_id = msg.action.user.id
      print('Checking invited user '..user_id)
      local banned = is_banned(user_id, msg.to.id)
      if banned and not is_momod2(msg.from.id, msg.to.id) or is_gbanned(user_id) and not is_admin2(msg.from.id) then -- Check it with redis
        --print('User is banned!')
      local print_name = user_print_name(msg.from):gsub("‮", "")
	  local name = print_name:gsub("_", "")
        kick_user(user_id, msg.to.id)
        local banhash = 'addedbanuser:'..msg.to.id..':'..msg.from.id
        redis:incr(banhash)
        local banhash = 'addedbanuser:'..msg.to.id..':'..msg.from.id
        local banaddredis = redis:get(banhash)
        if banaddredis then
          if tonumber(banaddredis) >= 4 and not is_owner(msg) then
            kick_user(msg.from.id, msg.to.id)-- Kick user who adds ban ppl more than 3 times
          end
          if tonumber(banaddredis) >=  8 and not is_owner(msg) then
            ban_user(msg.from.id, msg.to.id)-- Kick user who adds ban ppl more than 7 times
            local banhash = 'addedbanuser:'..msg.to.id..':'..msg.from.id
            redis:set(banhash, 0)-- Reset the Counter
          end
        end
      end
     if data[tostring(msg.to.id)] then
       if data[tostring(msg.to.id)]['settings'] then
         if data[tostring(msg.to.id)]['settings']['lock_bots'] then
           bots_protection = data[tostring(msg.to.id)]['settings']['lock_bots']
          end
        end
      end
    if msg.action.user.username ~= nil then
      if string.sub(msg.action.user.username:lower(), -3) == 'bot' and not is_momod(msg) then --- Will kick bots added by normal users
          kick_user(msg.action.user.id, msg.to.id)
      end
    end
  end
    -- No further checks
  return msg
  end
  -- banned user is talking !
  if msg.to.type == 'chat' or msg.to.type == 'channel' then
    local group = msg.to.id
    local texttext = 'groups'
    --if not data[tostring(texttext)][tostring(msg.to.id)] and not is_realm(msg) then -- Check if this group is one of my groups or not
    --chat_del_user('chat#id'..msg.to.id,'user#id'..our_id,ok_cb,false)
    --return
    --end
    local user_id = msg.from.id
    local chat_id = msg.to.id
    local banned = is_banned(user_id, chat_id)
    if banned or is_gbanned(user_id) then -- Check it with redis
      print('Banned user talking!')
      local print_name = user_print_name(msg.from):gsub("‮", "")
	  local name = print_name:gsub("_", "")
      kick_user(user_id, chat_id)
      msg.text = ''
    end
  end
  return msg
end

local function kick_ban_res(extra, success, result)
      local chat_id = extra.chat_id
	  local chat_type = extra.chat_type
	  if chat_type == "chat" then
		receiver = 'chat#id'..chat_id
	  else
		receiver = 'channel#id'..chat_id
	  end
	  if success == 0 then
		return send_large_msg(receiver, "❌ کاربر مورد نظر پیدا نشد !")
	  end
      local member_id = result.peer_id
      local user_id = member_id
      local member = result.username
	  local from_id = extra.from_id
      local get_cmd = extra.get_cmd
       if get_cmd == "kick" then
         if member_id == from_id then
            send_large_msg(receiver, "⛔️ شما نمیتوانید خودتان را اخراج کنید !")
			return
         end
         if is_momod2(member_id, chat_id) and not is_admin2(sender) then
            send_large_msg(receiver, "⛔️ شما نمیتوانید مدیران را اخراج کنید !")
			return
         end
		 kick_user(member_id, chat_id)
      elseif get_cmd == 'ban' then
        if is_momod2(member_id, chat_id) and not is_admin2(sender) then
			send_large_msg(receiver, "⛔️ شما نمیتوانید مدیران را بن کنید !")
			return
        end
        send_large_msg(receiver, '💢 کاربر <b>['..member_id..'] </b>@'..member..' بن شد !')
		ban_user(member_id, chat_id)
      elseif get_cmd == 'unban' then
        send_large_msg(receiver, '♨️ کاربر <b>['..member_id..'] </b>@'..member..' آن بن شد !')
        local hash =  'banned:'..chat_id
        redis:srem(hash, member_id)
        return 'User '..user_id..' unbanned'
      elseif get_cmd == 'banall' then
        send_large_msg(receiver, '💢 کاربر <b>['..member_id..'] </b>@'..member..' سوپر بن شد !')
		banall_user(member_id)
      elseif get_cmd == 'unbanall' then
        send_large_msg(receiver, '♨️ کاربر <b>['..member_id..'] </b>@'..member..' آن سوپر بن شد !')
	    unbanall_user(member_id)
    end
end

local function run(msg, matches)
local support_id = msg.from.id

  if not is_momod(msg) then -- Ignore normal users
    return
  end

  if matches[1]:lower() == "banlist" then -- Ban list !
    local chat_id = msg.to.id
    if matches[2] and is_admin1(msg) then
      chat_id = matches[2]
    end
    return ban_list(chat_id)
  end
  if matches[1]:lower() == 'ban' then-- /ban
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      if is_admin1(msg) then
		msgr = get_message(msg.reply_id,ban_by_reply_admins, false)
      else
        msgr = get_message(msg.reply_id,ban_by_reply, false)
      end
      local user_id = matches[2]
      local chat_id = msg.to.id
    elseif string.match(matches[2], '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
         	return
        end
        if not is_admin1(msg) and is_momod2(matches[2], msg.to.id) then
          	return reply_msg(msg.id, '⛔️ شما نمیتوانید مدیران را بن کنید !', ok_cb, false)
        end
        if tonumber(matches[2]) == tonumber(msg.from.id) then
          	return reply_msg(msg.id, '⛔️ شما نمیتوانید خودتان را بن کنید !', ok_cb, false)
        end
        local print_name = user_print_name(msg.from):gsub("‮", "")
	    local name = print_name:gsub("_", "")
		local receiver = get_receiver(msg)
        ban_user(matches[2], msg.to.id)
		--send_large_msg(receiver, 'User ['..matches[2]..'] banned')
		reply_msg(msg.id, '💢 کاربر <b>['..matches[2]..'] </b>بن شد !')	
      else
		local cbres_extra = {
		chat_id = msg.to.id,
		get_cmd = 'ban',
		from_id = msg.from.id,
		chat_type = msg.to.type
		}
		local username = string.gsub(matches[2], '@', '')
		resolve_username(username, kick_ban_res, cbres_extra)
    end
  end


  if matches[1]:lower() == 'unban' then -- /unban
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      local msgr = get_message(msg.reply_id,unban_by_reply, false)
    end
      local user_id = matches[2]
      local chat_id = msg.to.id
      local targetuser = matches[2]
      if string.match(targetuser, '^%d+$') then
        	local user_id = targetuser
        	local hash =  'banned:'..chat_id
        	redis:srem(hash, user_id)
        	local print_name = user_print_name(msg.from):gsub("‮", "")
			local name = print_name:gsub("_", "")
        	return reply_msg(msg.id, '♨️ کاربر '..user_id..' آن بن شد !', ok_cb, false)
      else
		local cbres_extra = {
			chat_id = msg.to.id,
			get_cmd = 'unban',
			from_id = msg.from.id,
			chat_type = msg.to.type
		}
		local username = string.gsub(matches[2], '@', '')
		resolve_username(username, kick_ban_res, cbres_extra)
	end
 end

if matches[1]:lower() == 'kick' then
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      if is_admin1(msg) then
        msgr = get_message(msg.reply_id,Kick_by_reply_admins, false)
      else
        msgr = get_message(msg.reply_id,Kick_by_reply, false)
      end
	elseif string.match(matches[2], '^%d+$') then
		if tonumber(matches[2]) == tonumber(our_id) then
			return
		end
		if not is_admin1(msg) and is_momod2(matches[2], msg.to.id) then
			return reply_msg(msg.id, '⛔️ شما نمیتوانید مدیران را اخراج کنید !', ok_cb, false)
		end
		if tonumber(matches[2]) == tonumber(msg.from.id) then
			return reply_msg(msg.id, '⛔️ شما نمیتوانید خودتان را اخراج کنید !', ok_cb, false)
		end
    local user_id = matches[2]
    local chat_id = msg.to.id
		local print_name = user_print_name(msg.from):gsub("‮", "")
		local name = print_name:gsub("_", "")
		kick_user(user_id, chat_id)
	else
		local cbres_extra = {
			chat_id = msg.to.id,
			get_cmd = 'kick',
			from_id = msg.from.id,
			chat_type = msg.to.type
		}
		local username = string.gsub(matches[2], '@', '')
		resolve_username(username, kick_ban_res, cbres_extra)
	end
end


	if not is_admin1(msg) and not is_support(support_id) then
		return
	end

  if matches[1]:lower() == 'superban' and is_admin1(msg) then -- Global ban
    if type(msg.reply_id) ~="nil" and is_admin1(msg) then
      banall = get_message(msg.reply_id,banall_by_reply, false)
    end
    local user_id = matches[2]
    local chat_id = msg.to.id
      local targetuser = matches[2]
      if string.match(targetuser, '^%d+$') and matches[2] then
        if tonumber(matches[2]) == tonumber(our_id) then
         	return false
        end
        	banall_user(targetuser)
       		return reply_msg(msg.id, '💢 کاربر [<b>'..user_id..'] </b>سوپر بن شد !', ok_cb, false)
     else
	local cbres_extra = {
		chat_id = msg.to.id,
		get_cmd = 'banall',
		from_id = msg.from.id,
		chat_type = msg.to.type
	}
		local username = string.gsub(matches[2], '@', '')
		resolve_username(username, kick_ban_res, cbres_extra)
      end
  end
  if matches[1]:lower() == 'unsuperban' then -- Global unban
    local user_id = matches[2]
    local chat_id = msg.to.id
      if string.match(matches[2], '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
          	return false
        end
       		unbanall_user(user_id)
        	return reply_msg(msg.id, '💢 کاربر [<b>'..user_id..' </b>]آن سوپر بن شد !', ok_cb, false)
    else
		local cbres_extra = {
			chat_id = msg.to.id,
			get_cmd = 'unbanall',
			from_id = msg.from.id,
			chat_type = msg.to.type
		}
		local username = string.gsub(matches[2], '@', '')
		resolve_username(username, kick_ban_res, cbres_extra)
      end
  end
  if matches[1]:lower() == "superbanlist" then -- Global ban list
    return banall_list()
  end
end

return {
  patterns = {
    "^([Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn]) (.*)$",
    "^([Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn])$",
    
    "^([Bb][Aa][Nn][Ll][Ii][Ss][Tt]) (.*)$",
    "^([Bb][Aa][Nn][Ll][Ii][Ss][Tt])$",
    "^([Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn][Ll][Ii][Ss][Tt])$",
    
    "^([Kk]ick)$",
    "^([Kk][Ii][Cc][Kk]) (.*)$",
    
    "^([Bb][Aa][Nn])$",
    "^([Bb][Aa][Nn]) (.*)$",
    
    "^([Uu][Nn][Bb][Aa][Nn]) (.*)$",
    "^([Uu][Nn][Bb][Aa][Nn])$",
    
    "^([Uu][Nn][Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn]) (.*)$",
    "^([Uu][Nn][Ss][Uu][Pp][Ee][Rr][Bb][Aa][Nn])$",
    
    "^!!tgservice (chat_add_user)$",
    "^!!tgservice (chat_add_user_link)$",
  },
  run = run,
  pre_process = pre_process
}
