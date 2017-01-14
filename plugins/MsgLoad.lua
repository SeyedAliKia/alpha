--Begin msg_checks.lua
--Begin pre_process function
local function pre_process(msg)
-- Begin 'RondoMsgChecks' text checks by @rondoozle
if is_chat_msg(msg) or is_super_group(msg) then
	if msg and not is_momod(msg) and not is_whitelisted(msg.from.id) then --if regular user
	local to_chat = msg.to.type == 'chat'
	local hash1 = 'link:'..msg.to.id
local hash2 = 'fwd:'..msg.to.id
local hash3 = 'reply:'..msg.to.id
local hash4 = 'cmd:'..msg.to.id
local hash5 = 'spam:'..msg.to.id
local hash6 = 'persian:'..msg.to.id
local hash7 = 'tgservice:'..msg.to.id
local hash8 = 'sticker:'..msg.to.id
local hash9 = 'contact:'..msg.to.id
local hash10 = 'strict:'..msg.to.id
local hash11 = 'username:'..msg.to.id
local hash12 = 'english:'..msg.to.id	
			
		if msg and not msg.service and is_muted(msg.to.id, 'All: yes') or is_muted_user(msg.to.id, msg.from.id) then
			delete_msg(msg.id, ok_cb, false)
		end
		if msg.text then -- msg.text checks
			local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
			 local _nl, real_digits = string.gsub(msg.text, '%d', '')
			if redis:get(hash5) and string.len(msg.text) > 2049 or ctrl_chars > 40 or real_digits > 2000 then
				delete_msg(msg.id, ok_cb, false)
				if redis:get(hash10) or to_chat then
					delete_msg(msg.id, ok_cb, false)
					kick_user(msg.from.id, msg.to.id)
				end
			end
			local is_username_msg = msg.text:match("@")
			if is_username_msg and redis:get(hash11) then
				delete_msg(msg.id, ok_cb, false)
				if redis:get(hash10) or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
		end
			local is_en_msg = msg.text:match("[a-z]") or msg.text:match("[A-Z]") 
			if is_en_msg then
				delete_msg(msg.id, ok_cb, false)
				if redis:get(hash10) or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
		end				
			local is_link_msg = msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.text:match("[Tt].[Mm][Ee]") or msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]")
			if is_link_msg and redis:get(hash1) then
				delete_msg(msg.id, ok_cb, false)
				if redis:get(hash10) or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
		end				
		if msg.service then 
			if redis:get(hash7) and not to_chat then
				delete_msg(msg.id, ok_cb, false)
			end
		end
			local is_squig_msg = msg.text:match("[\216-\219][\128-\191]")
			if is_squig_msg and redis:get(hash6) then
				delete_msg(msg.id, ok_cb, false)
				if redis:get(hash10) or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			if is_muted(msg.to.id, "Text: yes") and msg.text and not msg.media and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
		end
		if msg.media then -- msg.media checks
			if msg.media.title then
				local is_link_title = msg.media.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.media.title:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.media.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") or msg.media.title:match("[Tt].[Mm][Ee]") 
				if is_link_title and redis:get(hash1) then
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local is_squig_title = msg.media.title:match("[\216-\219][\128-\191]")
				if is_squig_title and redis:get(hash6) then
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
					
				local is_en_title = msg.media.title:match("[a-z]") or msg.media.title:match("[A-Z]")
				if is_en_title then
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
					
				local is_username_title = msg.media.title:match("@")
				if is_username_title and redis:get(hash11) then
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
					
			end
			if msg.media.description then
				local is_link_desc = msg.media.description:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.media.description:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.media.description:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") or msg.media.description:match("[Tt].[Mm][Ee]")				
                                  if is_link_desc and redis:get(hash1) then
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local is_squig_desc = msg.media.description:match("[\216-\219][\128-\191]")
				if is_squig_desc and redis:get(hash6) then
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
					
				local is_username_desc = msg.media.description:match("@")
				if is_username_desc and redis:get(hash11) then
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local is_en_desc = msg.media.description:match("[a-z]") or msg.media.description:match("[A-Z]")
				if is_en_desc then
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end					
			end
			if msg.media.caption then -- msg.media.caption checks
				local is_link_caption = msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.media.caption:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") or msg.media.caption:match("[Tt].[Mm][Ee]")				
                                  if is_link_caption and redis:get(hash1) then
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local is_squig_caption = msg.media.caption:match("[\216-\219][\128-\191]")
					if is_squig_caption and redis:get(hash6) then
						delete_msg(msg.id, ok_cb, false)
						if redis:get(hash10) or to_chat then
							kick_user(msg.from.id, msg.to.id)
						end
					end
				local is_username_caption = msg.media.caption:match("@")
				if is_username_caption then
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local is_en_caption = msg.media.caption:match("[a-z]") or msg.media.caption:match("[A-Z]")
				if is_en_caption and redis:get(hash12) then
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end					
				if redis:get(hash8) and msg.media.caption:match("sticker.webp") then
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
			end
			if msg.media.type:match("contact") and redis:get(hash9) then
				delete_msg(msg.id, ok_cb, false)
				if redis:get(hash10) or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			local is_photo_caption =  msg.media.caption and msg.media.caption:match("photo")--".jpg",
			if is_muted(msg.to.id, 'Photo: yes') and msg.media.type:match("photo") or is_photo_caption and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if redis:get(hash10) or to_chat then
					--	kick_user(msg.from.id, msg.to.id)
				end
			end
			local is_gif_caption =  msg.media.caption and msg.media.caption:match(".mp4")
			if is_muted(msg.to.id, 'Gifs: yes') and is_gif_caption and msg.media.type:match("document") and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if redis:get(hash10) or to_chat then
					--	kick_user(msg.from.id, msg.to.id)
				end
			end
			if is_muted(msg.to.id, 'Audio: yes') and msg.media.type:match("audio") and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if redis:get(hash10) or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			local is_video_caption = msg.media.caption and msg.media.caption:lower(".mp4","video")
			if  is_muted(msg.to.id, 'Video: yes') and msg.media.type:match("video") and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if redis:get(hash10) or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			if is_muted(msg.to.id, 'Documents: yes') and msg.media.type:match("document") and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if redis:get(hash10) or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
		end
		if msg.fwd_from then
			if redis:get(hash2) then
                         delete_msg(msg.id, ok_cb, false)			
			 end
			if redis:get(hash10) or to_chat then
			 delete_msg(msg.id, ok_cb, false)
			 kick_user(msg.from.id, msg.to.id)
			end	
			if msg.fwd_from.title then
				local is_link_title = msg.fwd_from.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.fwd_from.title:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or msg.fwd_from.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]") or msg.fwd_from.title:match("[Tt].[Mm][Ee]")								
                                 if is_link_title and redis:get(hash1) then
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local is_squig_title = msg.fwd_from.title:match("[\216-\219][\128-\191]")
				if is_squig_title and redis:get(hash6) then
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
					
				local is_username_title = msg.fwd_from.title:match("@")
				if is_username_title and redis:get(hash11) then
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
					
				local is_en_title = msg.fwd_from.title:match("[a-z]") or msg.fwd_from.title:match("[A-Z]")
				if is_en_title and redis:get(hash12) then
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end						
			end
			if is_muted_user(msg.to.id, msg.fwd_from.peer_id) then
				delete_msg(msg.id, ok_cb, false)
			end
		end
		--[[if msg.service then -- msg.service checks
		local action = msg.action.type
			if action == 'chat_add_user_link' then
				local user_id = msg.from.id
				local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
				if string.len(msg.from.print_name) > 70 or ctrl_chars > 40 and lock_group_spam == 'yes' then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] joined and Service Msg deleted (#spam name)")
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						savelog(msg.to.id, name_log.." ["..msg.from.id.."] joined and kicked (#spam name)")
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local print_name = msg.from.print_name
				local is_rtl_name = print_name:match("‮")
				if is_rtl_name and lock_rtl == "yes" then
					savelog(msg.to.id, name_log.." User ["..msg.from.id.."] joined and kicked (#RTL char in name)")
					kick_user(user_id, msg.to.id)
				end
				if lock_member == 'yes' then
					savelog(msg.to.id, name_log.." User ["..msg.from.id.."] joined and kicked (#lockmember)")
					kick_user(user_id, msg.to.id)
					delete_msg(msg.id, ok_cb, false)
				end
			end
			if action == 'chat_add_user' and not is_momod2(msg.from.id, msg.to.id) then
				local user_id = msg.action.user.id
				if string.len(msg.action.user.print_name) > 70 and lock_group_spam == 'yes' then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] added ["..user_id.."]: Service Msg deleted (#spam name)")
					delete_msg(msg.id, ok_cb, false)
					if redis:get(hash10) or to_chat then
						savelog(msg.to.id, name_log.." ["..msg.from.id.."] added ["..user_id.."]: added user kicked (#spam name) ")
						delete_msg(msg.id, ok_cb, false)
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local print_name = msg.action.user.print_name
				local is_rtl_name = print_name:match("‮")
				if is_rtl_name and lock_rtl == "yes" then
					savelog(msg.to.id, name_log.." User ["..msg.from.id.."] added ["..user_id.."]: added user kicked (#RTL char in name)")
					kick_user(user_id, msg.to.id)
				end
				if msg.to.type == 'channel' and lock_member == 'yes' then
					savelog(msg.to.id, name_log.." User ["..msg.from.id.."] added ["..user_id.."]: added user kicked  (#lockmember)")
					kick_user(user_id, msg.to.id)
					delete_msg(msg.id, ok_cb, false)
				end
			end
		end]]
	end
end
-- End 'RondoMsgChecks' text checks by @Rondoozle
	return msg
end
--End pre_process function
return {
	patterns = {},
	pre_process = pre_process
}
--End msg_checks.lua
--By @Rondoozle
