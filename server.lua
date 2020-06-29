--[[
	Nertigel's Simple Anti-Cheat
]]
local oldPrint = print
print = function(trash)
	oldPrint('^2[NSAC] '..trash..'^0')
end

--[[
	Add your discord webhook here
]]
local discord_webhook = 'https://discordapp.com/api/webhooks/xxx/xxx'

RegisterNetEvent('nsac:trigger')
AddEventHandler('nsac:trigger', function(reason)
	local _source = source
	local identifiers = GetPlayerIdentifiers(_source)
	if reason == nil or reason == '' then reason = 'no reason' end
	
	banUser(_source)
	DropPlayer(_source, ' Nertigel\'s Simple Anti-Cheat \n You have been kicked for the reason: '..reason..'.\n  github.com/nertigel/NSAC')

	if #identifiers >= 1 then --[[Anti-spam(if triggered in a loop then it will spam server console & logs)]]
		print('detection: '.._source..' - reason: '..reason)
		print('identifiers: '..json.encode(identifiers))

		TriggerEvent('nsac:log', 'nsac - detection: '..reason)
	end
end)

RegisterNetEvent('nsac:log')
AddEventHandler('nsac:log', function(reason)
	local _source = source

	if reason == nil or reason == '' then reason = 'no reason' end

	sendToDiscord(_source, 'nsac - violation', reason)
	print(json.encode(GetPlayerIdentifiers(_source)))
end)

--[[Credits to ElNelyo: https://github.com/ElNelyo/esx_discord_bot/blob/master/server/main.lua]]
sendToDiscord = function(_source, name, message)
	if message == nil or message == '' then
		print('message not set, therefore it wasn\'t sent')
		return
	end
	if discord_webhook == nil and discord_webhook == '' then
		print('discord_webhook not set, therefore it wasn\'t sent')
		return
	end

	local uselessIdentifiers = ''
	local text = ''

	--[[FiveM Wiki is veri cool men]]
	if _source then
		for k,v in pairs(GetPlayerIdentifiers(_source)) do
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
	
	if _source then
		text = uselessIdentifiers
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

--[[
	Ban list credits to nekler/de_way / Good old AlphaVeta
]]

local bansList = ''

AddEventHandler('onServerResourceStart', function(resource_name)
	if resource_name == GetCurrentResourceName() then
		local path = GetResourcePath(resource_name)
		local file = io.open(path..'/bans.txt', 'r')
		if file then
			file:seek('set', 0)
			bansList = file:read('*a')
			file:close()
		else
			print('Couldn\'t find bans.txt in: '..path..' | '..GetCurrentResourceName())
		end

		while true do
			file = io.open(path..'/bans.txt', 'w')
			if file then
				file:seek('set', 0)
				file:write(bansList)
				file:close()
			else
				print('Couldnt write in: '..path..'/bans.txt')
			end
			Wait(15000) --[[Save banlist every x amount]]
		end
	end
end)

AddEventHandler('playerConnecting', function(name, shouldDrop, deferrals)
	local num = GetNumPlayerIdentifiers(source)
	local _i = 0
	while _i < num-1 do
		local identifier = GetPlayerIdentifier(source, _i)
		if string.find(bansList, identifier) then 
			banUser(source)
			shouldDrop(' Nertigel\'s Simple Anti-Cheat \n You have been banned from this server for cheating.\n  github.com/nertigel/NSAC')
			CancelEvent()
		end
		_i = _i + 1
	end
end)

banUser = function(player)
	local num = GetNumPlayerIdentifiers(player)
	for _i = 0, num-1 do
		local identifier = GetPlayerIdentifier(player, _i)
		if not string.find(bansList, identifier) then
			bansList = bansList..identifier..'\n'
		end
	end
end