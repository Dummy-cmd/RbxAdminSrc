local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpsService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")
local TweenService = game:GetService("TweenService")
local InsertService = game:GetService("InsertService")


local BAN_LIST_DataStoreService = DataStoreService:GetDataStore("Ban_list") -- change ur dataStoreName
local OrderedBanListData = DataStoreService:GetOrderedDataStore("OrderedBanList_command") -- change ur dataStoreName

local ProfilsComponent = require(ServerScriptService.PackagesServer.Installer.Components.ProfilesComponents)
local Roact = require(ReplicatedStorage.Coutainer.Roact)
local Knit = require(ReplicatedStorage.Coutainer.Knit)
local Abbrevation = require(ReplicatedStorage.Coutainer.AbbreviationSystem)
local ProfilService = require(ReplicatedStorage.ProfilsModules:FindFirstChild("ProfileService"))
local ProfilStore = ProfilService.GetProfileStore("GlobalData-Config-3",require(ServerScriptService.PackagesServer.Installer.Components.Component))
local logs = require(script.logs)

if not RunService:IsServer() then return end

return {
	fn_usage = "use panel.connectUser or autoBindUser to connect mutiple user.",
	commands = {
		kick = function(player:string,reason:string)
			assert(type(player) == "string","player argument must be a string")
			local GetUserIdFromNameAsync = Players:GetUserIdFromNameAsync(player)
			local GetPlayerByUserId = Players:GetPlayerByUserId(GetUserIdFromNameAsync)
			if GetPlayerByUserId:IsDescendantOf(Players) then
				return GetPlayerByUserId:Kick(tostring(reason))
			end
		end,
		gear = function(To:string,toolsId, x, y, z)
			local GetUserIdFromNameAsync = Players:GetUserIdFromNameAsync(To)
			local GetPlayerByUserId = Players:GetPlayerByUserId(GetUserIdFromNameAsync)
			if not GetPlayerByUserId then return end
			local position = nil
			if (x) and (y) and (z) then
				if tonumber(x) ~= nil and tonumber(y) ~= nil and tonumber(z) ~= nil then
					position = Vector3.new(tonumber(x),tonumber(y),tonumber(z))
				end
			end
			local tool = tonumber(toolsId)
			if tool ~=  nil then
				local insert = function()
					return InsertService:LoadAsset(tool) or nil
				end
				local object = insert()
				object.Name = tostring(tool)
				local backpack = GetPlayerByUserId.Backpack
				if workspace:FindFirstChild("Tool Invoked by <" .. GetPlayerByUserId.Name .. ">" .. "id: " .. tostring(tool)) then
					workspace:FindFirstChild("Tool Invoked by <" .. GetPlayerByUserId.Name .. ">" .. "id: " .. tostring(tool)):Destroy()
					if (object) then
						if (object:FindFirstChildOfClass("Tool")) then
							object:FindFirstChildOfClass("Tool").Name = tostring(toolsId)
							object:FindFirstChildOfClass("Tool").Parent = backpack
							object:Destroy()
						elseif (object:IsA("BasePart")) then
							local f = Instance.new("Folder",workspace)
							f.Name = "Tool Invoked by <" .. GetPlayerByUserId.Name .. ">" .. "id: " .. tostring(tool)
							object.Parent = f
							object:PivotTo(CFrame.new(position.X,position.Y,position.Z))
						end
					else
						return
					end		
				elseif backpack:FindFirstChild(object.Name) then
					backpack:FindFirstChild(object.Name):Destroy()
					if (object) then
						if (object:FindFirstChildOfClass("Tool")) then
							object:FindFirstChildOfClass("Tool").Name = tostring(toolsId)
							object:FindFirstChildOfClass("Tool").Parent = backpack
							object:Destroy()
						elseif (object:IsA("BasePart")) then
							local f = Instance.new("Folder",workspace)
							f.Name = "Tool Invoked by <" .. GetPlayerByUserId.Name .. ">" .. "id: " .. tostring(tool)
							object.Parent = f
							object:PivotTo(CFrame.new(position.X,position.Y,position.Z))
						end
					else
						return
					end	
				else
					if (object) then
						if (object:FindFirstChildOfClass("Tool")) then
							object:FindFirstChildOfClass("Tool").Name = tostring(toolsId)
							object:FindFirstChildOfClass("Tool").Parent = backpack
							object:Destroy()
						elseif (object:IsA("BasePart")) then
							local f = Instance.new("Folder",workspace)
							f.Name = "Tool Invoked by <" .. GetPlayerByUserId.Name .. ">" .. "id: " .. tostring(tool)
							object.Parent = f
							object:PivotTo(CFrame.new(position.X,position.Y,position.Z))
						end
					else
						return
					end		
				end	
			end
		end,
		removeGear = function(To,toolsId)
			local GetUserIdFromNameAsync = Players:GetUserIdFromNameAsync(To)
			local GetPlayerByUserId = Players:GetPlayerByUserId(GetUserIdFromNameAsync)
			if not GetPlayerByUserId then return end	
			local tool = tonumber(toolsId)
			if tool ~=  nil then
				local backpack = GetPlayerByUserId.Backpack
				local character = GetPlayerByUserId.Character or GetPlayerByUserId.CharacterAdded:Wait()
				local object = workspace:FindFirstChild("Tool Invoked by <" .. GetPlayerByUserId.Name .. ">" .. "id: " .. tostring(tool))
				if (object) then
					return object:Destroy()
				elseif (backpack:FindFirstChild(tostring(tool))) then
					return backpack:FindFirstChild(tostring(tool)):Destroy()
				elseif character:FindFirstChild(tostring(tool)) then
					return character:FindFirstChild(tostring(tool)):Destroy()
				else
					return false
				end		
			end
		end,
		joinLogs = function(admin)
			local logs = require(script.logs)
			local joinsLogs = logs._joins
			local getAdminIdFromName = Players:GetUserIdFromNameAsync(admin)
			local adminByUserId = Players:GetPlayerByUserId(getAdminIdFromName)
			if (adminByUserId) then
				if adminByUserId:IsDescendantOf(Players) then
					local gui = adminByUserId.PlayerGui
					local adminPanel = gui.ScreenGui:WaitForChild("main")
					local canvas = adminPanel.CanvasGroup
					local logsElement_imported = canvas.logsElement_imported
					local ScrollingFrame = logsElement_imported.ScrollingFrame
					local returnBack = logsElement_imported.ReturnBackFrame
					local player_cach_name = script.player_name_cach
					for i,frame in pairs(ScrollingFrame:GetChildren()) do
						if frame:IsA("Frame") then
							frame:Destroy()
						end
					end
					canvas.CommandsFrameGroup.Visible = false
					canvas.main.Visible = false
					TweenService:Create(logsElement_imported,TweenInfo.new(.15),{Position = UDim2.fromScale(.5,.5)}):Play()
					local mouseEnter 
					local mouseLeave
					mouseEnter = logsElement_imported.ReturnBackFrame.ImageButton.MouseEnter:Connect(function()
						TweenService:Create(logsElement_imported.ReturnBackFrame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(0,0,0)}):Play()
						TweenService:Create(logsElement_imported.ReturnBackFrame.UIScale,TweenInfo.new(.15),{Scale = 0.9}):Play()
						TweenService:Create(logsElement_imported.ReturnBackFrame,TweenInfo.new(.15),{BackgroundTransparency = 0.35,BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
						for i,v in pairs(logsElement_imported.ReturnBackFrame:GetDescendants()) do
							if v:IsA("ImageButton") then
								TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(255,255,255)}):Play()
							end
							task.wait()
						end
					end)
					mouseLeave = logsElement_imported.ReturnBackFrame.ImageButton.MouseLeave:Connect(function()
						TweenService:Create(logsElement_imported.ReturnBackFrame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(255,255,255)}):Play()
						TweenService:Create(logsElement_imported.ReturnBackFrame.UIScale,TweenInfo.new(.15),{Scale = 1}):Play()
						TweenService:Create(logsElement_imported.ReturnBackFrame,TweenInfo.new(.15),{BackgroundTransparency = 0.45,BackgroundColor3 = Color3.fromRGB(188,188,188)}):Play()
						for i,v in pairs(logsElement_imported.ReturnBackFrame:GetDescendants()) do
							if v:IsA("ImageButton") then
								TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(0,0,0)}):Play()
							end
							task.wait()
						end
					end)
					logsElement_imported.ReturnBackFrame.ImageButton.MouseButton1Down:Once(function()
						TweenService:Create(logsElement_imported,TweenInfo.new(.15),{Position = UDim2.fromScale(1.5,.5)}):Play()
						mouseLeave:Disconnect()
						mouseEnter:Disconnect()
						mouseEnter = nil
						mouseLeave = nil
						canvas.CommandsFrameGroup.Visible = true
						canvas.main.Visible = true
						TweenService:Create(logsElement_imported.ReturnBackFrame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(255,255,255)}):Play()
						TweenService:Create(logsElement_imported.ReturnBackFrame.UIScale,TweenInfo.new(.15),{Scale = 1}):Play()
						TweenService:Create(logsElement_imported.ReturnBackFrame,TweenInfo.new(.15),{BackgroundTransparency = 0.45,BackgroundColor3 = Color3.fromRGB(188,188,188)}):Play()
						for i,v in pairs(logsElement_imported.ReturnBackFrame:GetDescendants()) do
							if v:IsA("ImageButton") then
								TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(0,0,0)}):Play()
							end
							task.wait()
						end
						for i,frame in pairs(ScrollingFrame:GetChildren()) do
							if frame:IsA("Frame") then
								frame:Destroy()
							end
							task.wait()
						end
					end)
					for index,player in ipairs(joinsLogs) do
						local getName = Players:GetNameFromUserIdAsync(player)
						local getId = Players:GetUserIdFromNameAsync(getName)
						local getUser = Players:GetPlayerByUserId(player)
						local nowTimeStamp = DateTime.now().UnixTimestamp
						local fromUnixTimeStamp = DateTime.fromUnixTimestamp(nowTimeStamp)
						local elt = fromUnixTimeStamp.ToLocalTime(fromUnixTimeStamp)
						local userFrame = player_cach_name:Clone()
						userFrame.Parent = ScrollingFrame
						userFrame.Name = tostring(getName) .. " / " .. tostring(getId)
						userFrame._logsHandler_playerId.Name = tostring(getId)
						userFrame:FindFirstChild(tostring(getId)).playersImages.p2.Image = (
							Players:GetUserThumbnailAsync(getId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
						)
						if not getUser then
							userFrame:FindFirstChild(tostring(getId)).players.plrName.Text = (
							"Joins_Data :  " .. getName .. " / " .. getId .. "  Time :  " .. elt.Month .. "/"  .. elt.Day .. "/" .. elt.Year .. "/ " ..
								elt.Hour .. ":" .. elt.Minute .. "  User State : offline"
							)
						else
							userFrame:FindFirstChild(tostring(getId)).players.plrName.Text = (
							"Joins_Data :  " .. getName .. " / " .. getId .. "  Time :  " .. elt.Month .. "/"  .. elt.Day .. "/" .. elt.Year .. "/ " ..
								elt.Hour .. ":" .. elt.Minute .. "  User State : Online"
							)
						end
						task.wait(.1)
					end
				end				
			end
		end,
		leaveLogs = function(admin) -- automatic handler
			local logs = require(script.logs)
			local leavesLogs = logs._leaves
			local getAdminIdFromName = Players:GetUserIdFromNameAsync(admin)
			local adminByUserId = Players:GetPlayerByUserId(getAdminIdFromName)
			if (adminByUserId) then
				if adminByUserId:IsDescendantOf(Players) then
					local gui = adminByUserId.PlayerGui
					local adminPanel = gui.ScreenGui:WaitForChild("main")
					local canvas = adminPanel.CanvasGroup
					local logsElement_imported = canvas.logsElement_imported
					local ScrollingFrame = logsElement_imported.ScrollingFrame
					local returnBack = logsElement_imported.ReturnBackFrame
					local player_cach_name = script.player_name_cach
					for i,frame in pairs(ScrollingFrame:GetChildren()) do
						if frame:IsA("Frame") then
							frame:Destroy()
						end
					end
					canvas.CommandsFrameGroup.Visible = false
					canvas.main.Visible = false
					TweenService:Create(logsElement_imported,TweenInfo.new(.15),{Position = UDim2.fromScale(.5,.5)}):Play()
					local mouseEnter 
					local mouseLeave									
					mouseEnter = logsElement_imported.ReturnBackFrame.ImageButton.MouseEnter:Connect(function()
						TweenService:Create(logsElement_imported.ReturnBackFrame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(0,0,0)}):Play()
						TweenService:Create(logsElement_imported.ReturnBackFrame.UIScale,TweenInfo.new(.15),{Scale = 0.9}):Play()
						TweenService:Create(logsElement_imported.ReturnBackFrame,TweenInfo.new(.15),{BackgroundTransparency = 0.35,BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
						for i,v in pairs(logsElement_imported.ReturnBackFrame:GetDescendants()) do
							if v:IsA("ImageButton") then
								TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(255,255,255)}):Play()
							end
							task.wait()
						end
					end)
					mouseLeave = logsElement_imported.ReturnBackFrame.ImageButton.MouseLeave:Connect(function()
						TweenService:Create(logsElement_imported.ReturnBackFrame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(255,255,255)}):Play()
						TweenService:Create(logsElement_imported.ReturnBackFrame.UIScale,TweenInfo.new(.15),{Scale = 1}):Play()
						TweenService:Create(logsElement_imported.ReturnBackFrame,TweenInfo.new(.15),{BackgroundTransparency = 0.45,BackgroundColor3 = Color3.fromRGB(188,188,188)}):Play()
						for i,v in pairs(logsElement_imported.ReturnBackFrame:GetDescendants()) do
							if v:IsA("ImageButton") then
								TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(0,0,0)}):Play()
							end
							task.wait()
						end
					end)
					logsElement_imported.ReturnBackFrame.ImageButton.MouseButton1Down:Once(function()
						TweenService:Create(logsElement_imported,TweenInfo.new(.15),{Position = UDim2.fromScale(1.5,.5)}):Play()
						mouseLeave:Disconnect()
						mouseEnter:Disconnect()
						mouseEnter = nil
						mouseLeave = nil
						canvas.CommandsFrameGroup.Visible = true
						canvas.main.Visible = true
						TweenService:Create(logsElement_imported.ReturnBackFrame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(255,255,255)}):Play()
						TweenService:Create(logsElement_imported.ReturnBackFrame.UIScale,TweenInfo.new(.15),{Scale = 1}):Play()
						TweenService:Create(logsElement_imported.ReturnBackFrame,TweenInfo.new(.15),{BackgroundTransparency = 0.45,BackgroundColor3 = Color3.fromRGB(188,188,188)}):Play()
						for i,v in pairs(logsElement_imported.ReturnBackFrame:GetDescendants()) do
							if v:IsA("ImageButton") then
								TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(0,0,0)}):Play()
							end
							task.wait()
						end
						for i,frame in pairs(ScrollingFrame:GetChildren()) do
							if frame:IsA("Frame") then
								frame:Destroy()
							end
							task.wait()
						end
					end)
					for index,player in ipairs(leavesLogs) do
						local getName = Players:GetNameFromUserIdAsync(player)
						local getId = Players:GetUserIdFromNameAsync(getName)
						local getUser = Players:GetPlayerByUserId(player)
						local nowTimeStamp = DateTime.now().UnixTimestamp
						local fromUnixTimeStamp = DateTime.fromUnixTimestamp(nowTimeStamp)
						local elt = fromUnixTimeStamp.ToLocalTime(fromUnixTimeStamp)
						local userFrame = player_cach_name:Clone()
						userFrame.Parent = ScrollingFrame
						userFrame.Name = tostring(getName) .. " / " .. tostring(getId)
						userFrame._logsHandler_playerId.Name = tostring(getId)
						userFrame:FindFirstChild(tostring(getId)).playersImages.p2.Image = (
						Players:GetUserThumbnailAsync(getId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
						)
						userFrame:FindFirstChild(tostring(getId)).players.plrName.Text = (
						"Leaves_Data :  " .. getName .. " / " .. getId .. "  Time :  " .. elt.Month .. "/"  .. elt.Day .. "/" .. elt.Year .. "/ " ..
							elt.Hour .. ":" .. elt.Minute .. "  User State : offline"
						)
						task.wait(.1)
					end
				end				
			end
		end,
		GetData = function(admin,player:string)
			assert(type(player) == "string","player argument must be a string")
			assert(type(admin) == "string","admin argument must be a string")
			local getUserIdFromName = Players:GetUserIdFromNameAsync(player)
			local getAdminIdFromName = Players:GetUserIdFromNameAsync(admin)
			if (getUserIdFromName) then
				local playerByUserId = Players:GetPlayerByUserId(getUserIdFromName)
				if (playerByUserId) then
					
					local init = function()
						local adminByUserId = Players:GetPlayerByUserId(getAdminIdFromName)
						if (adminByUserId) then
							if adminByUserId:IsDescendantOf(Players) then
								local gui = adminByUserId.PlayerGui
								local adminPanel = gui.ScreenGui:WaitForChild("main")
								local canvas = adminPanel.CanvasGroup
								local RoactElement_impoted = canvas.RoactElement_imported
								local GetDataIndex = RoactElement_impoted.GetDataIndex
								local data = ProfilStore:ViewProfileAsync("Player_"..getUserIdFromName) or { Data = {
									leaderstats = {
										PlayerTime = 0,donation = 0
									}
								}}
								if (data) then
									TweenService:Create(RoactElement_impoted,TweenInfo.new(.15),{Position = UDim2.fromScale(.5,.5)}):Play()
									canvas.CommandsFrameGroup.Visible = false
									canvas.main.Visible = false
									local function applyDescriptionData()
										local playerLabels = RoactElement_impoted.GetDataIndex.players
										local playerImage = RoactElement_impoted.GetDataIndex.playersImages
										playerImage:FindFirstChild("p2").Image = Players:GetUserThumbnailAsync(
										getUserIdFromName, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420
										)
										playerLabels:FindFirstChild("plrName").Text = "@".. player or playerByUserId.Name
										playerLabels.DataSortTable.Text = `PlayerTime : {Abbrevation(data.Data.leaderstats.PlayerTime)}, donation: {Abbrevation(data.Data.leaderstats.donation)}`
									end
									applyDescriptionData()
									local mouseEnter 
									local mouseLeave									
									mouseEnter = RoactElement_impoted.ReturnBackFrame.ImageButton.MouseEnter:Connect(function()
										TweenService:Create(RoactElement_impoted.ReturnBackFrame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(0,0,0)}):Play()
										TweenService:Create(RoactElement_impoted.ReturnBackFrame.UIScale,TweenInfo.new(.15),{Scale = 0.9}):Play()
										TweenService:Create(RoactElement_impoted.ReturnBackFrame,TweenInfo.new(.15),{BackgroundTransparency = 0.35,BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
										for i,v in pairs(RoactElement_impoted.ReturnBackFrame:GetDescendants()) do
											if v:IsA("ImageButton") then
												TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(255,255,255)}):Play()
											end
											task.wait()
										end
									end)
									mouseLeave = RoactElement_impoted.ReturnBackFrame.ImageButton.MouseLeave:Connect(function()
										TweenService:Create(RoactElement_impoted.ReturnBackFrame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(255,255,255)}):Play()
										TweenService:Create(RoactElement_impoted.ReturnBackFrame.UIScale,TweenInfo.new(.15),{Scale = 1}):Play()
										TweenService:Create(RoactElement_impoted.ReturnBackFrame,TweenInfo.new(.15),{BackgroundTransparency = 0.45,BackgroundColor3 = Color3.fromRGB(188,188,188)}):Play()
										for i,v in pairs(RoactElement_impoted.ReturnBackFrame:GetDescendants()) do
											if v:IsA("ImageButton") then
												TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(0,0,0)}):Play()
											end
											task.wait()
										end
									end)
									RoactElement_impoted.ReturnBackFrame.ImageButton.MouseButton1Down:Once(function()
										TweenService:Create(RoactElement_impoted,TweenInfo.new(.15),{Position = UDim2.fromScale(1.5,.5)}):Play()
										mouseLeave:Disconnect()
										mouseEnter:Disconnect()
										mouseEnter = nil
										mouseLeave = nil
										canvas.CommandsFrameGroup.Visible = true
										canvas.main.Visible = true
										TweenService:Create(RoactElement_impoted.ReturnBackFrame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(255,255,255)}):Play()
										TweenService:Create(RoactElement_impoted.ReturnBackFrame.UIScale,TweenInfo.new(.15),{Scale = 1}):Play()
										TweenService:Create(RoactElement_impoted.ReturnBackFrame,TweenInfo.new(.15),{BackgroundTransparency = 0.45,BackgroundColor3 = Color3.fromRGB(188,188,188)}):Play()
										for i,v in pairs(RoactElement_impoted.ReturnBackFrame:GetDescendants()) do
											if v:IsA("ImageButton") then
												TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(0,0,0)}):Play()
											end
											task.wait()
										end
									end)
								end
							end
						end
					end
					init()
				else
					local init = function()
						local adminByUserId = Players:GetPlayerByUserId(getAdminIdFromName)
						if (adminByUserId) then
							if adminByUserId:IsDescendantOf(Players) then
								local gui = adminByUserId.PlayerGui
								local adminPanel = gui.ScreenGui:WaitForChild("main")
								local canvas = adminPanel.CanvasGroup
								local RoactElement_impoted = canvas.RoactElement_imported
								local GetDataIndex = RoactElement_impoted.GetDataIndex		
								local data = ProfilStore:ViewProfileAsync("Player_"..getUserIdFromName) or { Data = {
									leaderstats = {
										PlayerTime = 0,donation = 0
									}
								}}
								if (data) then
									TweenService:Create(RoactElement_impoted,TweenInfo.new(.15),{Position = UDim2.fromScale(.5,.5)}):Play()
									canvas.CommandsFrameGroup.Visible = false
									canvas.main.Visible = false
									local function applyDescriptionData()
										local playerLabels = RoactElement_impoted.GetDataIndex.players
										local playerImage = RoactElement_impoted.GetDataIndex.playersImages
										playerImage:FindFirstChild("p2").Image = Players:GetUserThumbnailAsync(
										getUserIdFromName, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420
										)

										playerLabels:FindFirstChild("plrName").Text = "@".. player
										playerLabels.DataSortTable.Text = `PlayerTime : {Abbrevation(data.Data.leaderstats.PlayerTime)}, donation: {Abbrevation(data.Data.leaderstats.donation)}`
									end
									applyDescriptionData()
									local mouseEnter 
									local mouseLeave									
									mouseEnter = RoactElement_impoted.ReturnBackFrame.ImageButton.MouseEnter:Connect(function()
										TweenService:Create(RoactElement_impoted.ReturnBackFrame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(0,0,0)}):Play()
										TweenService:Create(RoactElement_impoted.ReturnBackFrame.UIScale,TweenInfo.new(.15),{Scale = 0.9}):Play()
										TweenService:Create(RoactElement_impoted.ReturnBackFrame,TweenInfo.new(.15),{BackgroundTransparency = 0.35,BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
										for i,v in pairs(RoactElement_impoted.ReturnBackFrame:GetDescendants()) do
											if v:IsA("ImageButton") then
												TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(255,255,255)}):Play()
											end
										end
									end)
									mouseLeave = RoactElement_impoted.ReturnBackFrame.ImageButton.MouseLeave:Connect(function()
										TweenService:Create(RoactElement_impoted.ReturnBackFrame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(255,255,255)}):Play()
										TweenService:Create(RoactElement_impoted.ReturnBackFrame.UIScale,TweenInfo.new(.15),{Scale = 1}):Play()
										TweenService:Create(RoactElement_impoted.ReturnBackFrame,TweenInfo.new(.15),{BackgroundTransparency = 0.45,BackgroundColor3 = Color3.fromRGB(188,188,188)}):Play()
										for i,v in pairs(RoactElement_impoted.ReturnBackFrame:GetDescendants()) do
											if v:IsA("ImageButton") then
												TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(0,0,0)}):Play()
											end
										end
									end)
									RoactElement_impoted.ReturnBackFrame.ImageButton.MouseButton1Down:Once(function()
										TweenService:Create(RoactElement_impoted,TweenInfo.new(.15),{Position = UDim2.fromScale(1.5,.5)}):Play()
										mouseLeave:Disconnect()
										mouseEnter:Disconnect()
										mouseEnter = nil
										mouseLeave = nil
										canvas.CommandsFrameGroup.Visible = true
										canvas.main.Visible = true
										TweenService:Create(RoactElement_impoted.ReturnBackFrame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(255,255,255)}):Play()
										TweenService:Create(RoactElement_impoted.ReturnBackFrame.UIScale,TweenInfo.new(.15),{Scale = 1}):Play()
										TweenService:Create(RoactElement_impoted.ReturnBackFrame,TweenInfo.new(.15),{BackgroundTransparency = 0.45,BackgroundColor3 = Color3.fromRGB(188,188,188)}):Play()
										for i,v in pairs(RoactElement_impoted.ReturnBackFrame:GetDescendants()) do
											if v:IsA("ImageButton") then
												TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(0,0,0)}):Play()
											end
										end
									end)
								end
							end
						end
					end
					init()
				end
			end
		end,
		Timeban = function(player,days,reason)
			assert(type(player) == "string","player argument must be a string")
			days = tonumber(days)
			if (days == nil) then
				return 
			end
			local GetUserIdFromNameAsync = Players:GetUserIdFromNameAsync(player)
			local GetPlayerByUserId = Players:GetPlayerByUserId(GetUserIdFromNameAsync)
			local checkData = function()
				if GetUserIdFromNameAsync == nil then return end
				if GetPlayerByUserId == nil then
					if (BAN_LIST_DataStoreService:GetAsync(GetUserIdFromNameAsync) ~= nil) then
						return true
					else
						return false
					end
				else
					if (BAN_LIST_DataStoreService:GetAsync(GetPlayerByUserId.UserId) ~= nil) then
						return true
					else
						return false
					end
				end
			end
			if checkData() == true then return end
			local unixExpiration = DateTime.now().UnixTimestamp + (days * 86400)
			local expiration = DateTime.fromUnixTimestamp(unixExpiration)
			local elt = expiration.ToLocalTime(expiration)
			local onlyMessageReason = reason
			reason = "TimeBan, Reason : " .. reason .. ". Expires : " .. elt.Month ..  "/" .. elt.Day .. "/" .. elt.Year
			local postDataAsync = function()
				if checkData() == false then
					if GetPlayerByUserId == nil then
						BAN_LIST_DataStoreService:SetAsync(GetUserIdFromNameAsync,
							{
								ban_reason = onlyMessageReason,
								ban_time = expiration.ToIsoDate(expiration),
								ban_id = GetUserIdFromNameAsync,
							})
						OrderedBanListData:SetAsync(GetUserIdFromNameAsync,GetUserIdFromNameAsync)
						if not table.find(logs._banned,GetUserIdFromNameAsync) then
							table.insert(logs,GetUserIdFromNameAsync)
						else
							print("Server - ban logs updated")
							table.remove(logs,GetUserIdFromNameAsync)
							table.insert(logs,GetUserIdFromNameAsync)
						end
					else
						BAN_LIST_DataStoreService:SetAsync(GetPlayerByUserId.UserId,
							{
								ban_reason = onlyMessageReason,
								ban_time = expiration.ToIsoDate(expiration),
								ban_id = GetPlayerByUserId.UserId,
							})
						OrderedBanListData:SetAsync(GetPlayerByUserId.UserId,GetPlayerByUserId.UserId)
						if not table.find(logs._banned,GetPlayerByUserId.UserId) then
							table.insert(logs,GetPlayerByUserId.UserId)
						else
							print("Server - ban logs updated")
							table.remove(logs,GetPlayerByUserId.UserId)
							table.insert(logs,GetPlayerByUserId.UserId)
						end
					end
				else
					return nil
				end
			end
			postDataAsync()
			local function checkIfPlayerExist()
				if GetPlayerByUserId == nil then return end
				if (GetPlayerByUserId:IsDescendantOf(Players)) then
					return GetPlayerByUserId:Kick(reason)
				end
			end
			checkIfPlayerExist()
		end,
		unTimeban = function(player,reason)
			if tonumber(player) ~= nil then
				local playerUsingIdMethods = nil
				playerUsingIdMethods = Players:GetPlayerByUserId(tonumber(player))
				if (playerUsingIdMethods) then
					local checkData = function()
						return BAN_LIST_DataStoreService:GetAsync(playerUsingIdMethods.UserId) or false
					end
					if (checkData() ~= false) then
						BAN_LIST_DataStoreService:RemoveAsync(playerUsingIdMethods.UserId)
						OrderedBanListData:RemoveAsync(playerUsingIdMethods.UserId)
					else
						return false
					end
				else
					local checkData = function()
						return BAN_LIST_DataStoreService:GetAsync(playerUsingIdMethods.UserId) or false
					end
					if (checkData() ~= false) then
						BAN_LIST_DataStoreService:RemoveAsync(tonumber(player))
						OrderedBanListData:RemoveAsync(tonumber(player))
						if (table.find(logs._banned,playerUsingIdMethods.UserId)) then
							table.remove(logs,table.find(logs._banned,playerUsingIdMethods.UserId))
						end
					else
						return false
					end
				end
			else
				local GetUserIdFromNameAsync = Players:GetUserIdFromNameAsync(player)
				local GetPlayerByUserId = Players:GetPlayerByUserId(GetUserIdFromNameAsync)
				if (GetPlayerByUserId) then
					local checkData = function()
						return BAN_LIST_DataStoreService:GetAsync(GetPlayerByUserId.UserId) or false
					end
					if (checkData() ~= false) then
						BAN_LIST_DataStoreService:RemoveAsync(GetPlayerByUserId.UserId)
						OrderedBanListData:RemoveAsync(GetPlayerByUserId.UserId)
						if (table.find(logs._banned,GetPlayerByUserId.UserId)) then
							table.remove(logs,table.find(logs._banned,GetPlayerByUserId.UserId))
						end
					else
						return false
					end
				else
					local checkData = function()
						return BAN_LIST_DataStoreService:GetAsync(GetUserIdFromNameAsync) or false
					end
					if (checkData() ~= false) then
						BAN_LIST_DataStoreService:RemoveAsync(GetUserIdFromNameAsync)
						OrderedBanListData:RemoveAsync(GetUserIdFromNameAsync)
						if (table.find(logs._banned,GetUserIdFromNameAsync)) then
							table.remove(logs,table.find(logs._banned,GetUserIdFromNameAsync))
						end
					else
						return false
					end
				end
			end
		end,
		unBanAll = function()
			local ascending = false
			local page = nil
			local succes ,err = pcall(function()
				page = OrderedBanListData:GetSortedAsync(ascending,100)
			end)
			if succes then
				local bansList = page:GetCurrentPage()
				local checkData = function(id)
					return BAN_LIST_DataStoreService:GetAsync(id) or false
				end
				for key, ban_id in ipairs(bansList) do
					if checkData(ban_id.key) ~= false then
						BAN_LIST_DataStoreService:RemoveAsync(ban_id.key)
						OrderedBanListData:RemoveAsync(ban_id.key)
						if (table.find(logs._banned,ban_id.key)) then
							table.remove(logs,table.find(logs._banned,ban_id.key))
						end
					else
						continue
					end
				end
			else
				return 
			end
		end,
		teleport = function(player1,player2)
			local GetUserIdFromNameAsync = Players:GetUserIdFromNameAsync(player2)
			local GetPlayerByUserId = Players:GetPlayerByUserId(GetUserIdFromNameAsync)
			local AdminGetUserIdFromNameAsync = Players:GetUserIdFromNameAsync(player1)
			local adminPlayer = Players:GetPlayerByUserId(AdminGetUserIdFromNameAsync)
			if (GetPlayerByUserId) and (adminPlayer) then
				if GetPlayerByUserId.Name == adminPlayer.Name then 
					local player_character = GetPlayerByUserId.Character or  GetPlayerByUserId.CharacterAdded:Wait()
					player_character.HumanoidRootPart.CFrame = adminPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,0)
				else
					local player_character = GetPlayerByUserId.Character or  GetPlayerByUserId.CharacterAdded:Wait()
					player_character.HumanoidRootPart.CFrame = adminPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
				end
			else
				return false
			end
		end,
		
	}
}
