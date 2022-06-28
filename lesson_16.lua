script_name("autoupdate_script")

require "lib.moonloader"
local dlstatus = require("moonloader").download_status
local inicfg = require 'inicfg'

local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8

local encoding = require 'encoding'

encoding.default = 'CP1251'
local u8 = encoding.UTF8
local function recode(u8) return encoding.UTF8:decode(u8) end

update_state = false

local script_vers = 1
local script_vers_text = "1.00"

local update_url = "https://raw.githubusercontent.com/ajikaiii/scripts/main/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = "https://github.com/ajikaiii/scripts/blob/main/lesson_16.luac?raw=true"
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
				sampAddChatMessage(u8"���� ����������! ������: " .. updateIni.info.vers_text, -1)
				print(u8"���� ����������! ������: " .. updateIni.info.vers_text)
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
						sampAddChatMessage(u8"������ ������� ��������!", -1)
						--wait(200)
						--thisScript().reload()
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
	sampShowDialog(1000, u8"�������������� v2.0", u8"{FFFFFF}��� ���� �� ����������\n{FFF000}����� ������", u8"�������", "", 0)
end
