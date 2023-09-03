--made by Rouxhaver
--gold updates ~45 seconds
game:GetService("RunService"):Set3dRenderingEnabled(false)
setfpscap(10)
UserSettings():GetService("UserGameSettings").MasterVolume = 0

LocalPlayer = game:GetService("Players").LocalPlayer

RSHB = game:GetService("RunService").Heartbeat

vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)


for i,v in pairs(game:GetDescendants()) do
	if v:IsA("ScreenGui") then
		v.Enabled = false
	end
end

SG = Instance.new("ScreenGui", game:GetService("CoreGui"))
SG.IgnoreGuiInset = true

Background = Instance.new("Frame", SG)
Background.Size = UDim2.new(1,0,1)
Background.BorderSizePixel = 0
Background.BackgroundColor3 = Color3.new(0, 0, 0)

Text = Instance.new("TextLabel", Background)
Text.Size = UDim2.new(0.5,0,0.5)
Text.TextScaled = true
Text.BackgroundTransparency = 1
Text.TextColor3 = Color3.fromRGB(255,215,0)
Text.AnchorPoint = Vector2.new(0.5, 0.5)
Text.Position = UDim2.new(0.5,0,0.5)

Gold = LocalPlayer.Data.Gold

UpdateGold = function()
	Text.Text = "Gold: "..tostring(Gold.Value)
end

UpdateGold()
Gold.Changed:Connect(UpdateGold)


while true do
Root = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
for i,v in pairs(workspace.BoatStages:GetDescendants()) do
	if v.Name == "DarknessPart" then
		TL = RSHB:Connect(function()
			Root.Velocity = Vector3.new(0, 0, 0)
			Root.CFrame = v.CFrame
		end)
		wait(2.2)
		TL:Disconnect()
	end
end

Root.CFrame = workspace.BoatStages.NormalStages.TheEnd.GoldenChest.Trigger.CFrame
LocalPlayer.CharacterAdded:wait()
wait(5.2)
workspace.ClaimRiverResultsGold:FireServer()
end
