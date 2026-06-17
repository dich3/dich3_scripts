_G.Settings = {
	AutoBoss = false,
}

local Config = {
	Rooms = {
		Boss = {
			DoorPos = nil,
            BigChest = nil,
            Chests = {
                MiniChest = {
                    Pos = {},
                    CheckPart = {},
                },
            },
		},
		TitanicEgg = {
			DoorPos = nil,
		},
	},
}

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Window", "DarkTheme")

local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Main")

MainSection:NewKeybind("Toggle UI", "", Enum.KeyCode.Y, function()
	Library:ToggleUI()
end)


local TpTab = Window:NewTab("Teleports")
local TpSection = TpTab:NewSection("Teleports")

local MiniBossReady = TpSection:NewLabel('Status: <font color="rgb(255,0,0)">Not Ready</font>')

TpSection:NewButton("Tp to MiniBoss", "", function()
    if not Config.Rooms.Boss then return end
	character.HumanoidRootPart.CFrame = CFrame.new(Config.Rooms.Boss.DoorPos)
end)

local TitanicEggReady = TpSection:NewLabel('Status: <font color="rgb(255,0,0)">Not Ready</font>')

TpSection:NewButton("Tp to Titanic Egg", "", function()
    if not Config.Rooms.Boss then return end
	character.HumanoidRootPart.CFrame = CFrame.new(Config.Rooms.TitanicEgg.DoorPos)
end)

local BossTab = Window:NewTab("Boss")
local Chests = BossTab:NewSection("Chests")

Chests:NewToggle("Auto Boss (experimental)", "Make sure the teleport status is Ready and the door is opened.", function(state)
    _G.Settings.AutoBoss = state
    while _G.Settings.AutoBoss do
        print("loop")
        local restartWhile = false

        for i, v in Config.Rooms.Boss.Chests.MiniChest.CheckPart do
            if restartWhile then break end

            local OverlapParams = OverlapParams.new()
            OverlapParams.IncludeInstances = workspace.__THINGS.Breakables:GetChildren()

            local ActiveChests = workspace:GetPartBoundsInBox(v.CFrame, v.Size, OverlapParams)

            for _, v2 in ActiveChests do
                if (v2.Position - character.HumanoidRootPart.Position).Magnitude <= 10 then 
                    restartWhile = true
                    break 
                end
                if v2:IsA("Part") then
                    print(v2:GetFullName())
                    character.HumanoidRootPart.CFrame = CFrame.new(Config.Rooms.Boss.DoorPos)
                    task.wait(0.5)
                    character.HumanoidRootPart.CFrame = CFrame.new(v2.Position + Vector3.new(0, 5, 0))
                    restartWhile = true

                    break 
                end
            end

            if restartWhile then break else character.HumanoidRootPart.CFrame = CFrame.new(Config.Rooms.Boss.BigChest + Vector3.new(0, 5, 0)) end
        end

        task.wait(2)
    end
end)



Chests:NewButton("Big Chest", "", function()
    if not Config.Rooms.Boss.BigChest then return end
	character.HumanoidRootPart.CFrame = CFrame.new(Config.Rooms.Boss.BigChest + Vector3.new(0, 5, 0))
end)

for _, v in workspace.__THINGS.__INSTANCE_CONTAINER.Active.Backrooms.GeneratedBackrooms:GetChildren() do
	if v.Name == "MiniBossRoom" and not Config.Rooms.Boss.DoorPos then
        MiniBossReady:UpdateLabel('Status: <font color="rgb(0,255,0)">Ready</font>')

		Config.Rooms.Boss.DoorPos = v.LockedDoors.Door.Animated.Part.Position

		Config.Rooms.Boss.BigChest = v.BREAK_ZONE.Position

		local ChestList = v.MiniChestSpawnPoints:GetChildren()
        for i2, v2 in v.MiniChestSpawnPoints:GetChildren() do
            table.insert(Config.Rooms.Boss.Chests.MiniChest.Pos, v2.Position)

            Chests:NewButton("Chest " .. i2, "", function()
                character.HumanoidRootPart.CFrame = CFrame.new(Config.Rooms.Boss.DoorPos)
                task.wait(0.5)
                character.HumanoidRootPart.CFrame = CFrame.new(Config.Rooms.Boss.Chests.MiniChest.Pos[i2] + Vector3.new(0, 5, 0))
            end)

            local CheckPart = Instance.new("Part")
            CheckPart.Anchored = true
            CheckPart.CanCollide = false
            CheckPart.Parent = workspace
            CheckPart.Size = Vector3.new(1, 5, 1)
            CheckPart.Position = v2.Position + Vector3.new(0, 3, 0)

            table.insert(Config.Rooms.Boss.Chests.MiniChest.CheckPart, CheckPart:Clone())
        end

        
	elseif v.Name == "TitanicEggRoom" then
        TitanicEggReady:UpdateLabel('Status: <font color="rgb(0,255,0)">Ready</font>')
		Config.Rooms.TitanicEgg.DoorPos = v.AccessPoints.ANY.Position
	end
end

workspace.__THINGS.__INSTANCE_CONTAINER.Active.Backrooms.GeneratedBackrooms.ChildAdded:Connect(function(v)
	if v.Name == "MiniBossRoom" and not Config.Rooms.Boss.DoorPos then
        MiniBossReady:UpdateLabel('Status: <font color="rgb(0,255,0)">Ready</font>')

		Config.Rooms.Boss.DoorPos = v.LockedDoors.Door.Animated.Part.Position

		Config.Rooms.Boss.BigChest = v.BREAK_ZONE.Position

		local ChestList = v.MiniChestSpawnPoints:GetChildren()
        for i2, v2 in v.MiniChestSpawnPoints:GetChildren() do
            table.insert(Config.Rooms.Boss.Chests.MiniChest.Pos, v2.Position)

            Chests:NewButton("Chest " .. i2, "", function()
                character.HumanoidRootPart.CFrame = CFrame.new(Config.Rooms.Boss.DoorPos)
                task.wait(0.5)
                character.HumanoidRootPart.CFrame = CFrame.new(Config.Rooms.Boss.Chests.MiniChest.Pos[i2] + Vector3.new(0, 5, 0))
            end)

            local CheckPart = Instance.new("Part")
            CheckPart.Anchored = true
            CheckPart.CanCollide = false
            CheckPart.Parent = workspace
            CheckPart.Size = Vector3.new(1, 5, 1)
            CheckPart.Position = v2.Position + Vector3.new(0, 3, 0)

            table.insert(Config.Rooms.Boss.Chests.MiniChest.CheckPart, CheckPart:Clone())
        end

        
	elseif v.Name == "TitanicEggRoom" then
        TitanicEggReady:UpdateLabel('Status: <font color="rgb(0,255,0)">Ready</font>')
		Config.Rooms.TitanicEgg.DoorPos = v.AccessPoints.ANY.Position
	end
end)
