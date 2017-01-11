local function run(msg, matches)
local url = http.request("https://irapi.ir/sports/newspaper.php")
  local jdat = json:decode(url)
  local text = ''
  local random = math.random(1,10)
  for i = 1 , #jdat do
    text2 = jdat[random].image
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
