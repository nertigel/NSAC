--[[
	Nertigel's Simple Anti-Cheat
]]
local discord_webhook = ''

RegisterNetEvent('nsac:trigger')
AddEventHandler('nsac:trigger', function(reason)
	local source = source
	
	DropPlayer(source, ' Nertigel\'s Simple Anti-Cheat \n You have been kicked for the reason: '..reason..'.\n  github.com/nertigel/NSAC')
	print('nsac - detection: '..GetPlayerName(source)..' reason: '..reason)
	print(json.encode(GetPlayerIdentifiers(source)))

	TriggerEvent('nsac:log', 'nsac - detection: '..reason)
end)

RegisterNetEvent('nsac:log')
AddEventHandler('nsac:log', function(what_happened_man)
	local source = source

	sendToDiscord(source, 'nsac - violation', what_happened_man)
	print(json.encode(GetPlayerIdentifiers(source)))
end)

--[[Credits to ElNelyo: https://github.com/ElNelyo/esx_discord_bot/blob/master/server/main.lua]]
function sendToDiscord(_source, name, message)
	local source = _source
	if message == nil or message == '' then
		print('nsac - message not set, therefore it wasn\'t sent')
		return
	end
	if discord_webhook == nil and discord_webhook == '' then
		print('nsac - discord_webhook not set, therefore it wasn\'t sent')
		return
	end

	local uselessIdentifiers = ''
	local text = ''

	--[[FiveM Wiki is veri cool men]]
	if source then
		for k,v in pairs(GetPlayerIdentifiers(source)) do
			if string.sub(v, 1, string.len('steam:')) == 'steam:' then
				uselessIdentifiers = uselessIdentifiers..'\n'..v
			elseif string.sub(v, 1, string.len('license:')) == 'license:' then
				uselessIdentifiers = uselessIdentifiers..'\n'..v
			elseif string.sub(v, 1, string.len('xbl:')) == 'xbl:' then
				uselessIdentifiers = uselessIdentifiers..'\n'..v
			elseif string.sub(v, 1, string.len('ip:')) == 'ip:' then
				uselessIdentifiers = uselessIdentifiers..'\n'..v
			elseif string.sub(v, 1, string.len('discord:')) == 'discord:' then
				uselessIdentifiers = uselessIdentifiers..'\n'..v
			elseif string.sub(v, 1, string.len('live:')) == 'live:' then
				uselessIdentifiers = uselessIdentifiers..'\n'..v
			end
		end
	end
	
	if source then
		text = '\n\nUser: '..GetPlayerName(source)..uselessIdentifiers
	else
		text = ''
	end

	local embeds = { {
		['title'] = 'NSAC',
		['type'] = 'rich',
		['description'] = message..text,
		['color'] = 16711680, --[[Red]]
		['footer'] = {
			['text'] = 'Nertigel\'s Simple Anti-Cheat',
		}, }
	}

	PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

sendToDiscord(false, 'Nertigel\'s Simple Anti-Cheat', 'Resource has been started')