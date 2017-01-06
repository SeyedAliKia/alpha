function run(msg, matches)

  if matches[1]:lower() == "voice" then
    if string.len(matches[2]) > 20 then
      return reply_msg(msg.id, "❌ تعداد کاراکتر ها باید کمتر از 20 باشد !", ok_cb, false)
    else
      local url = "https://irapi.ir/aryana/api.php?text="..matches[2]
      local file = download_to_file(url, 'voice.ogg')
      send_audio(get_receiver(msg), file, ok_cb, false)
      --reply_file(msg.id, file, ok_cb, false) //Edit lua-tg.c
    end
  end

end

return {
patterns = {
  "^([Vv][Oo][Ii][Cc][Ee]) +(.*)$",
},
run = run,
}
