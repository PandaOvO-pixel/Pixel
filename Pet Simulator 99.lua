local PetSim99IDs = {
    95635359880599,  -- Fishing World
    16498369169,     -- Tech World
    8737899170       -- Spawn World
}

if table.find(PetSim99IDs, game.PlaceId) then

    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    local Window = Library.CreateLib("Pet Simulator 99 - Script by user10.27", "BloodTheme")

    -- TABS
    local Tab0 = Window:NewTab("Main")
    local Tab1 = Window:NewTab("Fishing Event")
    local Tab2 = Window:NewTab("Auto Farm")

    local function AutoCollect()
    local function ConnectLoot(folder, eventName)
        if folder then
            folder.ChildAdded:Connect(function(item)
                task.wait()
                pcall(function()
                    Network.Fire(eventName, {item.Name})
                    item:Destroy()
                end)
            end)
        end
    end

    ConnectLoot(workspace.__THINGS:FindFirstChild("Lootbags"), 'Lootbags_Claim')
    ConnectLoot(workspace.__THINGS:FindFirstChild("Orbs"), 'Orbs: Collect')
    end

    --Main Tab
    local Section0 = Tab0:NewSection("Main (Auto Function)")
    local Section1 = Tab1:NewSection("Auto Farm 👑")

    --Auto Collect Free Rewards Gift
    Section0:NewToggle("Auto Collect Free Gifts", Nil, function(v)
        getgenv().autogifts = v
        while true do
            if not getgenv().autogifts then return end
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
            wait(0.5)
        end
    end)
    --Auto Claim Rank Rewards
    Section0:NewToggle("Auto Claim Rank Rewards", Nil, function(v)
        getgenv().autorankrewards = v
        while true do
            if not getgenv().autorankrewards then return end
            local Remote = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Ranks_ClaimReward")
            for i = 1, 50 do
                Remote:FireServer(i)
                task.wait(0.1)
            end
        end
    end)
    --Auto Collect Orbs
    Section1:NewToggle("Auto Collect Orbs", Nil, function(v)
        getgenv().autoorbs = v
        while true do
            if not getgenv().autoorbs then return end            
            AutoCollect()
            end
        end
    end)
    --Inf Pet Speed(tp breakable)
    Section1:NewToggle("Inf Pet Speed (TP Breakable)", Nil, function(v)
        getgenv().infpetspeed = v
        while true do
            if not getgenv().infpetspeed then return end
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local PlayerPet = require(ReplicatedStorage.Library.Client.PlayerPet)
            hookfunction(PlayerPet.CalculateSpeedMultiplier, function() return 250 end)
            end
        end
    end)


    --Fishing Event Menu
    local Section1 = Tab1:NewSection("Fishing Event")

    --Auto TP Best Area Included Kraken/Whirlpool
    Section1:NewToggle("Auto Teleport To AREA 6 (The Kraken / Whirlpool)", nil, function(state)
       if state then
            -- Finding Best Whirlpool
               local function extractPercent(text)
               local num = string.match(text, "(%d+)%s*%%")
        return tonumber(num) or 0
        end

        local function getCharacter()
        return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        end

    local character = getCharacter()
    -- Whirlpool + Kraken Finder
    task.spawn(function()
        while true do
            local poiFolder = workspace:FindFirstChild("__THINGS")
            local Whirlpool, bestValue, Kraken = nil, -1, nil

            if poiFolder then
                local eventFishing = poiFolder:FindFirstChild("EventFishingPOIs")
                if eventFishing then
                    for _, child in ipairs(eventFishing:GetChildren()) do
                        if child:IsA("Model") then
                            local whirl = child:FindFirstChild("whirlpool")
                            local label = child:FindFirstChild("Billboard")
                                and child.Billboard:FindFirstChild("BillboardGui")
                                and child.Billboard.BillboardGui:FindFirstChild("DescLabel")

                            if whirl and label and label:IsA("TextLabel") then
                                local value = extractPercent(label.Text)
                                if value > bestValue then
                                    bestValue = value
                                    Whirlpool = whirl
                                end
                            end

                            if child:FindFirstChild("Beam") then
                                Kraken = child.Beam
                            end
                        end
                    end
                end
            end

            -- Whirlpool + Kraken Functions
            if Whirlpool then
                if lastTarget ~= Whirlpool or bestValue > lastLuck then
                    character:PivotTo(Whirlpool.CFrame + Vector3.new(0, 5, 0))
                    lastTarget = Whirlpool
                    lastLuck = bestValue
                    tp = true
                end
            elseif Kraken then
                if lastTarget ~= Kraken then
                    character:PivotTo(Kraken.CFrame + Vector3.new(0, 5, 0))
                    lastTarget = Kraken
                    lastLuck = -1
                    tp = true
                end
            else
                -- IF NO WHIRLPOOL/KRAKEN = Tp To Island 6
                local emitter = poiFolder
                    and poiFolder:FindFirstChild("__INSTANCE_CONTAINER")
                    and poiFolder.__INSTANCE_CONTAINER:FindFirstChild("Active")
                    and poiFolder.__INSTANCE_CONTAINER.Active:FindFirstChild("FishingEvent")
                    and poiFolder.__INSTANCE_CONTAINER.Active.FishingEvent:FindFirstChild("Island 6")
                    and poiFolder.__INSTANCE_CONTAINER.Active.FishingEvent["Island 6"]
                        :FindFirstChild("IslandBuild")
                        :FindFirstChild("SnowEmitter")

                if emitter and lastTarget ~= emitter then
                    local basePos = emitter.Position
                    character:PivotTo(CFrame.new(basePos + Vector3.new(0, 5, 0)))

                    task.wait(1)

                    character:PivotTo(CFrame.new(Vector3.new(basePos.X - 26, basePos.Y + 5, basePos.Z - 90)))
                    lastTarget = emitter
                    lastLuck = -1
                    tp = true
                end
            end

            if not tp then
               -- Stay In Current Place If No better Target (Kraken/Whirlpool)
            end

            task.wait(5)
        end
    end)

    task.wait(1)

    -- Mouse Click To Close Boat GUI
    vim:SendMouseButtonEvent(1290, 200, 0, true, game, 0)
    vim:SendMouseButtonEvent(1290, 200, 0, false, game, 0)
       else
           print("Toggle Off")
       end
    end)

end