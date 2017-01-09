local function run(msg, matches)
  if matches[1]:lower() == "info" then
    local name = msg.from.first_name
    if msg.from.last_name then
      lname = (msg.from.last_name or '---')
      end
    if msg.from.username then
      username = (msg.from.username or "---")  
     end   
    local id = msg.from.id
    local text = name..lname..username
    reply_msg(msg.id, text, ok_cb, false)
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
end

return {
  patterns = {
    "^([Ii][Nn][Ff][Oo])$",
  },
  run = run
}
