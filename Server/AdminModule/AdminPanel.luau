local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")

local Knit = require(ReplicatedStorage.Coutainer.Knit)
local Promise = require(Knit.Util.Promise)
local Option = require(ReplicatedStorage.Coutainer.Option)
local TableUtil = require(ReplicatedStorage.Coutainer.TableUtil)
local logs = require(script.commands.logs)

local DataStoreService = game:GetService("DataStoreService")
local BAN_LIST_DataStoreService = DataStoreService:GetDataStore("Ban_list") -- change ur dataStoreName
local OrderedBanListData = DataStoreService:GetOrderedDataStore("OrderedBanList_command") -- change ur dataStoreName

local panel = {}
panel.client = {}

panel.banCheck = function(plr)
	if (plr) then
		local checkData = function()
			return  BAN_LIST_DataStoreService:GetAsync(plr.UserId) or nil
		end
		if (checkData()) ~= nil then
			if not (checkData().ban_time) then
				return plr:Kick("Ban perm.")
			else
				local expiration = DateTime.fromIsoDate(checkData().ban_time)
				local now = DateTime.now()
				local elt = expiration.ToLocalTime(expiration)
				if (expiration.UnixTimestamp > now.UnixTimestamp) then
					plr:Kick("You are banned. Expires " .. elt.Month ..  "/" .. elt.Day .. "/" .. elt.Year .. ": " .. checkData().ban_reason)
				else
					BAN_LIST_DataStoreService:RemoveAsync(plr.UserId)
				end
			end
		end
	end
end

panel.loadBanLogs = function()
	local ascending = false
	local page = nil
	local succes ,err = pcall(function()
		page = OrderedBanListData:GetSortedAsync(ascending,100)
	end)
	if succes then
		local bansList = page:GetCurrentPage()
		if (bansList) then
			for i,data in ipairs(bansList) do
				if not table.find(logs._banned,data.key) then
					table.insert(logs._banned,data.key)
				else
					continue
				end
			end
		end
	else
		return 
	end
end

panel.__index = panel

function panel:SpawnThread(fn)
	return task.spawn(panel[fn])
end

panel:SpawnThread("loadBanLogs")

function panel:accesToAdminPanel(user)
	assert(RunService:IsServer(),"panel.accesToAdminPanel function canno't be run on client side.")
	if (user) then
		local userCommandsWithoutFunction = {}
		for i, fn in pairs(user.Usercommands.commands) do
			if not table.find(userCommandsWithoutFunction,i) then
				table.insert(userCommandsWithoutFunction,i)
			end
		end
		return ReplicatedStorage.Coutainer.RF.AccesToAdminCommands:InvokeClient(user.player,user,userCommandsWithoutFunction)
	end
end

function panel:connectUser(user)
	assert(RunService:IsServer(),"panel.connectUser function canno't be run on client side.")
	assert(type(user) == "string","user must be a string value")	
	assert(self[user] == nil,"Server - you can't restore a connected user.")
	Players.PlayerAdded:Once(function(player)
		if (player.Name == user) then
			if not self[player.Name] then
				self[player.Name] = {
					PermissionAllowed = true,
					UserSetting = player.Name,
					player = player,
					Usercommands = require(script:WaitForChild("commands"))
				}
				self:accesToAdminPanel(self[player.Name])
			end			
		end
	end)
	return self
end

function panel:disconnectUser(user)
	assert(RunService:IsServer(),"panel.disconnectUser function canno't be run on client side.")
	assert(type(user) == "string","user must be a string value")	
	assert(self[user] ~= nil,"self[user] the user must be connected first.")
	self[user] = nil
	return print(user,"<Server> - [user] has been disconnected.")
end

function panel:getConnectedUser(user)
	local userId = Players:GetUserIdFromNameAsync(user)
	local transformToAPlayer = Players:GetPlayerByUserId(userId)
	if not transformToAPlayer then return nil end
	return self[transformToAPlayer.Name] or {}
end

function panel:autoBindUser(users:{}) : RBXScriptSignal
	return Players.PlayerAdded:Connect(function(player)
		if (table.find(users,player.Name)) then
			if not self[player.Name] then
				self[player.Name] = {
					PermissionAllowed = true,
					UserSetting = player.Name,
					player = player,
					Usercommands = require(script:WaitForChild("commands"))
				}
				self:accesToAdminPanel(self[player.Name])
			end			
		end
	end)
end

return panel
