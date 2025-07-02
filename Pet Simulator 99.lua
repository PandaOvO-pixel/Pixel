repeat task.wait() until game:IsLoaded()

--Reduce GPU
local UserInputService, RunService = game:GetService("UserInputService"), game:GetService("RunService")
UserInputService.WindowFocusReleased:Connect(function()
	RunService:Set3dRenderingEnabled(false); setfpscap(5)
end)
UserInputService.WindowFocused:Connect(function()
	RunService:Set3dRenderingEnabled(true); setfpscap(360)
end)


local Players = game:GetService("Players")
local player = Players.LocalPlayer
repeat task.wait() until not player.PlayerGui:FindFirstChild("__INTRO")

-- Services / Helpers path - more tidy and fast ig/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InstancingCmds = require(ReplicatedStorage:WaitForChild("Library"):WaitForChild("Client"):WaitForChild("InstancingCmds"))
local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)
local Network = require(ReplicatedStorage.Library.Client.Network)
local GetMaxEggsToHatch = EggCmds.GetMaxHatch()

-- Remotes
local Train = ReplicatedStorage.Network:WaitForChild("InfiniteGym_Train")
local Start = ReplicatedStorage.Network:WaitForChild("InfiniteGym_Start")
local ZonePurchase = ReplicatedStorage.Network:WaitForChild("InstanceZones_RequestPurchase")
local GymRebirth = ReplicatedStorage.Network:WaitForChild("Gym_Rebirth")

-- Removing egg animation
local EggScript = player.PlayerScripts:WaitForChild("Scripts"):WaitForChild("Game"):WaitForChild("Egg Opening Frontend")
getsenv(EggScript).PlayEggAnimation = function() return end

-- Enter gym event
local function EnterGymEvent()
    setthreadidentity(2)
    pcall(function()
        InstancingCmds.Enter("GymEvent")
    end)
    setthreadidentity(7)
end

EnterGymEvent()
--auto run auto 
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Gym_Auto"):FireServer(true)
--auto reconnect
-- Auto Reconnect Script for Roblox
-- Place this in an auto-execute script in your executor

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TeleportService = game:GetService("TeleportService")

local placeId = game.PlaceId
local jobId = game.JobId
local reconnectAttempts = 0
local maxReconnectAttempts = 5
local reconnectDelay = 5 -- seconds between attempts

local function reconnect()
    if reconnectAttempts >= maxReconnectAttempts then
        warn("Max reconnect attempts reached. Giving up.")
        return
    end
    
    reconnectAttempts = reconnectAttempts + 1
    print("Attempting to reconnect (Attempt "..reconnectAttempts.."/"..maxReconnectAttempts..")")
    
    local success, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
    end)
    
    if not success then
        warn("Reconnect failed: "..tostring(err))
        task.wait(reconnectDelay)
        reconnect()
    end
end

local function onDisconnected(code)
    warn("Disconnected from game (Code: "..code.."). Attempting to reconnect...")
    reconnect()
end

-- Set up connection monitoring
LocalPlayer.OnTeleport:Connect(function(teleportState)
    if teleportState == Enum.TeleportState.Failed then
        warn("Teleport failed. Attempting to reconnect...")
        reconnect()
    end
end)

game:GetService("NetworkClient").Disconnected:Connect(onDisconnected)

print("Auto-reconnect script loaded. Will attempt to reconnect if disconnected.")
-- Auto buy all zones
task.spawn(function()
    while true do
        for Zones = 1, 5 do
            pcall(function()
                ZonePurchase:InvokeServer("GymEvent", Zones)
            end)
        end
        task.wait(1)
    end
end)

-- Auto rebirth
task.spawn(function()
    while true do
        pcall(function()
            GymRebirth:InvokeServer()
        end)
        task.wait(1)
    end
end)


-- Auto start (start infinite mode)
task.spawn(function()
    while true do
        pcall(function()
            Start:InvokeServer()
        end)
        task.wait()
    end
end)

-- Auto train
while true do 
    wait()
local args = {
    [1] = {
        ["Stamina"] = 28,
        ["CritChance"] = 19,
        ["Strength"] = 53
    }
}

game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Gym_SettingsUpdate"):FireServer(unpack(args))
end
--Go Area 5
local args = {
    [1] = "__Zone_5"
}

game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Teleports_RequestInstanceTeleport"):InvokeServer(unpack(args))

-- Find nearest egg
local function find_nearest_egg()
    local nearestEgg, nearestDistance = nil, math.huge
    local eggsFolder = workspace.__THINGS:FindFirstChild("CustomEggs")
    if not eggsFolder then return nil end

    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, eggModel in ipairs(eggsFolder:GetChildren()) do
        if eggModel:IsA("Model") then
            local success, cframe = pcall(function()
                return eggModel:GetBoundingBox()
            end)
            if success and cframe then
                local dist = (hrp.Position - cframe.Position).Magnitude
                if dist < nearestDistance then
                    nearestEgg = eggModel.Name
                    nearestDistance = dist
                end
            end
        end
    end

    return nearestEgg
