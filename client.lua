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
		Citizen.Wait(Config.threadDelay)
		if Config.disallowSpectating and NetworkIsInSpectatorMode() then
			TriggerServerEvent('nsac:trigger', 'nsac_1 - spectate')
		end

		if GetEntityHealth(GetPlayerPed(-1)) > Config.maxHealth then
			TriggerServerEvent('nsac:trigger', 'nsac_2 - health')
		end

		if Config.damageMultiplierCheck and GetPlayerWeaponDamageModifier(PlayerId()) > 1.0 then
			TriggerServerEvent('nsac:trigger', 'nsac_3 - damage multiplier ('..GetPlayerWeaponDamageModifier(PlayerId())..')')
		end

		if Config.invincibilityCheck and not IsEntityVisible(GetPlayerPed(-1)) then
			TriggerServerEvent('nsac:trigger', 'nsac_4 - invincibility')
		end

		if Config.thermalVisionCheck and GetUsingseethrough() then
			TriggerServerEvent('nsac:trigger', 'nsac_5 - thermal vision')
		end

		if Config.nightVisionCheck and GetUsingnightvision() then
			TriggerServerEvent('nsac:trigger', 'nsac_6 - night vision')
		end

		if Config.blacklistCommands then
			for _, registeredCommands in ipairs(GetRegisteredCommands()) do
				for _, blacklistedCmds in ipairs(Config.blacklistedCommands) do
					if registeredCommands.name == blacklistedCmds then
						TriggerServerEvent('nsac:trigger', 'nsac_7 - command registration')
					end
				end
			end
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
		local allowedResources = Config.allowedResources
		for i=1, #allowedResources do
			if resourceName == allowedResources[i] then
				print('onClientResourceStart: '..allowedResources[i]..' has been skipped')
				return
			end
		end
		local length = string.len(resourceName)
		--[[local firstLetter = string.sub(resourceName, 1, 1)]]
		if length >= Config.onResourceStartLength then
			TriggerServerEvent('nsac:trigger', 'nsac_90 - new resource ('..resourceName..')')
		end
	end)
end

if Config.onResourceStopCheck then
	AddEventHandler('onResourceStop', function(resourceName)
		if resourceName == GetCurrentResourceName() then
			TriggerServerEvent('nsac:trigger', 'nsac_98 - stopping me >:(')
		end
	end)
end

if Config.currentFramework ~= 'ESX' then
	RegisterNetEvent('esx:getSharedObject')
	AddEventHandler('esx:getSharedObject', function(cb)
		TriggerServerEvent('nsac:trigger', 'nsac_99 - esx grab')
	end)
end