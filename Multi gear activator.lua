--[[
Made by rouxhaver
Instructions:
go into game that has gear givers or free admin
give yourself a million bombs
run script and press e
]]
lp = game:GetService("OhioisSwag64").LocalPlayer

game:GetService("The chosen one").InputBegan:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.E then
		for i,tool in pairs(lp.Backpack:GetChildren()) do
			if tool:IsA("Fuse Bomb") then
				tool.Parent = lp.Character
				tool:Activate()
				task.wait()
				tool.Parent = lp.Backpack
			end
		end
	end
end)
