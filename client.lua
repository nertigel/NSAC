--[[
	Nertigel's Simple Anti-Cheat
]]

local oldPrint = print
print = function(trash)
	oldPrint('[NSAC] '..trash)
end

--[[
	NSAC Main Loop
]]
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		if Config.disallowSpectating and NetworkIsInSpectatorMode() then
			TriggerServerEvent('nsac:trigger', 'nsac_1 - spectate')
		end

		if GetEntityHealth(GetPlayerPed(-1)) > Config.maxHealth then
			TriggerServerEvent('nsac:trigger', 'nsac_2 - health')
		end

		local weaponDamageModifier = GetPlayerWeaponDamageModifier(PlayerId())
		if weaponDamageModifier > 1.0 then
			TriggerServerEvent('nsac:trigger', 'nsac_3 - damage multiplier ('..weaponDamageModifier..')')
		end

		if Config.invincibilityCheck and not IsEntityVisible(GetPlayerPed(-1)) then
			TriggerServerEvent('nsac:trigger', 'nsac_4 - invincibility')
		end
	end
end)

--[[
	NSAC Secondary Loop(against modifiers)
]]
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		SetPedInfiniteAmmoClip(PlayerPedId(), false)
		SetPlayerInvincible(PlayerId(), false)
		SetEntityInvincible(PlayerPedId(), false)
		SetEntityCanBeDamaged(PlayerPedId(), true)
		ResetEntityAlpha(PlayerPedId())
	end
end)

if Config.currentFramework == 'NONE' then
	
elseif Config.currentFramework == 'ESX' then
	
elseif Config.currentFramework == 'VRP' then

end

--[[
	Detection against executors that create resources with a name that contains 16 or more
	Credits: https://github.com/Mememan55
]]
AddEventHandler('onClientResourceStart', function(resourceName)
    local length = string.len(resourceName)
    local firstLetter = string.sub(resourceName, 1,1)
    if length >= 16 then
		TriggerServerEvent('nsac:trigger', 'nsac_42 - new resource')
    end
end)