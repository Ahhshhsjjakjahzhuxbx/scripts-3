--[[
Made by Rouxhaver
Thank you Amity https://v3rmillion.net/showthread.php?tid=1216703

Place script in your auto-execute folder and join game
Expect a lot of server changing
]]
wait(5)

Players = game:GetService("Players")
RunService = game:GetService("RunService")

httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
function Shop()
	local servers = {}
	local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100", game.PlaceId)})
	local body = game:GetService("HttpService"):JSONDecode(req.Body)
	if body and body.data then
		for i, v in next, body.data do
			if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
				table.insert(servers, 1, v.id)
			end
		end
	end
	if #servers > 0 then
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
	else
		return notify("Serverhop", "Couldn't find a server.")
	end
end

local CommunicationRemote,EventTable = (function()
for i,v in getgc(false) do
if type(v) == "function" and islclosure(v) and debug.info(v,"n") == "EventFireServer" then
local upvalues = debug.getupvalues(v)
if typeof(upvalues[2]) == "Instance" and type(upvalues[3]) == "table" then
return cloneref(upvalues[2]),upvalues[3]
end
end
end
end)()

if not (CommunicationRemote and EventTable) then
Shop()
end

local Ignorelist = OverlapParams.new()
local ArrestAddress = rawget(EventTable,"zoosvaoh")
local FalldamageAddress = rawget(EventTable,"hs8xl0oe")
local EjectAddress = rawget(EventTable,"qy0rcas6")
local EnterCarAddress = rawget(EventTable,"dn11dr2z")
local ExitCarAddress = rawget(EventTable,"mu1vykrd")
local PickTeamAddress = rawget(EventTable,"qc3drmhh")
local LockCarAddress = rawget(EventTable,"tz29mz5x")

EventTable = nil

local FireServer; FireServer = hookfunction(Instance.new("RemoteEvent").FireServer, function(self, ...)
    Args = {...}
    if Args[1] == FalldamageAddress then
    	return FireServer(self, FalldamageAddress, 0)
    end
    return FireServer(self, ...)
end)

ReplicatedStorage = game:GetService("ReplicatedStorage")

CommunicationRemote:FireServer(PickTeamAddress,"Police")
wait(1)
ReplicatedStorage:WaitForChild("SpawnSelectionUpdateSpawnData"):FireServer()
ReplicatedStorage:WaitForChild("SpawnSelectionSelect"):FireServer("Military Base")
wait(2)
workspace.Vehicles:WaitForChild("Jeep")
JeepCheck = false
spawn(function()
	wait(5)
	if not JeepCheck then
		Shop()
	end
end)
for i,v in pairs(workspace.Vehicles:GetChildren()) do
	if v.Name == "Jeep" then
		CommunicationRemote:FireServer(EnterCarAddress, v, v.Seat)
	end
end
spawn(function()
	wait(2)
	CommunicationRemote:FireServer(LockCarAddress, true)
end)

LocalPlayer = Players.LocalPlayer
Character = LocalPlayer.Character
Root = Character.HumanoidRootPart

CarSeat = Root:WaitForChild("Weld").Part1
Car = CarSeat.Parent

JeepCheck = true

function ExitCar()
	CommunicationRemote:FireServer(ExitCarAddress)
end

function EnterCar()
	Character.Humanoid.Sit = true

	local PPosition = Vector3.new(Root.Position.X, 500, Root.Position.Z)
	local CPosition = Vector3.new(CarSeat.Position.X, 500, CarSeat.Position.Z)
	
   	local Distance = (PPosition - CPosition).Magnitude
   	local Steps = math.ceil(Distance/10)
   	for i = 1, Steps, 1 do
   		Root.CFrame = CFrame.new(PPosition:Lerp(CPosition, 1/Steps*i))
   		Root.Velocity = Vector3.new()
   		wait(.1)
   	end
	wait(.2)
	Root.CFrame = CarSeat.CFrame + Vector3.new(0,10)
	Character.Humanoid.Sit = false
	wait(.5)
	CommunicationRemote:FireServer(EnterCarAddress, Car, CarSeat)
	Root:WaitForChild("Weld")
end

function MoveCar(Position)
	for i,v in pairs(Root:GetConnectedParts(true)) do
		v.CFrame = Position
		v.Velocity = Vector3.new(0,0,0)
	end
end

function Arrest(Player)
	if not Player.Character then return end
	ARoot = Player.Character.HumanoidRootPart
	Follow = RunService.Heartbeat:Connect(function()
		Root.CFrame = ARoot.CFrame + ARoot.CFrame.LookVector * -6
		if not CheckForRoof(Player) then
			Follow:disconnect()
		end
	end)
	if ARoot:FindFirstChild("Weld") then
		for i,v in pairs(workspace.Vehicles:GetChildren()) do
			CommunicationRemote:FireServer(EjectAddress,v)
		end
	end
	Root.CFrame = ARoot.CFrame + Vector3.new(0,5)
	wait(1)
	for i = 1, 5, 1 do
		CommunicationRemote:FireServer(ArrestAddress, Player.Name)
		wait(.2)
	end
	Follow:disconnect()
end

function Handcuffs(Player)
	LocalPlayer.Folder.Handcuffs.InventoryEquipRemote:FireServer(true)
end

function CheckForRoof(Player)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = Player.Character.HumanoidRootPart:GetConnectedParts(true)
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	local Raycast = workspace:Raycast(Player.Character.HumanoidRootPart.Position, Vector3.new(0, 100, 0), raycastParams)
	if not Raycast then
		return true
	end
	return false
end

LastTarget = nil

Running = true
while Running do
	Criminals = {}
	for i,Player in pairs(Players:GetPlayers()) do
		if Player and Player.Team.Name == "Criminal" and Player.Character:FindFirstChild("HumanoidRootPart") and Player ~= LastTarget then
			if CheckForRoof(Player) then
				table.insert(Criminals, Player)
			end
		end
	end
	-- if you're reading this please dm me an image of a spoon
	if #Criminals < 2 then
		Shop()
	end
	
	Target = nil
	ShortestDistance = 10000
	for i,Criminal in pairs(Criminals) do
		local CRoot = Criminal.Character.HumanoidRootPart
		local Distance = (Root.Position - CRoot.Position).Magnitude
		if Distance < ShortestDistance then
			ShortestDistance = Distance
			Target = Criminal
		end
	end
	if Target then
		TRoot = Target.Character.HumanoidRootPart
	
		TPosition = Vector3.new(TRoot.Position.X, 500, TRoot.Position.Z)
		PPosition = Vector3.new(Root.Position.X, 500, Root.Position.Z)
		Distance = (PPosition - TPosition).Magnitude
	
		Steps = math.ceil(Distance/25)
		MoveCar(CFrame.new(PPosition:Lerp(TPosition, 1/Steps)))
		wait(.05)
	
		if Distance < 5 then
			LastTarget = Target
			MoveCar(TRoot.CFrame + TRoot.CFrame.LookVector * -10)
			wait(.5)
			ExitCar()
			wait(.5)
			Handcuffs()
			Arrest(Target)
			wait(2)
			local EnterCarCheck = false
			spawn(function()
				wait(10)
				if not EnterCarCheck then
					Shop()
				end
			end)
			EnterCar()
			EnterCarCheck = true
		end
	end
	task.wait()
end
