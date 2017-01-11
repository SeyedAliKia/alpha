local function run(msg, matches)
local url = http.request("https://irapi.ir/sports/newspaper.php")
  local jdat = json:decode(url)
  local text2 = ''
  for i = 1 , #jdat do
    text2 = text2..i
    text2 = text2..' ) اسم مبایل : '..jdat[2].image
    end
  return reply_msg(msg.id, text2, ok_cb, false)
end

return {
  description = "Get New Mobile Phones From Mobile.ir",
  patterns = {
    "^([Mm][Oo][Bb][Ii][Ll][Ee])$"
  },
  run = run
}
