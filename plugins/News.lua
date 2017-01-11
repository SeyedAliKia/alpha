local function run(msg, matches)
local url = http.request("https://irapi.ir/sports/newspaper.php")
  local jdat = json:decode(url)
  local text = ''
  local random = math.random(1,10)
  for i = 1 , #jdat do
    text = jdat[random].image
    end
  local file = download_to_file(text, '@Flooding.jpg')
  reply_photo(msg.id, file, ok_cb, false)
end

return {
  description = "Get New Mobile Phones From Mobile.ir",
  patterns = {
    "^([Mm][Oo][Bb][Ii][Ll][Ee])$"
  },
  run = run
}
