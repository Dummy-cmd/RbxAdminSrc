local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

local Knit = require(ReplicatedStorage.Coutainer.Knit)
local Promise = require(Knit.Util.Promise)
local Option = require(ReplicatedStorage.Coutainer.Option)
local TableUtil = require(ReplicatedStorage.Coutainer.TableUtil)


return {
	
	UpdatePermission = function(tbl,user)
		if type(tbl) ~= nil then
			return tbl[user]	
		else	
			warn("Attemp to : <"..user..">"..
				"from adminPanelController"..
				"returned value is NUL"..
				`{debug.traceback("- Admin Panel Controller Error - ",2)}`)		
			return nil			
		end
	end,
	
	closePermissionForAll = "never."
}
