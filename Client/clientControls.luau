local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local Knit = require(ReplicatedStorage.Coutainer.Knit)
local Promise = require(Knit.Util.Promise)
local Option = require(ReplicatedStorage.Coutainer.Option)
local TableUtil = require(ReplicatedStorage.Coutainer.TableUtil)
local Ui_emitter = require(ReplicatedStorage.Coutainer.UI_EmitterModule)
local Maid = require(ReplicatedStorage.Coutainer.Maid)

local controller = {
	_clientController = Players.LocalPlayer,
	_clientFunctions = {},
}
controller.__index = controller

local function onChangeVisibleUi(ui)
	if ui.Enabled == true then
		ui.Enabled = false
	else
		ui.Enabled = true
	end
end

local function create_cach(parent,name,text,isEditable:boolean)
	local cach = script.player_name_cach:Clone()
	cach.Parent = parent
	cach.Name = name
	cach._commands_handler_name.Name = "Command: <"..name..">"
	cach:FindFirstChild("Command: <"..name..">").info.TextBox.Text = text
	cach:FindFirstChild("Command: <"..name..">").info.TextBox.TextEditable = isEditable
	return cach
end

local function _enable(self,data,commands)
	local playerGui = Players.LocalPlayer.PlayerGui
	local GuiPanel = playerGui:WaitForChild("ScreenGui")
	local main = GuiPanel:WaitForChild("main")
	local canvasGroup = main.CanvasGroup
	local folder:Folder = main.Emitters
	local canvasMain = canvasGroup.main
	local CmdsListFrame = canvasGroup.CmdsListFrame
	local cmdsReturnToMain = CmdsListFrame.ReturnBackFrame
	local cmds_list = CmdsListFrame.ScrollingFrame
	local createCmds = function()
		for i,cmdsName in ipairs(commands) do
			local cach = create_cach(cmds_list,cmdsName,"",false)
			if cmdsName == "joinLogs" then
				cach:FindFirstChild("Command: <"..cmdsName..">").info.TextBox.Text = cmdsName..": Open a list of all joined user in this server. argument: admin (you), ex: " .. (
					"joinLogs " .. "and click on execute" 
				)
				cach:FindFirstChild("Command: <"..cmdsName..">").images.p2.Image = "rbxassetid://9086583856"
			elseif (cmdsName == "GetData") then
				cach:FindFirstChild("Command: <"..cmdsName..">").info.TextBox.Text = cmdsName..": Open a page getting data of a specified user, arguments: admin (you), player: (PLAYER_NAME), ex: " .. (
					"GetData - YourName - PLAYER_NAME " .. "and click on execute."
				) 
				cach:FindFirstChild("Command: <"..cmdsName..">").images.p2.Image = "rbxassetid://2038225630"
			elseif (cmdsName) == "unBanAll" then
				cach:FindFirstChild("Command: <"..cmdsName..">").info.TextBox.Text = cmdsName..": Remove all Timeban and ban, ex: " .. (
					"unBanAll " .. "and click on execute."
				)
				cach:FindFirstChild("Command: <"..cmdsName..">").images.p2.Image = "rbxassetid://12465540157"
			elseif (cmdsName) == "unTimeban" then
				cach:FindFirstChild("Command: <"..cmdsName..">").info.TextBox.Text = cmdsName..": Remove a Timeban user; argument: [player (PLAYER_NAME or UserID), reason], ex: ".. (
					"unTimeban - PLAYER_NAME or UserId - ban removed " .. "and click on execute."
				)
				cach:FindFirstChild("Command: <"..cmdsName..">").images.p2.Image = "rbxassetid://10385393084"
			elseif (cmdsName) == "kick" then
				cach:FindFirstChild("Command: <"..cmdsName..">").info.TextBox.Text = cmdsName..": kick a player using the player argument , argument [player: PLAYER_NAME] ex: " .. (
					"kick - PLAYER_NAME " .. "and click on execute" 
				)
				cach:FindFirstChild("Command: <"..cmdsName..">").images.p2.Image = "rbxassetid://6730262023"
			elseif (cmdsName == "leaveLogs") then
				cach:FindFirstChild("Command: <"..cmdsName..">").info.TextBox.Text = cmdsName..": Open a list of all leaved user in this server. argument: admin (you), ex: " .. (
					"leaveLogs " .. "and click on execute" 
				)
				cach:FindFirstChild("Command: <"..cmdsName..">").images.p2.Image = "rbxassetid://9086583856"
			elseif (cmdsName == "gear") then
				cach:FindFirstChild("Command: <"..cmdsName..">").info.TextBox.Text = cmdsName..": Insert a roblox tool id.,argument: giveTo (playerName), id: any tool id, (optional: x ,y ,z must be a number value to create a Vector3 for your model to set a position.) ex: " .. (
					"gear - Player_Name - 212296936 " .. "and click on execute" 
				)
				cach:FindFirstChild("Command: <"..cmdsName..">").images.p2.Image = "rbxassetid://12403104094"
			elseif (cmdsName == "Timeban") then
				cach:FindFirstChild("Command: <"..cmdsName..">").info.TextBox.Text = cmdsName..": create a Timeban data for a specified user; argument: [ player (PLAYER_NAME or UserID), days (any number), reason (any) ], ex: ".. (
					"Timeban - PLAYER_NAME or UserId - 50 - banned. " .. "and click on execute."
				)
				cach:FindFirstChild("Command: <"..cmdsName..">").images.p2.Image = "rbxassetid://13738303094"
			elseif (cmdsName == "removeGear") then
				cach:FindFirstChild("Command: <"..cmdsName..">").info.TextBox.Text = cmdsName..": removed a roblox tool. ,argument: ToolOwner: (playerName), id: tool id to remove ex: " .. (
					"removeGear - Player_Name - 212296936 " .. "and click on execute" 
				)
				cach:FindFirstChild("Command: <"..cmdsName..">").images.p2.Image = "rbxassetid://12403104094"
			elseif (cmdsName == "teleport") then
				cach:FindFirstChild("Command: <"..cmdsName..">").info.TextBox.Text = cmdsName..": Teleport a player on the given player name: argument (player1 ex: yourself or anyone), (player2: any player in game or yourself),  ex: " .. (
					"teleport - Player_Name - Player_Name " .. "and click on execute" 
				)
				cach:FindFirstChild("Command: <"..cmdsName..">").images.p2.Image = "rbxassetid://6723742952"
			end			
			task.wait(.1)
		end
	end
	task.spawn(createCmds)
	local CommandsFrameGroup = canvasGroup.CommandsFrameGroup
	local ValidCommandFrame = CommandsFrameGroup.ValidCommandFrame
	local CommandsNameFrame = CommandsFrameGroup.CommandsNameFrame
	local OutputFrame = CommandsFrameGroup.OutputFrame_StudioReceivedAnyMessageHere
	local ReturnBackFrame = CommandsFrameGroup.ReturnBackFrame
	local PlayersMainFrame = CommandsFrameGroup.PlayersMainFrame
	PlayersMainFrame.players:WaitForChild("TextLabel").Text = "@" .. data.player.Name .. " / " .. data.player.UserId
	PlayersMainFrame.playersImage:FindFirstChild("p2").Image = Players:GetUserThumbnailAsync(data.player.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
	self._maidConstructor = Maid.new()
	self._maidConstructor:giveTask(canvasGroup.PlayerListFrameCoutainer.ReturnBackFrame.MouseEnter:Connect(function()
		SoundService:PlayLocalSound(SoundService.ui_hover_ugd)
		TweenService:Create(canvasGroup.PlayerListFrameCoutainer.ReturnBackFrame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(0,0,0)}):Play()
		TweenService:Create(canvasGroup.PlayerListFrameCoutainer.ReturnBackFrame.UIScale,TweenInfo.new(.15),{Scale = 0.9}):Play()
		TweenService:Create(canvasGroup.PlayerListFrameCoutainer.ReturnBackFrame,TweenInfo.new(.15),{BackgroundTransparency = 0.35,BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
		for i,v in pairs(canvasGroup.PlayerListFrameCoutainer.ReturnBackFrame:GetDescendants()) do
			if v:IsA("ImageButton") then
				TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(255,255,255)}):Play()
			end
		end
	end))
	self._maidConstructor:giveTask(ValidCommandFrame.ValidCompactableFrame.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
		if (string.match("teleport",ValidCommandFrame.ValidCompactableFrame.TextBox.Text)) then
			local t = string.match("teleport",ValidCommandFrame.ValidCompactableFrame.TextBox.Text)
			for i, frame in pairs(CmdsListFrame.ScrollingFrame:GetChildren()) do
				if frame.Name == string.match(frame.Name,ValidCommandFrame.ValidCompactableFrame.TextBox.Text) then
					print("caca")
					print(frame)
				elseif (frame.Name == string.find(frame.Name,ValidCommandFrame.ValidCompactableFrame.TextBox.Text)) then
					print("caca1")
					print(frame)
				end
			end
		end
	end))
	self._maidConstructor:giveTask(canvasGroup.PlayerListFrameCoutainer.ReturnBackFrame.MouseLeave:Connect(function()
		TweenService:Create(canvasGroup.PlayerListFrameCoutainer.ReturnBackFrame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(255,255,255)}):Play()
		TweenService:Create(canvasGroup.PlayerListFrameCoutainer.ReturnBackFrame.UIScale,TweenInfo.new(.15),{Scale = 1}):Play()
		TweenService:Create(canvasGroup.PlayerListFrameCoutainer.ReturnBackFrame,TweenInfo.new(.15),{BackgroundTransparency = 0.45,BackgroundColor3 = Color3.fromRGB(188,188,188)}):Play()
		for i,v in pairs(canvasGroup.PlayerListFrameCoutainer.ReturnBackFrame:GetDescendants()) do
			if v:IsA("ImageButton") then
				TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(0,0,0)}):Play()
			end
		end
	end))
	self._maidConstructor:giveTask(canvasGroup.PlayerListFrameCoutainer.ReturnBackFrame.ImageButton.MouseButton1Down:Connect(function()
		SoundService:PlayLocalSound(SoundService.gui_click)
		TweenService:Create(canvasGroup.PlayerListFrameCoutainer,TweenInfo.new(.15),{Position = UDim2.fromScale(1.5,.5)}):Play()
		TweenService:Create(canvasMain,TweenInfo.new(.15),{Position = UDim2.fromScale(0.5,0.5)}):Play()
	end))
	self._maidConstructor:giveTask(cmdsReturnToMain.MouseEnter:Connect(function()
		SoundService:PlayLocalSound(SoundService.ui_hover_ugd)
		TweenService:Create(cmdsReturnToMain.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(0,0,0)}):Play()
		TweenService:Create(cmdsReturnToMain.UIScale,TweenInfo.new(.15),{Scale = 0.9}):Play()
		TweenService:Create(cmdsReturnToMain,TweenInfo.new(.15),{BackgroundTransparency = 0.35,BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
		for i,v in pairs(cmdsReturnToMain:GetDescendants()) do
			if v:IsA("ImageButton") then
				TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(255,255,255)}):Play()
			end
		end
	end))
	self._maidConstructor:giveTask(cmdsReturnToMain.MouseLeave:Connect(function()
		TweenService:Create(cmdsReturnToMain.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(255,255,255)}):Play()
		TweenService:Create(cmdsReturnToMain.UIScale,TweenInfo.new(.15),{Scale = 1}):Play()
		TweenService:Create(cmdsReturnToMain,TweenInfo.new(.15),{BackgroundTransparency = 0.45,BackgroundColor3 = Color3.fromRGB(188,188,188)}):Play()
		for i,v in pairs(cmdsReturnToMain:GetDescendants()) do
			if v:IsA("ImageButton") then
				TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(0,0,0)}):Play()
			end
		end
	end))
	self._maidConstructor:giveTask(cmdsReturnToMain.ImageButton.MouseButton1Down:Connect(function()
		SoundService:PlayLocalSound(SoundService.gui_click)
		TweenService:Create(CmdsListFrame,TweenInfo.new(.15),{Position = UDim2.fromScale(1.5,.5)}):Play()
		TweenService:Create(canvasMain,TweenInfo.new(.15),{Position = UDim2.fromScale(0.5,0.5)}):Play()
	end))
	self._maidConstructor:giveTask(ReturnBackFrame.ImageButton.MouseButton1Down:Connect(function()
		SoundService:PlayLocalSound(SoundService.gui_click)
		TweenService:Create(CommandsFrameGroup,TweenInfo.new(.15),{Position = UDim2.fromScale(1.5,.5)}):Play()
		TweenService:Create(canvasMain,TweenInfo.new(.15),{Position = UDim2.fromScale(0.5,0.5)}):Play()
	end))
	self._maidConstructor:giveTask(ValidCommandFrame.ValidCompactableFrameExecution.TextButton.MouseButton1Down:Connect(function()
		if (ValidCommandFrame.ValidCompactableFrame.TextBox ~= "") then
			local splitTextBox = string.split(ValidCommandFrame.ValidCompactableFrame.TextBox.Text," - ")
			if table.find(commands,splitTextBox[1]) then
				print(table.concat(splitTextBox,"; "))
				return ReplicatedStorage.Coutainer.RE.ExecuteAdminCommand:FireServer({
					local_player = Players.LocalPlayer,
					Command = splitTextBox[1],
					RequiredArgument = splitTextBox[2],
					any = splitTextBox[3],
					RequiredCommandArgumentFromClient = splitTextBox[4],
					ifIsExist = splitTextBox[5],
					__any = splitTextBox[6]
				})
			end
		end
	end))
	self._maidConstructor:giveTask(ReturnBackFrame.MouseEnter:Connect(function()
		SoundService:PlayLocalSound(SoundService.ui_hover_ugd)
		TweenService:Create(ReturnBackFrame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(0,0,0)}):Play()
		TweenService:Create(ReturnBackFrame.UIScale,TweenInfo.new(.15),{Scale = 0.9}):Play()
		TweenService:Create(ReturnBackFrame,TweenInfo.new(.15),{BackgroundTransparency = 0.35,BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
		for i,v in pairs(ReturnBackFrame:GetDescendants()) do
			if v:IsA("ImageButton") then
				TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(255,255,255)}):Play()
			end
		end
	end))
	self._maidConstructor:giveTask(ReturnBackFrame.MouseLeave:Connect(function()
		TweenService:Create(ReturnBackFrame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(255,255,255)}):Play()
		TweenService:Create(ReturnBackFrame.UIScale,TweenInfo.new(.15),{Scale = 1}):Play()
		TweenService:Create(ReturnBackFrame,TweenInfo.new(.15),{BackgroundTransparency = 0.45,BackgroundColor3 = Color3.fromRGB(188,188,188)}):Play()
		for i,v in pairs(ReturnBackFrame:GetDescendants()) do
			if v:IsA("ImageButton") then
				TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(0,0,0)}):Play()
			end
		end
	end))
	if (not self.userInput) then
		self.userInput = UserInputService.InputBegan:Connect(function(input,gpe)
			if input.KeyCode == Enum.KeyCode.RightControl then
				if (GuiPanel.Enabled == true) then
					task.spawn(function()
						for i,emitter in folder:GetDescendants() do
							if emitter:IsA("ParticleEmitter") then
								Ui_emitter:RemoveEmitter(emitter)
							end
						end
					end)
					TweenService:Create(main,TweenInfo.new(.15),{BackgroundTransparency = 1}):Play()
					TweenService:Create(canvasGroup,TweenInfo.new(.15),{GroupTransparency = 1}):Play()
					task.delay(.25,onChangeVisibleUi,GuiPanel)
				else
					task.spawn(onChangeVisibleUi,GuiPanel)
					task.spawn(function()
						for i,emitter in folder:GetDescendants() do
							if emitter:IsA("ParticleEmitter") then
								Ui_emitter:AddEmitter(emitter)
							end
							task.wait(.1)
						end
					end)
					TweenService:Create(main,TweenInfo.new(.15),{BackgroundTransparency = 0.67}):Play()
					TweenService:Create(canvasGroup,TweenInfo.new(.15),{GroupTransparency = 0}):Play()
				end
			end
		end)
	end
	return Promise.new(function(resolve,reject,onCancel)
		if (self._clientStates == "enabled") then
			return warn("ui are already enable")
		else
			self._clientStates = ("enabled")
			for i,frame in pairs(canvasMain:GetChildren()) do
				if frame.ClassName ~= "Frame" then continue end
				table.insert(self._clientFunctions,frame.MouseEnter:Connect(function()
					SoundService:PlayLocalSound(SoundService.ui_hover_ugd)
					TweenService:Create(frame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(0,0,0)}):Play()
					TweenService:Create(frame.UIScale,TweenInfo.new(.15),{Scale = 0.9}):Play()
					TweenService:Create(frame:FindFirstChildOfClass("Frame"),TweenInfo.new(.15),{BackgroundTransparency = 0.35,BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
					TweenService:Create(frame:FindFirstChildOfClass("Frame").TextLabel,TweenInfo.new(.15),{TextColor3 = Color3.fromRGB(255,255,255)}):Play()
					for i,v in pairs(frame:FindFirstChildOfClass("Frame"):GetDescendants()) do
						if v:IsA("ImageLabel") then
							TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(255,255,255)}):Play()
						end
					end
				end))	
				table.insert(self._clientFunctions,frame:FindFirstChildOfClass("TextButton").MouseButton1Down:Connect(function()
					SoundService:PlayLocalSound(SoundService.gui_click)
					if frame.Name == PlayersMainFrame.Name then end
					if (frame.Name == "CommandsMainFrame") and ((CommandsFrameGroup.Position == UDim2.fromScale(.5,.5))) then 
						TweenService:Create(CommandsFrameGroup,TweenInfo.new(.15),{Position = UDim2.fromScale(1.5,.5)}):Play()
						TweenService:Create(canvasMain,TweenInfo.new(.15),{Position = UDim2.fromScale(0.5,0.5)}):Play()
					elseif (frame.Name == "CommandsMainFrame") and ((CommandsFrameGroup.Position ~= UDim2.fromScale(0.5,.5))) then
						TweenService:Create(CommandsFrameGroup,TweenInfo.new(.15),{Position = UDim2.fromScale(0.5,.5)}):Play()
						TweenService:Create(canvasMain,TweenInfo.new(.15),{Position = UDim2.fromScale(1.5,0.5)}):Play()
					elseif (frame.Name == "CmdsFrame") and ((CmdsListFrame.Position == UDim2.fromScale(.5,.5))) then
						TweenService:Create(CmdsListFrame,TweenInfo.new(.15),{Position = UDim2.fromScale(1.5,.5)}):Play()
						TweenService:Create(canvasMain,TweenInfo.new(.15),{Position = UDim2.fromScale(0.5,0.5)}):Play()
					elseif (frame.Name == "CmdsFrame") and ((CmdsListFrame.Position ~= UDim2.fromScale(.5,.5))) then
						TweenService:Create(CmdsListFrame,TweenInfo.new(.15),{Position = UDim2.fromScale(0.5,.5)}):Play()
						TweenService:Create(canvasMain,TweenInfo.new(.15),{Position = UDim2.fromScale(1.5,0.5)}):Play()
					elseif (frame.Name == PlayersMainFrame.Name) and canvasGroup.PlayerListFrameCoutainer.Position == UDim2.fromScale(1.5,0.5) then
						TweenService:Create(canvasGroup.PlayerListFrameCoutainer,TweenInfo.new(.15),{Position = UDim2.fromScale(0.5,.5)}):Play()
						TweenService:Create(canvasMain,TweenInfo.new(.15),{Position = UDim2.fromScale(1.5,0.5)}):Play()
					elseif (frame.Name == PlayersMainFrame.Name) and ((canvasGroup.PlayerListFrameCoutainer.Position ~= UDim2.fromScale(.5,.5))) then
						TweenService:Create(canvasGroup.PlayerListFrameCoutainer,TweenInfo.new(.15),{Position = UDim2.fromScale(1.5,.5)}):Play()
						TweenService:Create(canvasMain,TweenInfo.new(.15),{Position = UDim2.fromScale(0.5,0.5)}):Play()
					end
				end))
				table.insert(self._clientFunctions,frame.MouseLeave:Connect(function()
					TweenService:Create(frame.UIStroke,TweenInfo.new(.15),{Color = Color3.fromRGB(253, 253, 253)}):Play()
					TweenService:Create(frame.UIScale,TweenInfo.new(.15),{Scale = 1}):Play()
					TweenService:Create(frame:FindFirstChildOfClass("Frame"),TweenInfo.new(.15),{BackgroundTransparency = 0.45,BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
					TweenService:Create(frame:FindFirstChildOfClass("Frame").TextLabel,TweenInfo.new(.15),{TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
					for i,v in pairs(frame:FindFirstChildOfClass("Frame"):GetDescendants()) do
						if v:IsA("ImageLabel") then
							TweenService:Create(v,TweenInfo.new(.15),{ImageColor3 = Color3.fromRGB(0, 0, 0)}):Play()
						end
					end
				end))
			end
			resolve(self._clientFunctions)
		end
	end)
end

function controller:changeExecutionState(message:string)
	local playerGui = Players.LocalPlayer.PlayerGui
	local GuiPanel = playerGui:WaitForChild("ScreenGui")
	local main = GuiPanel:WaitForChild("main")
	local canvasGroup = main.CanvasGroup
	local folder:Folder = main.Emitters
	local canvasMain = canvasGroup.main
	local CommandsFrameGroup = canvasGroup.CommandsFrameGroup
	local OutputFrame = CommandsFrameGroup.OutputFrame_StudioReceivedAnyMessageHere
	local DescribingCommand = OutputFrame.DescribingCommand.TextLabel
	if (message) then
		DescribingCommand.Text = message
	else
		DescribingCommand.Text = "return the result of the current command passed: States <Succes / Executed>, <Failed> , <OnResolve [resolving issue] >"
	end
end

function controller:CreatePlayersListCoutainer()
	local playerGui = Players.LocalPlayer.PlayerGui
	local GuiPanel = playerGui:WaitForChild("ScreenGui")
	local main = GuiPanel:WaitForChild("main")
	local canvasGroup = main.CanvasGroup
	local canvasMain = canvasGroup.main
	self.secureMaid = Maid.new()
	local PlayerListFrameCoutainer = canvasGroup.PlayerListFrameCoutainer
	for i,player in pairs(Players:GetPlayers()) do
		local frame = script.__index:Clone()
		frame.Parent = PlayerListFrameCoutainer
		self.secureMaid:giveTask(frame.players.kick.MouseEnter:Connect(function()
			TweenService:Create(frame.players.kick,TweenInfo.new(.15),{BackgroundTransparency = 0, BackgroundColor3 = Color3.new(0,0,0)}):Play()
			TweenService:Create(frame.players.kick.UIScale,TweenInfo.new(.15),{Scale = .9}):Play()
			TweenService:Create(frame.players.kick.UIStroke,TweenInfo.new(.15),{Color = Color3.new(0,0,0)}):Play()
			TweenService:Create(frame.players.kick.text,TweenInfo.new(.15),{TextColor3 = Color3.fromRGB(255,255,255)}):Play()
		end))
		self.secureMaid:giveTask(frame.players.kick.MouseLeave:Connect(function()
			TweenService:Create(frame.players.kick,TweenInfo.new(.15),{BackgroundTransparency = .45, BackgroundColor3 = Color3.new(1,1,1)}):Play()
			TweenService:Create(frame.players.kick.UIScale,TweenInfo.new(.15),{Scale = 1}):Play()
			TweenService:Create(frame.players.kick.UIStroke,TweenInfo.new(.15),{Color = Color3.new(1,1,1)}):Play()
			TweenService:Create(frame.players.kick.text,TweenInfo.new(.15),{TextColor3 = Color3.fromRGB(0,0,0)}):Play()
		end))
		self.secureMaid:giveTask(frame.players.kick:FindFirstChildOfClass("TextButton").MouseButton1Down:Connect(function()
			return ReplicatedStorage.Coutainer.RE.ExecuteAdminCommand:FireServer({
				Command = "kick",
				RequiredArgument = player.Name,
			})
		end))
		self.secureMaid:giveTask(frame.players.tp.MouseEnter:Connect(function()
			TweenService:Create(frame.players.tp,TweenInfo.new(.15),{BackgroundTransparency = 0, BackgroundColor3 = Color3.new(0,0,0)}):Play()
			TweenService:Create(frame.players.tp.UIScale,TweenInfo.new(.15),{Scale = .9}):Play()
			TweenService:Create(frame.players.tp.UIStroke,TweenInfo.new(.15),{Color = Color3.new(0,0,0)}):Play()
			TweenService:Create(frame.players.tp.text,TweenInfo.new(.15),{TextColor3 = Color3.fromRGB(255,255,255)}):Play()
		end))
		self.secureMaid:giveTask(frame.players.tp.MouseLeave:Connect(function()
			TweenService:Create(frame.players.tp,TweenInfo.new(.15),{BackgroundTransparency = .45, BackgroundColor3 = Color3.new(1,1,1)}):Play()
			TweenService:Create(frame.players.tp.UIScale,TweenInfo.new(.15),{Scale = 1}):Play()
			TweenService:Create(frame.players.tp.UIStroke,TweenInfo.new(.15),{Color = Color3.new(1,1,1)}):Play()
			TweenService:Create(frame.players.tp.text,TweenInfo.new(.15),{TextColor3 = Color3.fromRGB(0,0,0)}):Play()
		end))
		self.secureMaid:giveTask(frame.players.tp:FindFirstChildOfClass("TextButton").MouseButton1Down:Connect(function()
			return ReplicatedStorage.Coutainer.RE.ExecuteAdminCommand:FireServer({
				Command = "teleport",
				RequiredArgument = Players.LocalPlayer.Name,
				any = player.Name
			})
		end))
		self.secureMaid:giveTask(frame.players.quickban.MouseEnter:Connect(function()
			TweenService:Create(frame.players.quickban,TweenInfo.new(.15),{BackgroundTransparency = 0, BackgroundColor3 = Color3.new(0,0,0)}):Play()
			TweenService:Create(frame.players.quickban.UIScale,TweenInfo.new(.15),{Scale = .9}):Play()
			TweenService:Create(frame.players.quickban.UIStroke,TweenInfo.new(.15),{Color = Color3.new(0,0,0)}):Play()
			TweenService:Create(frame.players.quickban.text,TweenInfo.new(.15),{TextColor3 = Color3.fromRGB(255,255,255)}):Play()
		end))
		self.secureMaid:giveTask(frame.players.quickban.MouseLeave:Connect(function()
			TweenService:Create(frame.players.quickban,TweenInfo.new(.15),{BackgroundTransparency = .45, BackgroundColor3 = Color3.new(1,1,1)}):Play()
			TweenService:Create(frame.players.quickban.UIScale,TweenInfo.new(.15),{Scale = 1}):Play()
			TweenService:Create(frame.players.quickban.UIStroke,TweenInfo.new(.15),{Color = Color3.new(1,1,1)}):Play()
			TweenService:Create(frame.players.quickban.text,TweenInfo.new(.15),{TextColor3 = Color3.fromRGB(0,0,0)}):Play()
		end))
		self.secureMaid:giveTask(frame.players.quickban:FindFirstChildOfClass("TextButton").MouseButton1Down:Connect(function()
			return ReplicatedStorage.Coutainer.RE.ExecuteAdminCommand:FireServer({
				Command = "Timeban",
				RequiredArgument = Players.LocalPlayer.Name,
				any = "1",
				RequiredCommandArgumentFromClient = "banned for 1 day."
			})
		end))
		frame.playersImages.p2.Image = Players:GetUserThumbnailAsync(player.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
		frame.players.plrName.Text = "Id: " .. (player.UserId) .. ", @"..player.Name	
	end
end

function controller:enable_ui(data,commands)
	self.OnStart = _enable(self,data,commands):andThen(function(getFn)
		self:CreatePlayersListCoutainer()
		return warn(`<Client - Admin Panel Controller -> {table.unpack(getFn)}`.."'s  are now active.")
	end):catch(warn)
	return self.OnStart
end

return controller
