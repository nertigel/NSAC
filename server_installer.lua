--[[
	Nertigel's Simple Anti-Cheat
]]

local resources = nil
RegisterCommand("nsac", function(source, args, rawCommand)
	if source == 0 then
		if args[1] == "install" then
			if args[2] then
				if not resources then resources = {0, 0, 0} end
				if args[2] == "all" then
					local resourcenum = GetNumResources()
					for i = 0, resourcenum-1 do
						local path = GetResourcePath(GetResourceByFindIndex(i))
						if string.len(path) > 4 then
							setall(path)
						end
					end
					print("^4Done! ("..resources[1].."/"..resources[2].." successfully). "..resources[3].." skipped (not necessary).^7")
				else
					local setin = GetResourcePath(args[2])
					if setin then
						setall(setin)
						print("------------------------------------------------------------------")
						print("^4Done! ("..resources[1].."/"..resources[2].." successfully). "..resources[3].." skipped (not necessary).^7")
					else
						print("^1The resource "..args[2].." doesn't exist.^7")
					end
				end
				resources = nil
			end
		end
		if args[1] == "uninstall" then
			if not resources then resources = {0, 0, 0} end
			local resourcenum = GetNumResources()
			for i = 0, resourcenum-1 do
				local path = GetResourcePath(GetResourceByFindIndex(i))
				if string.len(path) > 4 then
					setall(path, true)
				end
			end
			print("^4Done! ("..resources[1].."/"..resources[2].." successfully). "..resources[3].." skipped (not necessary).^7")
			resources = nil
		end
	end
end)

function setall(dir, bool)
	local file = io.open(dir.."/"..Config.fsManifest, "r")
	local tab = split(dir, "/")
	local resname = tab[#tab]
	tab = nil
	if file then
		if not bool then
			file:seek("set", 0)
			local r = file:read("*a")
			file:close()
			local table1 = split(r, "\n")
			local found = false
			local found2 = false
			for a, b in ipairs(table1) do
				if b == "client_script \""..Config.fsName.."\"" then
					found = true
				end
				if not found2 then
					local fi = string.find(b, "client_script") or -1
					local fin = string.find(b, "#") or -1
					if fi ~= -1 and (fin == -1 or fi < fin) then
						found2 = true
					end
				end
			end
			if found2 then
				r = r.."\nclient_script \""..Config.fsName.."\""
				if not found then
					os.remove(dir.."/"..Config.fsManifest)
					file = io.open(dir.."/"..Config.fsManifest, "w")
					if file then
						file:seek("set", 0)
						file:write(r)
						file:close()
					end
				end
				local code = Config.fsCode
				file = io.open(dir.."/"..Config.fsName, "w")
				if file then
					file:seek("set", 0)
					file:write(code)
					file:close()
					resources[1] = resources[1]+1
					print("^2Finished guarding "..resname.." resource successfully.^7")
				else
					print("^1Failed guarding "..resname..".^7")
				end
				resources[2] = resources[2]+1
			else
				resources[3] = resources[3]+1
			end
		else
			file:seek("set", 0)
			local r = file:read("*a")
			file:close()
			local table1 = split(r, "\n")
			r = ""
			local found = false
			local found2 = false
			for a, b in ipairs(table1) do
				if b == "client_script \""..Config.fsName.."\"" then
					found = true
				else
					r = r..b.."\n"
				end
			end
			if os.rename(dir.."/"..Config.fsName, dir.."/"..Config.fsName) then
				found2 = true
				os.remove(dir.."/"..Config.fsName)
			end
			if not found and not found2 then resources[3] = resources[3]+1 end
			if found then
				resources[2] = resources[2]+1
				os.remove(dir.."/"..Config.fsManifest)
				file = io.open(dir.."/"..Config.fsManifest, "w")
				if file then
					file:seek("set", 0)
					file:write(r)
					file:close()
				else
					print("^2Failed uninstalling anticheat from "..resname.." successfully.^7")
					found, found2 = false, false
				end
			end
			if found or found2 then
				print("^2Finished uninstalling anticheat from "..resname.." successfully.^7")
				resources[1] = resources[1]+1
			end
		end
	else
		resources[3] = resources[3]+1
	end
end

function searchall(dir, bool)
	local file = io.popen("dir \""..dir.."\" /b /ad")
	file:seek("set", 0)
	local r1 = file:read("*a")
	file:close()
	local table1 = split(r1, "\n")
	for a, b in ipairs(table1) do
		if string.len(b) > 0 then
			setall(dir.."/"..b, bool)
			searchall(dir.."/"..b, bool)
		end
	end
end

function split(str, seperator)
	local pos, arr = 0, {}
	for st, sp in function() return string.find(str, seperator, pos, true) end do
		table.insert(arr, string.sub(str, pos, st-1))
		pos = sp + 1
	end
	table.insert(arr, string.sub(str, pos))
	return arr
end