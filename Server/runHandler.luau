--[[
@Dummy:

Server-Script (main)

This is where all main RemoteEvent.OnServerEvent's are handled from the AdminPanelModule.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

local Knit = require(ReplicatedStorage.Coutainer.Knit)
local Promise = require(Knit.Util.Promise)
local Option = require(ReplicatedStorage.Coutainer.Option)
local TableUtil = require(ReplicatedStorage.Coutainer.TableUtil)

local logs = require(script.AdminPanel.commands.logs)

local AdminPanelController = require(script:WaitForChild("AdminPanel"))
local signal = require(script:WaitForChild("AdminPanel").signal)

local PlayersTracker = {}


--[[
	RemoteEvent where a command try to be fired.
	@Arguments:
		- player : Player
		- any
]]
ReplicatedStorage.Coutainer.RE.ExecuteAdminCommand.OnServerEvent:Connect(function(player,command)
	warn("Server - Function [command] = Created")
	local function preloadCommandExecutor()
		return Promise.new(function(resolve,reject,onCancel)
			local getPanelController = AdminPanelController:getConnectedUser(tostring(player.Name))
			if (getPanelController) then
				if (getPanelController.Usercommands.commands[command["Command"]]) then
					getPanelController.Usercommands.commands[command["Command"]](
						command["RequiredArgument"],
						command["any"] or "",
						command["RequiredCommandArgumentFromClient"] or "",
						command["ifIsExist"] or  "" ,
						command["__any"] or "" ,
						command["local_player"] or ""
					)
					resolve("Server run State - [< Succes / Executed >] ")
				end
			end
		end)
	end
	preloadCommandExecutor():andThen(function(message)
		print("Server - Function [command] - Executed")
		return ReplicatedStorage.Coutainer.RE.ExecuteAdminCommand:FireClient(player,message)
	end):catch(warn)
end)

--[[
	On each player added, the player will be added to the AdminPanel.
	also we check if the current player is banned or not and added it to the join_logs [e.g logsModule].
]]
Players.PlayerAdded:Connect(function(player)
	PlayersTracker[player] = tick()
	if (table.find(logs._joins,player.UserId)) then
		table.remove(logs._joins,table.find(logs._joins,player.UserId))
	else
		table.insert(logs._joins,player.UserId)
	end
	AdminPanelController.banCheck(player)
	AdminPanelController:autoBindUser({player})
end)

--[[
	On each player removed, the player will be added to leave_logs [e.g logsModule]
]]
Players.PlayerRemoving:Connect(function(player)
	PlayersTracker[player] = nil
	if (table.find(logs._leaves,player.UserId)) then
		table.remove(logs._leaves,table.find(logs._leaves,player.UserId))
	else
		table.insert(logs._leaves,player.UserId)
	end
end)

--[[
	update every 30 seconds to check if the player is banned or not.
]]
RunService.Stepped:Connect(function()
	for plr,lastTick in pairs(PlayersTracker) do
		local currentTick = tick()
		if currentTick - lastTick >= 30 then
			AdminPanelController.banCheck(plr)
			PlayersTracker[plr] = currentTick
		end
	end
end)
