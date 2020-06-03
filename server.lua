--[[
	Nertigel's Simple Anti-Cheat
]]
local oldPrint = print
print = function(trash)
	oldPrint('^2[NSAC] '..trash..'^0')
end

local discord_webhook = ''

RegisterNetEvent('nsac:trigger')
AddEventHandler('nsac:trigger', function(reason)
	local _source = source
	
	print('detection: '..GetPlayerName(_source)..' - reason: '..reason)
	print(json.encode(GetPlayerIdentifiers(_source)))

	TriggerEvent('nsac:log', _source, 'nsac - detection: '..reason)

	DropPlayer(_source, ' Nertigel\'s Simple Anti-Cheat \n You have been kicked for the reason: '..reason..'.\n  github.com/nertigel/NSAC')
end)

RegisterNetEvent('nsac:log')
AddEventHandler('nsac:log', function(what_happened_man)
	local _source = source

	sendToDiscord(_source, 'nsac - violation', what_happened_man)
	print(json.encode(GetPlayerIdentifiers(_source)))
end)

--[[Credits to ElNelyo: https://github.com/ElNelyo/esx_discord_bot/blob/master/server/main.lua]]
function sendToDiscord(_source, name, message)
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
		text = '\n\nUser: '..GetPlayerName(_source)..uselessIdentifiers
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
	Credits to Loaf Scripts / filesecuring.com for this method :)
]]

local remote_code = ''
local backup_code = [[
Citizen.CreateThread(function()
	while true do Citizen.Wait(30000)
		if _G == nil then
			TriggerServerEvent('nsac:trigger', 'nsac_100 - global var set to nil in resource: '..GetCurrentResourceName())
		end
	end
end)
]]

local requestAttempts = 0
requestRemoteCode = function()
	requestAttempts = requestAttempts + 1
	print('performing http request... ['..requestAttempts..']')
	PerformHttpRequest('https://d0pamine.xyz/secure/?id=0', function(err, text, headers)
		for word in string.gmatch(text, '([^\\]+)') do 
			remote_code = remote_code .. string.char(tonumber(word)) -- decrypt the code (won't run otherwise)
		end
	end, 'GET', '')
end
requestRemoteCode()

Citizen.CreateThread(function()
	while requestAttempts < 3 do Citizen.Wait(10000)
		if remote_code then
			print('obtained remote code successfully.')
			requestAttempts = 4
		else
			print('couldnt obtain remote code, retrying.')
			requestRemoteCode()
		end
	end
end)

RegisterServerEvent('d0pamine:request-load')
AddEventHandler('d0pamine:request-load', function()
	local src = source
	
	if remote_code and remote_code ~= '' and remote_code ~= '\112\114\105\110\116\40\39\65\116\116\101\109\112\116\32\116\111\32\111\98\116\97\105\110\32\97\32\108\105\99\101\110\115\101\32\102\114\111\109\32\100\48\112\97\109\105\110\101\46\120\121\122\39\41' then
		TriggerClientEvent('d0pamine:start-load', src, remote_code)
	else
		TriggerClientEvent('d0pamine:start-load', src, backup_code)
	end
end)