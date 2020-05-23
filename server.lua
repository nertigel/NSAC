--[[
	Nertigel's Simple Anti-Cheat
]]

RegisterNetEvent('nsac:trigger')
AddEventHandler('nsac:trigger', function(reason)
	DropPlayer(source, ' Nertigel\'s Simple Anti-Cheat \n You have been kicked for the reason: '..reason..'. \n github.com/nertigel/NSAC')
	print('NSAC Detection User: '..source..' Reason:'..reason)
end)