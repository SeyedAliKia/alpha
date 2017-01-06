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

function randomlist(l, samp)
  local newlist
  newlist = {}
  if not samp then 
    samp = 0 
  else
    samp = #l - samp
  end
  while #l > samp do
    local idx
    idx = math.random(1, #l)
    newlist[#newlist + 1] = l[idx]
    table.remove(l, idx)
  end
  return newlist
end

function muteteam(msg, matches)

  if matches[1]:lower() == "dl" then
    local url = http.request('https://irapi.ir/sports/newspaper.php')
    local jdat = json:decode(url)
    local ran = table.tostring(jdat)
    local r = randomlist(ran, 0)
    r = r:gsub("{","")
    r = r:gsub("}","")
    r = r:gsub("=","")
    r = r:gsub(",","")
    r = r:gsub("image","")
    r = r:gsub('"','')
    r = r:gsub("https","\nhttps")
    return r
end
end
return {
  patterns = {
    "^(dl)$",
  },
  run = muteteam,
}