end

-- Auto hatch nearest egg
_G.AutoOpen = true
task.spawn(function()
    while task.wait() do
        if _G.AutoOpen then
            local nearestEgg = find_nearest_egg()
            if nearestEgg then
                pcall(function()
                    Network.Invoke("CustomEggs_Hatch", nearestEgg, GetMaxEggsToHatch)
                end)
            end
        end
    end
end)
--Auto Free gift
while true do
    wait()
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Redeem Free Gift"):InvokeServer(1)
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Redeem Free Gift"):InvokeServer(2)
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Redeem Free Gift"):InvokeServer(3)
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Redeem Free Gift"):InvokeServer(4)
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Redeem Free Gift"):InvokeServer(5)
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Redeem Free Gift"):InvokeServer(6)
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Redeem Free Gift"):InvokeServer(7)
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Redeem Free Gift"):InvokeServer(8)
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Redeem Free Gift"):InvokeServer(9)
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Redeem Free Gift"):InvokeServer(10)
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Redeem Free Gift"):InvokeServer(11)
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Redeem Free Gift"):InvokeServer(12)
end

--auto claim daycare
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Daycare: Claim"):InvokeServer()
local args = {
    [1] = {
        ["ce8773f7db9f4b7ebf23845241355723"] = 10
    }
}

game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Daycare: Enroll"):InvokeServer(unpack(args))

-- Dimmed White Screen with Performance Stats
local function EnhancedDimmedScreen()
    -- ===== [1] REMOVE EXISTING GUIs =====
    local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and not gui.Name:find("EnhancedDimmed") then
            gui:Destroy()
        end
    end

    -- ===== [2] CREATE DIM WHITE OVERLAY =====
    local dimGui = Instance.new("ScreenGui")
    dimGui.Name = "EnhancedDimmedScreen"
    dimGui.IgnoreGuiInset = true
    dimGui.DisplayOrder = 99999
    
    local dimFrame = Instance.new("Frame")
    dimFrame.Size = UDim2.new(1, 0, 1, 0)
    dimFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dimFrame.BackgroundTransparency = 0.2
    dimFrame.BorderSizePixel = 0
    dimFrame.Parent = dimGui

    -- ===== [3] CREATE STATUS TEXTS =====
    local startTime = os.time()
    local textContainer = Instance.new("Frame")
    textContainer.Size = UDim2.new(1, 0, 0, 100)
    textContainer.Position = UDim2.new(0, 0, 0.5, -50)
    textContainer.BackgroundTransparency = 1
    textContainer.Parent = dimFrame

    local doneText = Instance.new("TextLabel")
    doneText.Text = "Everything Done ✅"
    doneText.TextColor3 = Color3.new(1, 1, 1)
    doneText.TextSize = 24
    doneText.Size = UDim2.new(1, 0, 0, 30)
    doneText.Position = UDim2.new(0, 0, 0, 0)
    doneText.BackgroundTransparency = 1
    doneText.Font = Enum.Font.SourceSansBold
    doneText.Parent = textContainer

    local timeText = Instance.new("TextLabel")
    timeText.Text = "Running Time: 0 hours 0 minutes 0 seconds"
    timeText.TextColor3 = Color3.new(1, 1, 1)
    timeText.TextSize = 18
    timeText.Size = UDim2.new(1, 0, 0, 25)
    timeText.Position = UDim2.new(0, 0, 0, 35)
    timeText.BackgroundTransparency = 1
    timeText.Parent = textContainer

    local fpsText = Instance.new("TextLabel")
    fpsText.Text = "0 FPS"
    fpsText.TextColor3 = Color3.new(1, 1, 1)
    fpsText.TextSize = 18
    fpsText.Size = UDim2.new(1, 0, 0, 25)
    fpsText.Position = UDim2.new(0, 0, 0, 65)
    fpsText.BackgroundTransparency = 1
    fpsText.Parent = textContainer

    dimGui.Parent = playerGui

    -- ===== [4] PERFORMANCE OPTIMIZATIONS =====
    settings().Rendering.QualityLevel = 1
    game:GetService("Lighting").Technology = "Legacy"
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("SoundService").Volume = 0

    -- ===== [5] REAL-TIME UPDATES =====
    local runService = game:GetService("RunService")
    local lastTick = os.clock()
    local frames = 0
    local fps = 0

    runService.Heartbeat:Connect(function()
        -- Update runtime
        local elapsed = os.time() - startTime
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = elapsed % 60
        timeText.Text = string.format("Running Time: %d hours %d minutes %d seconds", hours, minutes, seconds)

        -- Calculate FPS
        frames = frames + 1
        if os.clock() - lastTick >= 1 then
            fps = frames
            frames = 0
            lastTick = os.clock()
        end
        fpsText.Text = string.format("%d FPS", fps)
    end)
end

-- Run with error handling
local success, err = pcall(EnhancedDimmedScreen)
if not success then
    warn("Error creating enhanced screen: "..err)
else
    print("✅ Enhanced Dimmed Screen Active")
end
