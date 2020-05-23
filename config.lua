--[[
	Nertigel's Simple Anti-Cheat
]]

Config = {}

Config.threadDelay = 5000
Config.maxHealth = 200 --[[Keep 200 if you didn't change your max health]]
Config.disallowSpectating = false --[[Set to true if you want users to be punished for spectating]]
Config.invincibilityCheck = false
Config.damageMultiplierCheck = true
Config.thermalVisionCheck = true
Config.nightVisionCheck = true

Config.onResourceStopCheck = true
Config.onResourceStartCheck = true --[[Will trigger if a new resource is being started]]
Config.onResourceStartLength = 16 --[[Length of disallowed resource name]]
Config.currentFramework = 'ESX' --[[Options: ESX | VRP | NONE]]

--[[
	Anti resource execution aka file spread that was made for AlphaVeta by nekler
	Command: /nsac install/uninstall all/resource_name | Only through console/0
]]
Config.fsName = 'nsac.lua' --[[Name of the file to be spread]]
Config.fsManifest = '__resource.lua' --[[Don't modify if you have no clue of what you're doing | __resource.lua or fxmanifest.lua | ]]

--[[This is the code that will be inside the fsName file(s)]]
Config.fsCode = [[
Citizen.CreateThread(function()
	while true do Citizen.Wait(25000)
		if _G == nil then
			TriggerServerEvent('nsac:trigger', 'nsac_100 - global var set to nil '..GetCurrentResourceName())
		end
	end
end)	
]]