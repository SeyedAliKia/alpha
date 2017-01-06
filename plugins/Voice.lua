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

  if matches[1]:lower() == "dl" then
    local url = http.request('https://irapi.ir/sports/newspaper.php')
    local jdat = json:decode(url)
    local r = table.tostring(jdat)
    r = r:gsub("{","")
    r = r:gsub("}","")
    r = r:gsub("=","")
    r = r:gsub(",","")
    r = r:gsub("image",")
    return r
end
end
return {
  patterns = {
    "^(dl)$",
  },
  run = muteteam,
}
