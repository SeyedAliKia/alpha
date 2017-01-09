local function run(msg, matches)
  if matches[1]:lower() == "info" then
    local name = msg.from.first_name
    if msg.from.last_name then
      local lname = (msg.from.last_name or "---")
      end
    if msg.from.username then
      local username = (msg.from.username or "---")  
     end   
    local id = msg.from.id
    local text = name..lname..username
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
