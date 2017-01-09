local function run(msg, matches)
  if matches[1]:lower() == "info" then
    local chat_id = msg.to.id
    local um_hash = 'msgs:'..msg.from.peer_id..':'..msg.to.peer_id
    local user_info_msgs = tonumber(redis:get(um_hash) or 0)
    local text = "🔅 نام شما : <b>"..msg.from.first_name.." </b>\n پیام ها : "..user_info_msgs
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
