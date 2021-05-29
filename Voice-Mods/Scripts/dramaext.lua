_G.GGWEPVOICEMODS = _G.GGWEPVOICEMODS or {}
GGWEPVOICEMODS.ModPath = GGWEPVOICEMODS.ModPath or ModPath
GGWEPVOICEMODS.SOUNDS = GGWEPVOICEMODS.SOUNDS or {}
GGWEPVOICEMODS.VERSION = 3

local __mod_ids = Idstring("Voice Mods"):key()
local old1 = "O_"..Idstring("old1::"..__mod_ids):key()

function GGWEPVOICEMODS:__log(__log)
	log("[GGWEPVOICEMODS]:\t"..tostring(__log))
end

function GGWEPVOICEMODS:__key(__t)
	return Idstring(tostring(GGWEPVOICEMODS.ModPath).." "..tostring(__t)):key()
end

function GGWEPVOICEMODS:__find(__lv1, __lv2, __lv3, __lv4)
	local __lvx1, __lvx2, __lvx3, __lvx4 = self:__key(__lv1), self:__key(__lv2), self:__key(__lv3), self:__key(__lv4)
	if __lv4 and __lv3 and __lv2 and __lv1 then
		if not self.SOUNDS[__lvx1] then return nil end
		if not self.SOUNDS[__lvx1][__lvx2] then return nil end
		if not self.SOUNDS[__lvx1][__lvx2][__lvx3] then return nil end
		if not self.SOUNDS[__lvx1][__lvx2][__lvx3][__lvx4] then return nil end
		return self.SOUNDS[__lvx1][__lvx2][__lvx3][__lvx4]
	end
	if __lv3 and __lv2 and __lv1 then
		if not self.SOUNDS[__lvx1] then return nil end
		if not self.SOUNDS[__lvx1][__lvx2] then return nil end
		if not self.SOUNDS[__lvx1][__lvx2][__lvx3] then return nil end
		return self.SOUNDS[__lvx1][__lvx2][__lvx3]
	end
	if __lv2 and __lv1 then
		if not self.SOUNDS[__lvx1] then return nil end
		if not self.SOUNDS[__lvx1][__lvx2] then return nil end
		return self.SOUNDS[__lvx1][__lvx2]
	end
	if __lv1 then
		if not self.SOUNDS[__lvx1] then return nil end
		return self.SOUNDS[__lvx1]
	end
	return nil
end

function GGWEPVOICEMODS:__replace(them, __sound, __from)
	function __check_before_apply(__i, __j)
		if type(__j) == "string" then
			return __j
		else
			return __i
		end
	end
	local __lv1 = tostring(__from)
	local __lv2 = tostring(__sound)
	local __lv3 = nil
	local __lv4 = nil
	if tostring(__from) == "PlayerSound" then
		local __possible = nil
		__possible = self:__find(__lv1, __lv2)
		if type(__possible) == "table" then
			return __check_before_apply(__sound, __possible[table.random_key(__possible)])
		end
		if managers.criminals and them._unit then
			__lv2 = managers.criminals:character_name_by_unit(them._unit)
			__lv3 = __sound
			__possible = self:__find(__lv1, __lv2, __lv3)
			--[[
			self:__log("__replace, __lv, "..json.encode({__lv1, __lv2, __lv3}))
			self:__log("__replace, __lxv, "..json.encode({self:__key(__lv1), self:__key(__lv2), self:__key(__lv3)}))
			self:__log("__replace, SOUNDS, "..json.encode(self.SOUNDS))
			self:__log("__replace, __possible, "..json.encode(__possible))
			]]
			if type(__possible) == "table" then
				local __pick 
				return __check_before_apply(__sound, __possible[table.random_key(__possible)])
			end
		end
	end
	return __sound
end

function GGWEPVOICEMODS:__init_tree(__t, __lv1, __lv2, __lv3, __lv4)
	if __lv1 then
		__t[__lv1] = __t[__lv1] or {}
	end
	if __lv2 then
		__t[__lv1][__lv2] = __t[__lv1][__lv2] or {}
	end
	if __lv3 then
		__t[__lv1][__lv2][__lv3] = __t[__lv1][__lv2][__lv3] or {}
	end
	if __lv4 then
		__t[__lv1][__lv2][__lv3][__lv4] = __t[__lv1][__lv2][__lv3][__lv4] or {}
	end
	return __t
end

