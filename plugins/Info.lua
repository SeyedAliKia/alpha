do
  local function run(msg, matches)
    if matches[1]:lower() == "info" then
      if is_sudo(msg) or is_admin1(msg) then
        reply_document(msg.id, "./data/photos/sudo.webp", ok_cb, false)
      end
      if is_owner(msg) then
        reply_document(msg.id, "./data/photos/owner.webp", ok_cb, false)
      end
      if is_momod(msg) then
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

end
