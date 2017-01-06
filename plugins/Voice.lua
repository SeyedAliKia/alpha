function muteteam(msg, matches)

  if matches[1]:lower() == "dl" then
local url = http.request('https://irapi.ir/sports/newspaper.php')
    local jdat = json:decode(url)
    return jdat
end

return {
  patterns = {
    "^(dl)$",
  },
  run = muteteam,
}
