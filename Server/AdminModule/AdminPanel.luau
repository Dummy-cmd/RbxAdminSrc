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

--[[
	banCheck()
	@Argument: Player
]]
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

--[[
	loadBanLogs()
	@Argument:
	@return a table with 100 users or all banned users if is lower than 100
]]
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

--[[
	SpawnThread(fn)
	@Argument: function
	@return a thread with current passed function from the panel table.
	@ex: SpawnThread("loadBanLogs") -> load the "loadBanLogs" function from the panel table
]]
function panel:SpawnThread(fn)
	return task.spawn(panel[fn])
end

panel:SpawnThread("loadBanLogs")

--[[
	accesToAdminPanel(user)
	@Argument: user
	@return a remote function invoke to client to enable user commands.
]]
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

--[[
	connectUser(user)
	@Argument: user
	@return connect and remote function invoke to client to enable user commands.
]]
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

--[[
	disconnectUser(user)
	@Argument: user
	@return disconnect and disable user commands.
]]
function panel:disconnectUser(user)
	assert(RunService:IsServer(),"panel.disconnectUser function canno't be run on client side.")
	assert(type(user) == "string","user must be a string value")	
	assert(self[user] ~= nil,"self[user] the user must be connected first.")
	self[user] = nil
	return print(user,"<Server> - [user] has been disconnected.")
end

--[[
	getConnectedUser(user)
	@Argument: user
	@return a table with user connected.
]]
function panel:getConnectedUser(user)
	local userId = Players:GetUserIdFromNameAsync(user)
	local transformToAPlayer = Players:GetPlayerByUserId(userId)
	if not transformToAPlayer then return nil end
	return self[transformToAPlayer.Name] or {}
end

--[[
	autoBindUser(users:{})
	@Argument: users
	@return connect and remote function invoke to client to enable user commands.
]]
function panel:autoBindUser(users:{})
	for i,player in pairs(users) do
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
end

return panel
