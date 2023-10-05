--[[

Made by Rouxhaver

Wear this hat: https://www.roblox.com/catalog/617605556/Medieval-Hood-of-Mystery

And 9 of these: https://www.roblox.com/catalog?Keyword=fedora&Category=11&CurrencyType=3&pxMin=0&pxMax=0&salesTypeFilter=1&SortType=2&SortAggregation=5

]]

LocalPlayer = game:GetService("Players").LocalPlayer
RunService = game:GetService("RunService")

Snake = Instance.new("Model", workspace)
Snake.Name = "Snake"

SnakeControl = Instance.new("Model", Snake)
SnakeControl.Name = "SnakeControl"

SegmentCount = 9
LastSegment = nil
for i = 1, SegmentCount, 1 do
	local Segment = Instance.new("Part", Snake)
	Segment.Name = "Segment"..tostring(i)
	Segment.Size = Vector3.new(1,1,1.8)
	Segment.Transparency = 1
	
	local FrontAttachment = Instance.new("Attachment", Segment)
	FrontAttachment.Name = "FrontAttachment"
	FrontAttachment.CFrame = CFrame.new(0,0,.9)
	
	local BackAttachment = Instance.new("Attachment", Segment)
	BackAttachment.Name = "BackAttachment"
	BackAttachment.CFrame = CFrame.new(0,0,-.9)
	
	local BallSocket = Instance.new("BallSocketConstraint", Segment)
	BallSocket.Name = "BallSocket"
	BallSocket.Attachment1 = FrontAttachment
	
	if LastSegment then
		BallSocket.Attachment0 = LastSegment.BackAttachment
	end
	
	LastSegment = Segment
end

Head = Instance.new("Part", SnakeControl)
Head.Name = "HumanoidRootPart"
Head.Size = Vector3.new(1,1,1)
Head.CustomPhysicalProperties = PhysicalProperties.new(100,0.5,1,0.3,1)
Head.Transparency = 1

Neck = Instance.new("Attachment", Head)
Neck.CFrame = CFrame.new(0,0,.5)

Snake.Segment1.BallSocket.Attachment0 = Neck

Humanoid = Instance.new("Humanoid", SnakeControl)
Humanoid.HipHeight = .25

--Move Accessorys
Character = nil

function Loop(Number,Code)
	for i = 1, Number, 1 do
		Code()
	end
end

TailHats = {}

function ResetCharacter()
	if LocalPlayer.Character == SnakeControl then return end
	table.clear(TailHats)
	Character = LocalPlayer.Character
	task.wait()
	LocalPlayer.Character = SnakeControl
	Character:WaitForChild("HumanoidRootPart").CFrame = Head.CFrame + Vector3.new(7,0,0)
	Loop(17, function()
		task.wait()
	end)
	
	Character:BreakJoints()
	
	while true do
		local Count = 0
		for i,v in pairs(Character:GetChildren()) do
			if v:IsA("Accessory") then
				Count += 1
			end
		end
		if Count == 10 then break end
		task.wait()
	end
	
	for i,v in pairs(Character:GetDescendants()) do
		if v.Name == "International Fedora" or v.Name == "InternationalFedora" or v.Name == "MeshPartAccessory" then
			table.insert(TailHats, v.Handle)
		end
	end
end

RunService.Heartbeat:Connect(function()
	if Character == nil or not Character:FindFirstChild("MediHood") or #TailHats ~= 9 then return end
	Character.MediHood.Handle.CFrame = Head.CFrame + Vector3.new(0,math.sin(tick()*30)*.01)
	Character.MediHood.Handle.Velocity = Vector3.new(0,25.1)
	for i, v in pairs(TailHats) do
		v.CFrame = Snake["Segment"..tostring(i)].CFrame + Vector3.new(0,math.sin(tick()*30)*.01)
		v.Velocity = Vector3.new(0,25.1)
	end
end)
ResetCharacter()

LocalPlayer.CharacterAdded:Connect(ResetCharacter)

Camera = workspace.CurrentCamera

RememberCFrame = CFrame.new()
RunService.RenderStepped:Connect(function()
	if Camera.CameraSubject ~= Head then
		Camera.CameraSubject = Head
		Camera.CFrame = RememberCFrame
	end
	RememberCFrame = Camera.CFrame
end)
