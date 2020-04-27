--[[
	Nertigel's Simple Anti-Cheat
]]

Config = {}

Config.maxHealth = 200 --[[Keep 200 if you didn't change your max health]]
Config.disallowSpectating = false --[[Set to true if you want users to be punished for spectating]]
Config.invincibilityCheck = true
Config.damageMultiplierCheck = true

Config.onResourceStartCheck = true --[[Will trigger if a new resource is being started]]
Config.onResourceStartLength = 16 --[[Length of disallowed resource name]]
Config.currentFramework = 'NONE' --[[Options: ESX | VRP | NONE]]