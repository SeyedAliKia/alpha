function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
    tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
      table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

function muteteam(msg, matches)

  if matches[1]:lower() == "getnews" then
    local url = http.request('https://irapi.ir/sports/newspaper.php')
    local jdat = json:decode(url)
    local stt = table.tostring(jdat)
    stt = stt:gsub("{{","")
    stt = stt:gsub("}}","")
    stt = stt:gsub("},{","")
    stt = stt:gsub('"','')
    stt = stt:gsub("image=","")
    stt = stt:gsub("https","\nhttps")
    stt = stt:gsub("https","🔷🔶🔷🔶🔷🔶🔷🔶🔷\nhttps")
    stt = stt:gsub("{","")
    stt = stt:gsub("}","")
    local url , res = http.request('http://api.gpmod.ir/time/')
    if res ~= 200 then
     return reply_msg(msg.id, "❌ دوباره تلاش کنید !", ok_cb, false)
    end
    local jdat = json:decode(url)
    local text = "اخبار ورزشی روز "..jdat.FAdate.." :\n "..stt.." \n 🌐 @MuteTeam"
    return reply_msg(msg.id, text, ok_cb, false)
  end
end
return {
  patterns = {
    "^([Gg][Ee][Tt][Nn][Ee][Ww][Ss])$",
  },
  run = muteteam,
}
