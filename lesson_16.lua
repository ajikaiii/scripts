script_name("autoupdate_script")

require "lib.moonloader"
local dlstatus = require("moonloader").download_status
local inicfg = require 'inicfg'

local encoding = require 'encoding'

encoding.default = 'UTF-8'
local u8 = encoding.CP1251


update_state = false

local script_vers = 2
local script_vers_text = "2.00"

local update_url = "https://raw.githubusercontent.com/ajikaiii/scripts/main/update.ini"
--local update_url = "https://www.dropbox.com/s/sumzb4t7ijwuzyz/update.json?dl=1"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = "https://github.com/ajikaiii/scripts/blob/main/lesson_16.lua?raw=true"
--local script_url = "https://www.dropbox.com/s/g9heqv3gyxxbkw1/lesson_16.lua?dl=1"
local script_path = thisScript().path

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	sampRegisterChatCommand("update", cmd_update)

	repeat
      wait(0)
  until sampIsLocalPlayerSpawned()
print("true")
	downloadUrlToFile(update_url, update_path, function(id, status, p1, p2)
		print(status)
		print(dlstatus.STATUS_ENDDOWNLOADDATA)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			updateIni = inicfg.load(nil, update_path)
			print("true")
			if tonumber(updateIni.info.vers) > script_vers then
				sampAddChatMessage(u8"Есть обновление! Версия: " .. updateIni.info.vers_text, -1)
				print(u8"Есть обновление! Версия: " .. updateIni.info.vers_text)
				update_state = true
			end
			os.remove(update_path)
		end
	end)

	while true do
		wait(0)

		if update_state then
			print("da zaxod")
			downloadUrlToFile(script_url, script_path, function(id, status)
				print("eeee")
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then
					lua_thread.create(function()
						sampAddChatMessage(u8"Скрипт успешно обновлен!", -1)
						wait(200)
						thisScript().reload()
						update_state = false
						--break
					end)
				end
			end)
			--[[
			if update_state == false then
				wait(200)
				thisScript().reload()
				break
			end
			]]
		end
	end
end

function cmd_update(arg)
	sampShowDialog(1000, u8"Автообновление v2.0", u8"{FFFFFF}Это урок по обновлению\n{FFF000}Новая версия v 2.0", u8"Закрыть", "", 0)
end
