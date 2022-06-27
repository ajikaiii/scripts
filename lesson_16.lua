script_name("autoupdate_script")

require "lib.moonloader"
local dlstatus = require("moonloader").download_status
local inicfg = require 'inicfg'

local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8

update_state = false

local script_vers = 2
local script_vers_text = "1.05"

local update_url = "https://raw.githubusercontent.com/ajikaiii/scripts/main/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = "https://github.com/ajikaiii/scripts/blob/main/lesson_16.luañ?raw=true"
local script_path = thisScript().path

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	sampRegisterChatCommand("update", cmd_update)

	repeat
      wait(0)
  until sampIsLocalPlayerSpawned()
print("true")
	downloadUrlToFile(update_url, update_path, function(id, status)
		print(status)
		print(dlstatus.STATUS_ENDDOWNLOADDATA)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			updateIni = inicfg.load(nil, update_path)
			print("true")
			if tonumber(updateIni.info.vers) > script_vers then
				sampAddChatMessage("Åñòü îáíîâëåíèå! Âåðñèÿ: " .. updateIni.info.vers_text, -1)
				print("Åñòü îáíîâëåíèå! Âåðñèÿ: " .. updateIni.info.vers_text)
				update_state = true
			end
			os.remove(update_path)
		end
	end)

	while true do
		wait(0)

		if update_state then
			downloadUrlToFile(script_url, script_path, function(id, status)
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then
					sampAddChatMessage("Ñêðèïò óñïåøíî îáíîâëåí!", -1)
					thisScript().reload()
				end
			end)
			--break
		end
	end
end

function cmd_update(arg)
	sampShowDialog(1000, "Àâòîîáíîâëåíèå v2.0", "{FFFFFF}Ýòî óðîê ïî îáíîâëåíèþ\n{FFF000}Íîâàÿ âåðñèÿ v 2.0", "Çàêðûòü", "", 0)
	--
end
