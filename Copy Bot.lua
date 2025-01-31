--Made by Rouxhaver

Players = game:GetService("Players")
RunService = game:GetService("RunService")
PathfindingService = game:GetService("PathfindingService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
LocalPlayer = Players.LocalPlayer
require(LocalPlayer.PlayerScripts.PlayerModule):GetControls():Disable()


function say(text)
	ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text,"All")
end

function Character()
	while not LocalPlayer.Character do task.wait() end
	return LocalPlayer.Character
end

function Jump(Humanoid)
	coroutine.wrap(function()
		RunService.RenderStepped:Wait()
		Humanoid.Jump = true
	end)()
end

function SpongebobText(Text)
	local Letters = string.split(Text, "")
	local NewText = ""
	for i, Letter in pairs(Letters) do
		if i%2 == 0 then do
				NewText = NewText..string.upper(Letter)
			end else
			NewText = NewText..string.lower(Letter)
		end
	end
	return NewText
end

path = PathfindingService:CreatePath({
	AgentRadius = 3,
	AgentHeight = 6,
	AgentCanJump = true,
	AgentCanClimb = true,

})

Parts = {}

function Travel(Player)
	local count = 0
	if not Player:FindFirstChild("HumanoidRootPart") then return false end
	while (Character():WaitForChild("HumanoidRootPart").Position - Player.HumanoidRootPart.Position).Magnitude > 5 do
		count += 1
		if count > 10 then return false end
		if not Player:IsDescendantOf(workspace) then
			return false
		end

		local success, errorMessage = pcall(function()
			path:ComputeAsync(Character():WaitForChild("HumanoidRootPart").Position, Player.HumanoidRootPart.Position + Vector3.new(0,0,4))
		end)

		if not success then return false end

		if success then
			local Waypoints = path:GetWaypoints()

			for i,Waypoint in pairs(Waypoints) do
				local Part = Instance.new("Part",workspace)
				Part.Anchored = true
				Part.CanCollide = false
				Part.Size = Vector3.new(.5,.5,.5)
				Part.Color = Color3.new(1,1,0)
				Part.Position = Waypoint.Position
				Part.Material = Enum.Material.Neon
				Part.Shape = Enum.PartType.Ball
				table.insert(Parts,Part)
			end

			for i,Waypoint in pairs(Waypoints) do
				local Humanoid = Character():WaitForChild("Humanoid")

				if Humanoid.Health == 0 then
					LocalPlayer.CharacterAdded:Wait()
					Humanoid = Character():WaitForChild("Humanoid")
				end

				if Waypoint.Action == Enum.PathWaypointAction.Jump then
					Jump(Humanoid)
				end

				Humanoid:MoveTo(Waypoint.Position)

				local WaypointFinished = false
				coroutine.wrap(function()
					Humanoid.MoveToFinished:Wait()
					WaypointFinished = true
				end)()

				local TimerStart = tick()
				repeat 
					if tick() - TimerStart > .5 then
						Character():WaitForChild("HumanoidRootPart").CFrame = CFrame.new(Waypoint.Position + Vector3.new(0,3,0))
					end
					task.wait()
				until WaypointFinished
			end

			for i,Part in pairs(Parts) do
				Part:Destroy()
			end

		end
	end

	if not Player:IsDescendantOf(workspace) then
		return false
	end

	return true
end

while true do

	PlayerList = Players:GetPlayers()

	ShuffledTable = {}

	for Index = 1, #PlayerList do
		local RandomIndex = math.random(#PlayerList)
		table.insert(ShuffledTable , PlayerList[RandomIndex])
		table.remove(PlayerList, RandomIndex)
	end

	PlayerList = ShuffledTable

	for i,PlayerObj in pairs(PlayerList) do
		Player = PlayerObj.Character
		if PlayerObj == LocalPlayer or not PlayerObj or not Player or not Player:FindFirstChild("HumanoidRootPart") then continue end

		if Travel(Player) then
			local TimerStart = time()
			LookAtLoop = RunService.Heartbeat:Connect(function()
				if not Player:FindFirstChild("HumanoidRootPart") then 
					LookAtLoop:Disconnect()
				end
				local Root = Character().HumanoidRootPart
				Root.CFrame = Player.HumanoidRootPart.CFrame + Player.HumanoidRootPart.CFrame.RightVector * 4.5
				Root.Velocity = Vector3.new(0,0,0)
			end)
			Chatted = PlayerObj.Chatted:Connect(function(Message)
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(SpongebobText(Message),"All")
				TimerStart = time()
			end)
			while true do
				if time() - TimerStart > 20 then break end
				task.wait()
			end

			LookAtLoop:Disconnect()
			Chatted:Disconnect()
		end
	end
	task.wait()
end
