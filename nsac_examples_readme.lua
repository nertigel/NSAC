--[[
	I would recommend obfuscating your nsac.lua file using https://github.com/efrederickson/XFuscator

	lua XFuscator.lua file_name.lua -noloadstring -nostep2
]]

--[[
	Example 1:
	You can add as many variables as you would like(usually paid anti-cheats have over 25 variables in here).
]]

Plane = {}
WarMenu = 'ayy'
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		if WarMenu ~= 'ayy' then
			TriggerServerEvent('nsac:trigger', 'nsac_100 - menu detection in resource: '..GetCurrentResourceName())
		end
		if Plane.CreateMenu ~= nil then
			TriggerServerEvent('nsac:trigger', 'nsac_100 - menu detection in resource: '..GetCurrentResourceName())
		end
	end
end)

--[[
	Example 2:
	_G functions existence check, recommended to be used with _G = nil check.
]]

local functionsToCheck = {
	"TesticleFunction",
	"tcoke",
	"checkValidVehicleExtras",
	"vrpdestroy",
	"Oscillate",
	"forcetick",
	"ApplyShockwave",
	"GetCoordsInfrontOfEntityWithDistance",
	"TeleporterinoPlayer",
	"Clean2"
  }

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(20000)
		if checkGlobalVariable() then
			TriggerServerEvent('nsac:trigger', 'nsac_100 - menu detection in resource: '..GetCurrentResourceName())
		end
	end
end)

checkGlobalVariable = function()
	for _i in pairs(functionsToCheck) do
		if (_G[functionsToCheck[_i] ] ~= nil) then
			return true
		else
			return false
		end
	end
end

--[[
	Example 3:
	return type(func) anti-cheat, you can add more functions/tables ( {'variable_name', 'menu_name'} ).
]]

local menuFunctions = { 
	{'TriggerCustomEvent', 'Hoax'}, {'GetResources', 'SkidMenu'}, {'IsResourceInstalled', 'SkidMenu'}, {'ShootPlayer', 'Lynx'}, {'FirePlayer', 'Lynx'}, {'MaxOut', 'Lynx'}, {'Clean2', 'Lynx'}, 
}
local menuTables = {
	{'Dopamine', 'Dopamine'}, {'LuxUI', 'Lux'}, {'objs_tospawn', 'SkidMenu'}, {'lynxunknowncheats', 'Lynx'}, {'BrutanPremium', 'Lynx'}, {'oTable', 'Hoax'}, {'HoaxMenu', 'Hoax'},
}

Citizen.CreateThread(function()
	while true do Citizen.Wait(25000)
		for _, ayyLmao in pairs(menuFunctions) do
            local menuFunction = ayyLmao[1]
            local menuName = ayyLmao[2]
            local returnType = load('return type('..menuFunction..')')
			if returnType() == 'function' then
				TriggerServerEvent('nsac:trigger', 'nsac_100 - menu detection: '..GetCurrentResourceName()..' (N:'..menuName..' | F:'..menuFunction..')')
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do Citizen.Wait(30000)
		for _, ayyLmao in pairs(menuTables) do
            local menuTable = ayyLmao[1]
            local menuName = ayyLmao[2]
            local returnType = load('return type('..menuTable..')')
			if returnType() == 'table' then
				TriggerServerEvent('nsac:trigger', 'nsac_100 - menu detection: '..GetCurrentResourceName()..' (N:'..menuName..' | T:'..menuTable..')')
			end
		end
	end
end)
