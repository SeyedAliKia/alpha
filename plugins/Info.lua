  local function get_msgs_user_chat(user_id, chat_id)
    local user_info = {}
    local uhash = 'user:'..user_id
    local user = redis:hgetall(uhash)
    local um_hash = 'msgs:'..user_id..':'..chat_id
    user_info.msgs = tonumber(redis:get(um_hash) or 0)
    user_info.name = user_print_name(user)..' ['..user_id..']'
    return user_info
  end

local function chat_stat(chat_id, typee)
  -- Users on chat
  local hash = ''
  if typee == 'channel' then
    hash = 'channel:'..chat_id..':users'
  else
    hash = 'chat:'..chat_id..':users'
  end
  local users = redis:smembers(hash)
  local users_info = {}

  -- Get user info
  for i = 1, #users do
    local user_id = users[i]
    local user_info = get_msgs_user_chat(user_id, chat_id)
    table.insert(users_info, user_info)
  end

  -- Sort users by msgs number
  table.sort(users_info, function(a, b)
  if a.msgs and b.msgs then
    return a.msgs > b.msgs
  end
  end)

  local arian = '0'
  for k,user in pairs(users_info) do
    arian = arian + user.msgs
  end
  return arian
end

local function rsusername_cb(extra, success, result)
  if success == 1 then
    local user = result.peer_id
    local chatid = get_receiver(extra.msg)
    local username = result.username
    function round2(num, idp)
      return tonumber(string.format("%." .. (idp or 0) .. "f", num))
    end

    local r = tonumber(chat_stat(extra.msg.to.id, extra.msg.to.type) or 0)

    local hashs = 'msgs:'..result.peer_id..':'..extra.msg.to.id
    local msgss = redis:get(hashs)
    local percent = msgss / r * 100
    return reply_msg(extra.msg.id, "🔢 تعداد پیام های شما : <b>"..msgss.." </b>\n💱 تعداد پیام های گروه : <b>"..r.."  </b>",ok_cb,false)
  end
end
local function run(msg, matches)
  if matches[1]:lower() == "info" then
    local chat_id = msg.to.id
    local msgs = resolve_username(msg.from.username, rsusername_cb, {msg=msg})
    local text = "🔅 نام شما : <b>"..msg.from.first_name.." </b>\n"..tostring(msgs)
    if is_sudo(msg) or is_admin1(msg) then
      reply_document(msg.id, "./data/photos/sudo.webp", ok_cb, false)
    elseif is_owner(msg) then
      reply_document(msg.id, "./data/photos/owner.webp", ok_cb, false)
    elseif is_momod(msg) then
      reply_document(msg.id, "./data/photos/momod.webp", ok_cb, false)
    else
      reply_document(msg.id, "./data/photos/member.webp", ok_cb, false)
    end
  end
      return text
end

return {
  patterns = {
    "^([Ii][Nn][Ff][Oo])$",
  },
  run = run
}
