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

local script_url = "https://github.com/ajikaiii/scripts/blob/main/lesson_16.lua?raw=true"
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
				sampAddChatMessage("Есть обновление! Версия: " .. updateIni.info.vers_text, -1)
				print("Есть обновление! Версия: " .. updateIni.info.vers_text)
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
					sampAddChatMessage("Скрипт успешно обновлен!", -1)
					--thisScript().reload()
					update_state = false
					--break
				end
			end)
			--break
		end
	end
end

function cmd_update(arg)
	sampShowDialog(1000, "Автообновление v2.0", "{FFFFFF}Это урок по обновлению\n{FFF000}Новая версия v 2.0", "Закрыть", "", 0)
end
