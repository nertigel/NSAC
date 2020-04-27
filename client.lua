--[[
	Nertigel's Simple Anti-Cheat
]]

local oldPrint = print
print = function(trash)
	oldPrint('[NSAC] '..trash)
end

--[[Anti Modifiers]]
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		if NetworkIsInSpectatorMode() then
			print('spectator mode manipulation')
		end

		if GetEntityHealth(GetPlayerPed(-1)) > 200 then
			print('health is above maximum')
		end

		local weaponDamageModifier = GetPlayerWeaponDamageModifier(PlayerId())
		
		if weaponDamageModifier > 1.0 then
			print('PlayerWeaponDamageModifier == '..weaponDamageModifier)
		end
	end
end)

--[[
	Detection against BasedFX and against executors that create resources
	Credits: https://github.com/Mememan55
]]
AddEventHandler('onClientResourceStart', function(resourceName)
    local length = string.len(resourceName)
    local firstLetter = string.sub(resourceName, 1,1)
    if length >= 15 then
		print('onClientResourceStart triggered | Resource:'..resourceName)
    end
end)