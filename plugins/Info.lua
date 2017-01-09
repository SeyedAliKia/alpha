local function run(msg, matches)
  if matches[1]:lower() == "info" then
 if msg.from.username then
   Username = '@'..msg.from.username
   else
   Username = '----'
   end
   local text = 'First name : '..(msg.from.first_name or '----')..'\n'
   local text = text..'Last name : '..(msg.from.last_name or '----')..'\n'	
   local text = text..'Username : '..Username..'\n'
   local text = text..'ID : '..msg.from.id..'\n\n'
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