function GGWEPVOICEMODS:__read()
	function __mysplit(inputstr, sep)
		if sep == nil then
			sep = "%s"
		end
		local t={} ; i=1
		for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			t[i] = str
			i = i + 1
		end
		return t
	end
	function __key(__t)
		return GGWEPVOICEMODS:__key(__t)
	end
	function __init_tree(__t, __lv1, __lv2, __lv3, __lv4)
		return GGWEPVOICEMODS:__init_tree(__t, __lv1, __lv2, __lv3, __lv4)
	end
	local base_path = self.ModPath.."/Assets/"
	if file.DirectoryExists(base_path) then
		local __xml = io.open(self.ModPath.."/main.xml", "w+")
		if __xml then
			__xml:write('<mod name="Voice Mods">\n')
			__xml:write('	<AssetUpdates id="Voice Mods" version="'..GGWEPVOICEMODS.VERSION..'">\n')
			__xml:write('		<custom_provider \n')
			__xml:write('			version_api_url="https://drnewbie.github.io/Voice-Mods/Version.txt" \n')
			__xml:write('			download_url="https://drnewbie.github.io/Voice-Mods/Voice-Mods.zip"/>\n')
			__xml:write('	</AssetUpdates>\n')
			__xml:write('	<Hooks directory="Scripts">\n')
			__xml:write('		<hook source_file="lib/units/dramaext" file="dramaext.lua"/>\n')
			__xml:write('		<hook source_file="lib/managers/menumanagerpd2" file="dramaext.lua"/>\n')
			__xml:write('	</Hooks>\n')
			__xml:write('	<Sounds directory="Assets">\n')
			local pd2_path = Application:base_path()
			local voice_mods_full_path = Application:nice_path(pd2_path..base_path, false)
			local __cmd = 'dir "'..voice_mods_full_path..'" /s /b /o:gn'
			for __dir in io.popen(__cmd):lines() do
				if io.file_is_readable(__dir) then
					__dir = string.sub(__dir, string.len(voice_mods_full_path)+2)
					local __dir_table = __mysplit(__dir, '\\') or {}
					if __dir_table[#__dir_table]:find(".ogg") then
						local __oggs = __mysplit(__dir_table[#__dir_table], '.') or {}
						local __ogg = __oggs[#__oggs]
						local __dir_table_size = table.size(__dir_table)
						local ogg_path = table.concat(__dir_table, "\\")
						local ogg_path_key = 'ogg_'..__key(ogg_path)
						__xml:write('		<sound id="'..ogg_path_key..'" path="'..ogg_path..'" prefix="first"/>\n')
					
						self.SOUNDS = __init_tree(self.SOUNDS, __key(__dir_table[1]), __key(__dir_table[2]), __key(__dir_table[3]), __key(__dir_table[4]))
						if __dir_table_size == 1 then
							self.SOUNDS[__key(__dir_table[1])] = ogg_path_key
						elseif __dir_table_size == 2 then
							self.SOUNDS[__key(__dir_table[1])][__key(__dir_table[2])] = ogg_path_key
						elseif __dir_table_size == 3 then
							self.SOUNDS[__key(__dir_table[1])][__key(__dir_table[2])][__key(__dir_table[3])] = ogg_path_key
						elseif __dir_table_size == 4 then
							self.SOUNDS[__key(__dir_table[1])][__key(__dir_table[2])][__key(__dir_table[3])][__key(__dir_table[4])] = ogg_path_key
						end
					end
				end
			end
			__xml:write('	</Sounds>\n')
			__xml:write('</mod>\n')
			__xml:close()
		end
	end
	--[[
	self:__log("__read, SOUNDS, "..json.encode(self.SOUNDS))
	]]
end

GGWEPVOICEMODS:__read()

if PlayerSound then
	PlayerSound[old1] = PlayerSound[old1] or PlayerSound._play
	function PlayerSound:_play(__sound, __sauce, ...)
		local __sound = GGWEPVOICEMODS:__replace(self, __sound, "PlayerSound")
		return self[old1](self, __sound, nil, ...)
	end
end

if CopSound then
	CopSound[old1] = CopSound[old1] or CopSound._play
	function CopSound:_play(__sound, __sauce, ...)
		local __sound = GGWEPVOICEMODS:__replace(self, __sound, "CopSound")
		return self[old1](self, __sound, nil, ...)
	end
end

if CivilianHeisterSound then
	CivilianHeisterSound[old1] = CivilianHeisterSound[old1] or CivilianHeisterSound._play
	function CivilianHeisterSound:_play(__sound, __sauce, ...)
		local __sound = GGWEPVOICEMODS:__replace(self, __sound, "CivilianHeisterSound")
		return self[old1](self, __sound, nil, ...)
	end
end

if DramaExt then
	DramaExt[old1] = DramaExt[old1] or DramaExt.play_sound
	function DramaExt:play_sound(__sound, __sauce, ...)
		local __sound = GGWEPVOICEMODS:__replace(self, __sound, "DramaExt")
		return self[old1](self, __sound, __sauce, ...)
	end
end