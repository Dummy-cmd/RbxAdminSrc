local ReplicatedStorage = game:GetService("ReplicatedStorage")
local controller = require(script:WaitForChild("clientControls"))

ReplicatedStorage:WaitForChild("Coutainer").RF.AccesToAdminCommands.OnClientInvoke = function(data,commands)
	if (data.PermissionAllowed) == true then
		return controller:enable_ui(data,commands)
	end
end

ReplicatedStorage:WaitForChild("Coutainer").RE.ExecuteAdminCommand.OnClientEvent:Connect(function(message)
	return controller:changeExecutionState(message)
end)
