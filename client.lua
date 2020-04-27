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
		if Config.damageMultiplierCheck and weaponDamageModifier > 1.0 then
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

--[[
	Detection against executors that create resources with a name that contains Config.onResourceStartLength's amount or more
	Credits: https://github.com/Mememan55
]]
if Config.onResourceStartCheck then
	AddEventHandler('onClientResourceStart', function(resourceName)
		local allowedResources = {
			'fivem-map-hipster',
			'fivem-map-skater',
			'essentialmode'
		}
		for i=1, #allowedResources do
			if resourceName == allowedResources[i] then
				print('onClientResourceStart: '..allowedResources[i]..' has been skipped')
				return
			end
		end
		local length = string.len(resourceName)
		local firstLetter = string.sub(resourceName, 1,1)
		if length >= Config.onResourceStartLength then
			TriggerServerEvent('nsac:trigger', 'nsac_90 - new resource ('..resourceName..')')
		end
	end)
end

AddEventHandler('onClientResourceStop', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		TriggerServerEvent('nsac:trigger', 'nsac_98 - stopping me >:(')
	end
end)

if Config.currentFramework ~= 'ESX' then
	RegisterNetEvent('esx:getSharedObject')
	AddEventHandler('esx:getSharedObject', function(cb)
		TriggerServerEvent('nsac:trigger', 'nsac_99 - esx grab')
	end)
end